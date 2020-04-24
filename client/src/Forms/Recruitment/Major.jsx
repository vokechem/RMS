import React, { Component } from "react";
import swal from "sweetalert";
import Table from "./../../Table";
import TableWrapper from "./../../TableWrapper";
import Select from "react-select";
import { Progress } from "reactstrap";
import axios from "axios";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import ReactExport from "react-data-export";
var dateFormat = require("dateformat");
var jsPDF = require("jspdf");
require("jspdf-autotable");
class Major extends Component {
  constructor() {
    super();
    this.state = {
      Major: [],
      Facility: [],
      Registration:[],
      privilages: [],
      profile: true,
      MedicalFacilty:"",
      IDNumber: "",
      FullName:"",
      Number:"",
      Number:"",
      MedicalFacility:"",
      MedicalResults:"",
      DOM:"",
      MCertificate: "",
      DOC: "",
      Cost: "4000",
      Type:"",
      RepeatCost:"",
      Other:"",
      ID:"",
      MedID:"",
      isUpdate: false,
      selectedFile: null
    };

    this.Resetsate = this.Resetsate.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
  }
  showDiv() {
    document.getElementById("nav-profile-tab").click();
  }
  handleswitchMenu = e => {
    e.preventDefault();
    if (this.state.profile === false) {
      this.setState({ profile: true });
    } else {
      this.setState({ profile: false });
    }

    //this.setnewstate();
  };
  handleSelectChange = (Facility, actionMeta) => {
    if (actionMeta.name == "MedicalFacility") {
      this.setState({ MedID: Facility.value });
      this.setState({ [actionMeta.name]: Facility.label });
    } else {
      this.setState({ IDNumber: Facility.value });
      this.setState({ [actionMeta.name]: Facility.label });
    }
  };
  fetchRegistration = () => {
    fetch("/api/Registration", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Registration => {
        if (Registration.length > 0) {
          this.setState({ Registration: Registration });
        } else {
          swal("", Registration.message, "error");
        }
      })
      .catch(err => {
        swal("", err.message, "error");
      });
  };
  fetchFacility = () => {
    fetch("/api/Facility", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Facility => {
        if (Facility.length > 0) {
          this.setState({ Facility: Facility });
        } else {
          swal("Oops!", Facility.message, "error");
        }
      })
      .catch(err => {
        swal("Oops!", err.message, "error");
      });
  };

