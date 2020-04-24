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
class Contract extends Component {
  constructor() {
    super();
    this.state = {
      Contract: [],
      Facility: [],
      Registration:[],
      privilages: [],
      profile: true,
      Number:"",
    Contract_status:"",
      Cost: "0",
      EmployerName:"",
      EmployerID:"",
      EmployerContact:"",
      EmployerAddress:"",
      VisaNumber:"",
      ContractNumber:"",
      ID:"",
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
        Number:"",
        Contract_status:"",
          Cost: "1000",
          ID:"",
      isUpdate: false,
    
    };
    this.setState(data);
  }
  fetchContract = () => {
    fetch("/api/Contract", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Contract => {
        if (Contract.length > 0) {
          this.setState({ Contract: Contract });
        } else {
          swal("", Contract.message, "error");
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
              this.fetchContract();
              this.fetchRegistration();
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
      Contract_status: this.state.Contract_status,
      Cost: this.state.Cost,
      EmployerName:this.state.EmployerName,
      EmployerID:this.state.EmployerID,
      EmployerContact:this.state.EmployerContact,
      EmployerAddress:this.state.EmployerAddress,
      VisaNumber:this.state.VisaNumber,
      ContractNumber:this.state.VisaNumber,
    };

    if (this.state.isUpdate) {
      this.UpdateData("/api/Contract/" + this.state.ID, data);
    } else {
      this.postData("/api/Contract", data);
    }
  };
  handleEdit = Contract => {
 
    const data = {
      Number: Contract.Number,
      Contract_status: Contract.Contract_status,
      Cost: Contract.Cost,
      EmployerName:Contract.EmployerName,
      EmployerID:Contract.EmployerID,
      EmployerContact:Contract.EmployerContact,
      EmployerAddress:Contract.EmployerAddress,
      VisaNumber:Contract.VisaNumber,
      ContractNumber:Contract.ContractNumber,
      ID:Contract.ID
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
      { title: "EmployerName", dataKey: "EmployerName" },
      { title: "EmployerID", dataKey: "EmployerID" },
      { title: "EmployerContact", dataKey: "EmployerContact" },
      { title: "EmployerAddress", dataKey: "EmployerAddress" },
      { title: "VisaNumber", dataKey: "VisaNumber" },
      { title: "ContractNumber", dataKey: "ContractNumber" },
      { title: "Contract_status", dataKey: "Contract_status" },
    
    ];

    const rows = [...this.state.Contract];

    var doc = new jsPDF("p", "pt", "a2", "portrait");

    doc.autoTable(columns, rows, {
      margin: { top: 60 },
      beforePageContent: function(data) {
        doc.text("RMS Contract Processing", 40, 50);
      }
    });
    doc.save("RMS Contract Processing.pdf");
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
        return fetch("/api/Contract/" + k, {
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
              this.fetchContract();
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
          this.fetchContract();

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
          this.fetchContract();

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
    let Contract = [
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
        label: "EmployerName",
        field: "EmployerName",
        sort: "asc"
      },
      {
        label: "EmployerID",
        field: "EmployerID",
        sort: "asc"
      },
      {
        label: "EmployerContact",
        field: "EmployerContact",
        sort: "asc"
      },
      {
        label: "VisaNumber",
        field: "VisaNumber",
        sort: "asc"
      },
      {
        label: "ContractNumber",
        field: "ContractNumber",
        sort: "asc"
      },
      {
        label: "Contract_status",
        field: "Contract_status",
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
    const rows = [...this.state.Contract];
    if (rows.length > 0) {
      rows.map((k, i) => {
        let Rowdata = {
          IDNumber: k.IDNumber,
          Fullname: k.Fullname,
          Contract_status: k.Contract_status,
          Cost: k.Cost,
          EmployerName:k.EmployerName,
          EmployerID:k.EmployerID,
          EmployerContact:k.EmployerContact,
          EmployerAddress:k.EmployerAddress,
          VisaNumber:k.VisaNumber,
          ContractNumber:k.ContractNumber,  
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
                    <h2>Contract Processing</h2>
                  </li>
                </ol>
              </div>
              <div className="col-lg-3">
                <div className="row wrapper ">
                  {this.validaterole("Contract Processing", "AddNew") ? (
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
                  {this.validaterole("Contract Processing", "Export") ? (
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
                  {this.validaterole("Contract Processing", "Export") ? (
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
                      <ExcelSheet data={rows} name="Contract Processing">
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
                  <h2>Contract Processing</h2>
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
                   Employer Name
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="EmployerName"
                        onChange={this.handleInputChange}
                        value={this.state.EmployerName}
                        required
                      />
                    </div>
                  </div>
                  <br/>
                  <div class="row">
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                      Employer IDNo
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="EmployerID"
                        onChange={this.handleInputChange}
                        value={this.state.EmployerID}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                      Employer Contact
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="EmployerContact"
                        onChange={this.handleInputChange}
                        value={this.state.EmployerContact}
                        required
                      />
                    </div>
                  </div>
                  <br/>
                  <div class="row">
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                      Employer Address
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="EmployerAddress"
                        onChange={this.handleInputChange}
                        value={this.state.EmployerAddress}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                      Visa Number
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="VisaNumber"
                        onChange={this.handleInputChange}
                        value={this.state.VisaNumber}
                        required
                      />
                    </div>
                  </div>
                  <br/>
                  <div class="row">
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                      Contract Number
                      </label>
                    </div>
                    <div class="col-sm-4">
                    <input
                        type="text"
                        class="form-control"
                        name="ContractNumber"
                        onChange={this.handleInputChange}
                        value={this.state.ContractNumber}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="Number" className="font-weight-bold">
                       Contract status
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="Contract_status"
                        value={Contract.filter(
                          option => option.label === this.state.Contract_status
                        )}
                        onChange={this.handleSelectChange}
                        options={Contract}
                        required
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

export default Contract;
