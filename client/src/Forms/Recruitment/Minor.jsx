import React, { Component } from "react";
import swal from "sweetalert";
import Table from "./../../Table";
import TableWrapper from "./../../TableWrapper";
import Select from "react-select";
import Modal from "react-awesome-modal";
import "react-toastify/dist/ReactToastify.css";
import ReactExport from "react-data-export";
var dateFormat = require("dateformat");
var jsPDF = require("jspdf");
require("jspdf-autotable");
class Minor extends Component {
  constructor() {
    super();
    this.state = {
      Minor: [],
      Facility: [],
      Registration:[],
      privilages: [],
      profile: true,
      MedicalFacilty:"",
      IDNumber: "",
      FullName:"",
      Number:"",
      Phone:"",
      DOM:"",
      Cost:"500",
      Resuit:"",
      Type:"",
      RepeatCost:"",
      Others:"0",
      ID: "",
      Status:"",
      MedID:"",
      isUpdate: false,
      selectedFile: null
    };
    this.Resetsate = this.Resetsate.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
  }
  showDiv() {
    document.getElementById("nav-profile-tab").click();
  }
  openModal() {
    this.setState({ open: true });
    this.Resetsate();
  }
  closeModal = () => {
    this.setState({ open: false });
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
      MedicalFacilty:"",
      IDNumber: "",
      FullName:"",
      Number:"",
      Phone:"",
      DOM:"",
      Cost:"500",
      Resuit:"",
      Type:"",
      RepeatCost:"",
      Others:"",
      ID: "",
      isUpdate: false,
      PIN: "",
      Companyregistrationdate: "",
      RegistrationNo: ""
    };
    this.setState(data);
  }
  fetchMinor = () => {
    fetch("/api/Minor", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Minor => {
        if (Minor.length > 0) {
          this.setState({ Minor: Minor });
        } else {
          swal("", Minor.message, "error");
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
              this.fetchMinor();
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
      Result: this.state.Result,
      DOM:this.state.DOM,
      Cost: this.state.Cost,
      Type:this.state.Type,
      RepeatCost:this.state.RepeatCost,
      Others:this.state.Others  
    };
    if (this.state.isUpdate) {
      this.UpdateData("/api/Minor/" + this.state.ID, data);
    } else {
      this.postData("/api/Minor", data);
    }
  };
  handleEdit = Minor => {
    const data = {
      Number: Minor.Number,
      DOM: dateFormat(
        new Date(Minor.DOM).toLocaleDateString(),
        "isoDate"
      ),
      Result: Minor.Result,
      Cost: Minor.Cost,
      MedicalFacility: Minor.MedicalFacility,
      Type:Minor.Type,
      RepeatCost:Minor.RepeatCost,
      Others:Minor.Others,
      ID:Minor.ID
    };
    this.setState(data);
    this.setState({ open: true });
    this.setState({ isUpdate: true });
  };
  exportpdf = () => {
    var columns = [
      { title: "Fullname", dataKey: "Fullname" },
      { title: "IDNumber", dataKey: "IDNumber" },
      { title: "Cost", dataKey: "Cost" },
      { title: "MedicalFacility", dataKey: "MedicalFacility" },
    
    ];

    const rows = [...this.state.Minor];

    var doc = new jsPDF("p", "pt", "a2", "portrait");

    doc.autoTable(columns, rows, {
      margin: { top: 60 },
      beforePageContent: function(data) {
        doc.text("RMS Minor Medical", 40, 50);
      }
    });
    doc.save("RMS Minor medical.pdf");
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
        return fetch("/api/Minor/" + k, {
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
              this.fetchMinor();
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
        response.json()
        .then(data => {
          this.fetchMinor();
          if (data.success) {
            swal("", "Record has been Updated!", "success");
            this.setState({ open: false });
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
          this.fetchMinor();
          if (data.success) {
            swal("", "Record has been saved!", "success");
            this.setState({ open: false });
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
    let GenderCategories = [
      {
        value: "Fail",
        label: "Fail"
      },
      {
        value: "Pass",
        label: "Pass"
      },
      {
        value: "Pending",
        label: "Pending"
      }
    ];
    let TypeOption = [
      {
        value: "New",
        label: "New"
      },
      {
        value: "repeat",
        label: "repeat"
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
        label: "Phone",
        field: "Phone",
        sort: "asc"
      },
      {
        label: "MedicalFacility",
        field: "MedicalFacility",
        sort: "asc"
      },
      {
        label: "Date Of Medical",
        field: "DOM",
        sort: "asc"
      },
      {
        label: "Type",
        field: "Type",
        sort: "asc"
      },
      {
        label: "Status",
        field: "Status",
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
    const rows = [...this.state.Minor];
    if (rows.length > 0) {
      rows.map((k, i) => {
        let Rowdata = {
          IDNumber: k.IDNumber,
          Fullname: k.Fullname,
          DOM: new Date(k.DOM).toLocaleDateString(),
          Phone: k.Phone,
          Type:k.Type,
          MedicalFacility: k.MedicalFacility ,
          Status: k.Status,
          ID:k.ID,
          action: (
            <span>
              {this.validaterole("Minor Medical", "Edit") ? (
                <a
                  className="fa fa-edit"
                  style={{ color: "#007bff" }}
                  onClick={e => this.handleEdit(k, e)}
                >
                  Update |
                </a>
              ) : (
                <i>-</i>
              )}
              &nbsp;
              {this.validaterole("Minor Medical", "Remove") ? (
                <a
                  className="fa fa-trash"
                  style={{ color: "#f44542" }}
                  onClick={e => this.handleDelete(k.ID, e)}
                >
                  Delete
                </a>
              ) : (
                <i>-</i>
              )}
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
      return (
        <div class="app-content content">
        <div class="content-overlay"></div>
        <div class="header-navbar-shadow"></div>
        <div class="content-wrapper">
            <div class="content-header row">
                <div class="content-header-left col-md-9 col-12 mb-2">
                    <div class="row breadcrumbs-top">
                        <div class="col-12">
                            <h2 class="content-header-title float-left mb-0">Minor Medical</h2>
                            <div class="breadcrumb-wrapper col-12">
                                <ol class="breadcrumb">
                                  
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="content-header-right text-md-right col-md-3 col-12 d-md-block d-none">
                    <div class="form-group breadcrum-right">
                  {this.validaterole("Minor Medical", "AddNew") ? (
                <button
                  type="button"
                  onClick={this.openModal}
                  className="btn btn-success  fa fa-plus"
                >
                 New
                </button>
              ) : null}
              &nbsp;&nbsp;&nbsp;
              {this.validaterole("Minor Medical", "Export") ? (
                <button
                  type="button"
                  onClick={this.exportpdf}
                  className="btn btn-success fa fa-file-pdf-o"
                >
                  &nbsp;Export
                </button>
              ) : null}
           &nbsp;&nbsp;&nbsp;
              {this.validaterole("Minor Medical", "Export") ? (
                <ExcelFile
                  element={
                    <button
                      type="button"
                      className="btn btn-success  fa fa-file-excel-o "
                    >
                      &nbsp; Excel
                    </button>
                  }
                >
                  <ExcelSheet data={rows} name="Minor Medical">
                    <ExcelColumn label="Name" value="Name" />
                    <ExcelColumn label="Username" value="Username" />
                    <ExcelColumn label="Email" value="Email" />
                    <ExcelColumn label="Phone" value="Phone" />
                    <ExcelColumn label="IsActive" value="IsActive" />
                    <ExcelColumn label="UserGroup" value="UserGroup" />
                  </ExcelSheet>
                </ExcelFile>
              ) : null}
                    </div>
                </div>
            </div>
            <div class="content-body">
              
                <section id="description" class="card">
                    <div class="card-content">
                        <div class="card-body">
                            <div class="card-text">
                             Search
                            </div>
                        </div>
                    </div>
                </section>
                <section id="css-classes" class="card">
                    <div class="card-content">
                        <div class="card-body">
                            <div class="card-text">
                            <TableWrapper>
            <Table Rows={Rowdata1} columns={ColumnData} />
          </TableWrapper>
                            </div>
                            <Modal
                  visible={this.state.open}
                  width="1200"
                  height="300"
                  effect="fadeInUp"
                >
                  <a
                    style={{ float: "right", color: "red", margin: "10px" }}
                    href="javascript:void(0);"
                    onClick={() => this.closeModal()}
                  >
                    <i class="fa fa-close"></i>
                  </a>
                  <div>
                    <h4 style={{ "text-align": "center", color: "#1c84c6" }}>
                      {" "}
                      Minor medical
                    </h4>
                    <div className="container-fluid">
                      <div className="col-sm-12">
                        <div className="ibox-content">
                          <form onSubmit={this.handleSubmit}>
                          <div class="row">
                    <div class="col-sm-1">
                      <label for="Number" className="font-weight-bold">
                       IDNumber
                      </label>
                    </div>
                    <div class="col-sm-5">
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
                    <div class="col-sm-1">
                      <label for="Number" className="font-weight-bold">
                        Medical Facility
                      </label>
                    </div>
                    <div class="col-sm-5">
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
                  <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                        Type
                      </label>
                    </div>
                    <div class="col-sm-5">
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
                    <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                        Result
                      </label>
                    </div>
                    <div class="col-sm-5">
                      <Select
                        name="Result"
                        value={GenderCategories.filter(
                          option => option.label === this.state.Result
                        )}
                        onChange={this.handleSelectChange}
                        options={GenderCategories}
                        required
                      />
                    </div>
                  </div>
                  <br />
                  <div class="row">
                  <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                        Date OF medical
                      </label>
                    </div>
                    <div class="col-sm-5">
                      <input
                        type="date"
                        class="form-control"
                        name="DOM"
                        onChange={this.handleInputChange}
                        value={this.state.DOM}
                        required
                      />
                    </div>
                    <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                       Other Cost
                      </label>
                    </div>
                    <div class="col-sm-5">
                      <input
                        type="Number"
                        class="form-control"
                        name="Others"
                        onChange={this.handleInputChange}
                        value={this.state.Others}
                       
                      />
                    </div>
                  </div>
                  <br />
                  <div className="col-sm-12 ">
                              <div className=" row">
                                <div className="col-sm-2">
                                  <button
                                    className="btn btn-danger float-left"
                                    onClick={this.closeModal}
                                  >
                                    Cancel
                                  </button>
                                </div>
                                <div className="col-sm-8" />
                                <div className="col-sm-2">
                                  <button
                                    type="submit"
                                    className="btn btn-primary float-left"
                                  >
                                    Save
                                  </button>
                                </div>
                              </div>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>
                </Modal>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
      );

  }
}

export default Minor;