  handleInputChange = event => {
    // event.preventDefault();
    // this.setState({ [event.target.name]: event.target.value });
    const target = event.target;
    const value = target.type === "checkbox" ? target.checked : target.value;
    const name = target.name;
    if (name === "PostalCode") {
      this.fetchTown(value);
    }
    this.setState({ [name]: value });
  };
  Resetsate() {
    const data = {
        IDNumber: "",
        FullName:"",
        Number:"",
        MedicalFacility:"",
        MedicalResults:"",
        DOM:"",
        MCertificate: "",
        DOC: "",
        Cost: "4000",
        Type:"",
        RepeatCost:"",
        Other:"",
        ID:"",
        MedID:"",
      isUpdate: false,
    
    };
    this.setState(data);
  }
  fetchMajor = () => {
    fetch("/api/Major", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Major => {
        if (Major.length > 0) {
          this.setState({ Major: Major });
        } else {
          swal("", Major.message, "error");
        }
      })
      .catch(err => {
        swal("", err.message, "error");
      });
  };
  componentWillUnmount() {}
  componentDidMount() {
    let token = localStorage.getItem("token");
    if (token == null) {
     
      localStorage.clear();
      return (window.location = "/#/Logout");
    } else {
      fetch("/api/ValidateTokenExpiry", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(response =>
          response.json().then(data => {
            if (data.success) {
              this.fetchMajor();
              this.fetchRegistration();
              this.fetchFacility();
              this.ProtectRoute();
            } else {
              localStorage.clear();
              return (window.location = "/#/Logout");
            }
          })
        )
        .catch(err => {
          localStorage.clear();
          return (window.location = "/#/Logout");
        });
    }
   
  }
  handleSubmit = event => {
    event.preventDefault();
    const data = {
      Number: this.state.Number,
      MedicalFacility: this.state.MedicalFacility,
      MedicalResults: this.state.MedicalResults,
      DOM:this.state.DOM,
      MCertificate:this.state.MCertificate,
      DOC:this.state.DOC,
      Cost: this.state.Cost,
      Type:this.state.Type,
      RepeatCost:this.state.RepeatCost,
      Other:this.state.RepeatCost,
    };

    if (this.state.isUpdate) {
      this.UpdateData("/api/Major/" + this.state.ID, data);
    } else {
      this.postData("/api/Major", data);
    }
  };
  handleEdit = Major => {
 
    const data = {
      Number: Major.Number,
      MedicalFacility: Major.MedicalFacility,
      MedicalResults: Major.MedicalResults,
      DOM: dateFormat(
        new Date(Major.DOM).toLocaleDateString(),
        "isoDate"
      ),
      MCertificate: Major.MCertificate,
      DOC: dateFormat(
        new Date(Major.DOC).toLocaleDateString(),
        "isoDate"
      ),
      Cost: Major.Cost,
      Type:Major.Type,
      RepeatCost:Major.RepeatCost,
      Other:Major.Other,
      ID:Major.ID
    };

    this.setState(data);
    if (this.state.profile === false) {
      this.setState({ profile: true });
    } else {
      this.setState({ profile: false });
    }
    this.setState({ isUpdate: true });
  };
  exportpdf = () => {
    var columns = [
      { title: "Fullname", dataKey: "Fullname" },
      { title: "IDNumber", dataKey: "IDNumber" },
      { title: "Cost", dataKey: "Cost" },
      { title: "MedicalFacility", dataKey: "MedicalFacility" },
    
    ];

    const rows = [...this.state.Major];

    var doc = new jsPDF("p", "pt", "a2", "portrait");

    doc.autoTable(columns, rows, {
      margin: { top: 60 },
      beforePageContent: function(data) {
        doc.text("RMS Major Medical", 40, 50);
      }
    });
    doc.save("RMS Major medical.pdf");
  };
  ProtectRoute() {
    fetch("/api/UserAccess", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(data => {
        this.setState({ privilages: data });
      })
      .catch(err => {
        //this.setState({ loading: false, redirect: true });
      });
    //end
  }
  validaterole = (rolename, action) => {
    let array = [...this.state.privilages];
    let AuditTrailsObj = array.find(obj => obj.RoleName === rolename);
    if (AuditTrailsObj) {
      if (action === "AddNew") {
        if (AuditTrailsObj.AddNew) {
          return true;
        } else {
          return false;
        }
      } else if (action === "View") {
        if (AuditTrailsObj.View) {
          return true;
        } else {
          return false;
        }
      } else if (action === "Edit") {
        if (AuditTrailsObj.Edit) {
          return true;
        } else {
          return false;
        }
      } else if (action === "Export") {
        if (AuditTrailsObj.Export) {
          return true;
        } else {
          return false;
        }
      } else if (action == "Remove") {
        if (AuditTrailsObj.Remove) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  };
  handleDelete = k => {
    swal({
      
      text: "Are you sure that you want to delete this record?",
      icon: "warning",
      dangerMode: true,
      buttons: true,
    }).then(willDelete => {
      if (willDelete) {
        return fetch("/api/Major/" + k, {
          method: "Delete",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(response =>
            response.json().then(data => {
              if (data.success) {
                swal("", "Record has been deleted!", "success");
                this.Resetsate();
              } else {
                swal("", data.message, "error");
              }
              this.fetchMajor();
            })
          )
          .catch(err => {
            swal("", err.message, "error");
          });
      }
    });
  };
  UpdateData(url = ``, data = {}) {
    fetch(url, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      },
      body: JSON.stringify(data)
    })
      .then(response =>
        response.json().then(data => {
          this.fetchMajor();

          if (data.success) {
            swal("", "Record has been Updated!", "success");
            this.Resetsate();
            if (this.state.profile === false) {
              this.setState({ profile: true });
            } else {
              this.setState({ profile: false });
            }
          } else {
            swal("", data.message, "error");
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  }
  postData(url = ``, data = {}) {
    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      },
      body: JSON.stringify(data)
    })
      .then(response =>
        response.json().then(data => {
          this.fetchMajor();

          if (data.success) {
            swal("", "Record has been saved!", "success");
            this.setState({ open: false });
            if (this.state.profile === false) {
              this.setState({ profile: true });
            } else {
              this.setState({ profile: false });
            }
            this.Resetsate();
          } else {
            swal("", data.message, "error");
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  }
  render() {
    const ExcelFile = ReactExport.ExcelFile;
    const ExcelSheet = ReactExport.ExcelFile.ExcelSheet;
    const ExcelColumn = ReactExport.ExcelFile.ExcelColumn;
    const Registration = [...this.state.Registration].map((k, i) => {
      return {
        value: k.IDNumber,
        label: k.IDNumber
      };
    });
    const Facility = [...this.state.Facility].map((k, i) => {
      return {
        value: k.MedID,
        label: k.Name
      };
    });
    let Results = [
        {
            value: "Pass",
            label: "Pass"
          },
      {
        value: "Fail",
        label: "Fail"
      },
    
    ];
    let TypeOption = [
      {
          value: "New",
          label: "New"
        },
    {
      value: "Repeat",
      label: "Repeat"
    },
  
  ];
    let Certifcate = [
        {
          value: "Issued",
          label: "Issued"
        },
        {
          value: "Pending",
          label: "Pending"
        }
      ];
    const ColumnData = [
      {
        label: "Fullname",
        field: "Fullname",
        sort: "asc"
      },
      {
        label: "IDNumber",
        field: "IDNumber",
        sort: "asc"
      },
      {
        label: "DOM",
        field: "DOM",
        sort: "asc"
      },
      {
        label: "MedicalFacility",
        field: "MedicalFacility",
        sort: "asc"
      },
      {
        label: "MCertificate",
        field: "MCertificate",
        sort: "asc"
      },
      {
        label: "DOC",
        field: "DOC",
        sort: "asc"
      },
      {
        label: "Type",
        field: "Type",
        sort: "asc"
      },
      {
        label: "Cost",
        field: "Cost",
        sort: "asc"
      },
      {
        label: "action",
        field: "action",
        sort: "asc",
        width: 200
      }
    ];
    let Rowdata1 = [];
    const rows = [...this.state.Major];
    if (rows.length > 0) {
      rows.map((k, i) => {
        let Rowdata = {
          IDNumber: k.IDNumber,
          Fullname: k.Fullname,
          DOM: new Date(k.DOM).toLocaleDateString(),
          MedicalFacility: k.MedicalFacility,
          MCertificate:k.MCertificate,
          Type:k.Type,
          DOC:new Date(k.DOM).toLocaleDateString(),
          Cost: k.Cost,
          action: (
            <span>
              <a
                className="fa fa-edit"
                style={{ color: "#007bff" }}
                onClick={e => this.handleEdit(k, e)}
              >
                {" "}
                Edit
              </a>
              |{" "}
              <a
                className="fa fa-trash"
                style={{ color: "#f44542" }}
                onClick={e => this.handleDelete(k.ID, e)}
              >
                {" "}
                Delete
              </a>
            </span>
          )
        };
        Rowdata1.push(Rowdata);
      });
    }
    let Signstyle = {
      height: 100,
      width: 150
    };
    let divconatinerstyle = {
      width: "95%",
      margin: "0 auto",
      backgroundColor: "white"
    };
    let formcontainerStyle = {
      border: "1px solid grey",
      "border-radius": "10px"
    };
    let FormStyle = {
      margin: "20px"
    };
    if (this.state.profile) {
      return (
        <div>
          <div>
            <div className="row wrapper border-bottom white-bg page-heading">
              <div className="col-lg-9">
                <ol className="breadcrumb">
                  <li className="breadcrumb-item">
                    <h2>Major Medical</h2>
                  </li>
                </ol>
              </div>
              <div className="col-lg-3">
                <div className="row wrapper ">
                  {this.validaterole("Major Medical", "AddNew") ? (
                    <button
                      type="button"
                      style={{ marginTop: 40 }}
                      onClick={this.handleswitchMenu}
                      className="btn btn-primary float-right fa fa-plus"
                    >
                      &nbsp; New
                    </button>
                  ) : null}
                  &nbsp;
                  {this.validaterole("Major Medical", "Export") ? (
                    <button
                      onClick={this.exportpdf}
                      type="button"
                      style={{ marginTop: 40 }}
                      className="btn btn-primary float-left fa fa-file-pdf-o fa-2x"
                    >
                      &nbsp;PDF
                    </button>
                  ) : null}
                  &nbsp;
                  {this.validaterole("Major Medical", "Export") ? (
                    <ExcelFile
                      element={
                        <button
                          type="button"
                          style={{ marginTop: 40 }}
                          className="btn btn-primary float-left fa fa-file-excel-o fa-2x"
                        >
                          &nbsp; Excel
                        </button>
                      }
                    >
                      <ExcelSheet data={rows} name="Major Medical">
                        <ExcelColumn label="Fullname" value="Fullname" />
                        <ExcelColumn label="IDNumber" value="IDNumber" />
                        <ExcelColumn label="MedicalFacility" value="MedicalFacility" />
                        <ExcelColumn label="Cost" value="Cost" />
                      </ExcelSheet>
                    </ExcelFile>
                  ) : null}
                </div>
              </div>
            </div>
          </div>

          <TableWrapper>
            <Table Rows={Rowdata1} columns={ColumnData} />
          </TableWrapper>
        </div>
      );
    } else {
      return (
        <div>
          <div className="row wrapper border-bottom white-bg page-heading">
            <div className="col-lg-10">
              <ol className="breadcrumb">
                <li className="breadcrumb-item">
                  <h2>Major medical</h2>
                </li>
              </ol>
            </div>
            <div className="col-lg-2">
              <div className="row wrapper ">
                <button
                  type="button"
                  style={{ marginTop: 40 }}
                  onClick={this.handleswitchMenu}
                  className="btn btn-primary"
                >
                  &nbsp; Back
                </button>
              </div>
            </div>
          </div>
          <br />
          <div style={divconatinerstyle}>
            <ToastContainer />
            <div style={formcontainerStyle}>
              <div class="col-sm-12">
                <form style={FormStyle} onSubmit={this.handleSubmit}>
                  <div class="row">
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                       ID Number
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="Number"
                        value={Registration.filter(
                          option => option.label === this.state.Number
                        )}
                        onChange={this.handleSelectChange}
                        options={Registration}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                        Medical Facility
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="MedicalFacility"
                        value={Facility.filter(
                          option => option.label === this.state.MedicalFacility
                        )}
                        onChange={this.handleSelectChange}
                        options={Facility}
                        required
                      />
                    </div>
                  </div>
                  <br />

                  <div class="row">
                  <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Type
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="Type"
                        value={TypeOption.filter(
                          option => option.label === this.state.Type
                        )}
                        onChange={this.handleSelectChange}
                        options={TypeOption}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Medical Result
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="MedicalResults"
                        value={Results.filter(
                          option => option.label === this.state.MedicalResults
                        )}
                        onChange={this.handleSelectChange}
                        options={Results}
                        required
                      />
                    </div>
                  </div>
                  <div class="row">
                  <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Date OF medical
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <input
                        type="date"
                        class="form-control"
                        name="DOM"
                        onChange={this.handleInputChange}
                        value={this.state.DOM}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Medical Certificate
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="MCertificate"
                        value={Certifcate.filter(
                          option => option.label === this.state.MCertificate
                        )}
                        onChange={this.handleSelectChange}
                        options={Certifcate}
                        required
                      />
                    </div>
                    </div>
                    <br/>  
                    <div class="row">
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Date OF Certifcate issue
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <input
                        type="date"
                        class="form-control"
                        name="DOC"
                        onChange={this.handleInputChange}
                        value={this.state.DOC}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Other Cost
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <input
                        type="number"
                        class="form-control"
                        name="Other"
                        onChange={this.handleInputChange}
                        value={this.state.Other}
                    
                      />
                    </div>
                      </div>
                    <br/>
                  <div className=" row">
                    <div className="col-sm-2" />
                    <div className="col-sm-8" />
                    <div className="col-sm-2">
                      <button
                        className="btn btn-primary float-right"
                        type="submit"
                      >
                        Save
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      );
    }
  }
}

export default Major;
