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
class Passport extends Component {
  constructor() {
    super();
    this.state = {
            Passport: [],
            Registration:[],
            privilages: [],
            profile: true,
            Number:"",
            POD:"" ,
            Tracking_Number:"" ,
            Status:"",
            Passport_Collection_Date:"",
           PassPortNumber:"" ,
           Cost:"",
           Location:"",
          CostIncurred:"",
          PassportOption:"",
          ID: "",
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
        Number:"",
        POD:"" ,
        Tracking_Number:"" ,
        Status:"",
        Passport_Collection_Date:"",
        PassPortNumber:"" ,
        PassportOption:"",
        Cost:"",
        Location:"",
        CostIncurred:"",
        ID: "",
    };
    this.setState(data);
  }
  fetchPassport = () => {
    this.setState({ Passport: [] });
    fetch("/api/Passport", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
        }
    })
        .then(res => res.json())
        .then(Passport => {
            if (Passport.length > 0) {
                this.setState({ Passport: Passport });
            } else {
                swal("", Passport.message, "error");
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
              this.fetchPassport();
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
        POD: this.state.POD,
        Tracking_Number: this.state.Tracking_Number,
        Status:this.state.Status,
        Passport_Collection_Date: this.state.Passport_Collection_Date,
        PassPortNumber:this.state.PassPortNumber,
        PassportOption:this.state.PassportOption,
        Cost:this.state.Cost,   
        CostIncurred:this.state.CostIncurred,
        Location:this.state.Location,
    };

    if (this.state.isUpdate) {
      this.UpdateData("/api/Passport/" + this.state.ID, data);
    } else {
      this.postData("/api/Passport", data);
    }
  };
  handleEdit = Name => {
    const data = {
        Number: Name.Number,
        POD: dateFormat(
            new Date(Name.POD).toLocaleDateString(),
            "isoDate"
          ),
        Tracking_Number: Name.Tracking_Number,
        Status: Name.Status,
        Passport_Collection_Date: dateFormat(
            new Date(Name.Passport_Collection_Date).toLocaleDateString(),
            "isoDate"
          ),
        PassPortNumber:Name.PassPortNumber,
        PassportOption:Name.PassportOption,
        Cost:Name.Cost,
        CostIncurred:Name.CostIncurred,
        Location:Name.Location,
        ID:Name.ID
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
      { title: "POD", dataKey: "POD" },
      { title: "PassPortNumber", dataKey: "PassPortNumber" },
      { title: "Status", dataKey: "Status" },
      { title: "Option", dataKey: "PassportOption" },
      { title: "Tracking_Number", dataKey: "Tracking_Number" },
      { title: "Location", dataKey: "Location" },
    
    ];

    const rows = [...this.state.Passport];

    var doc = new jsPDF("p", "pt", "a2", "portrait");

    doc.autoTable(columns, rows, {
      margin: { top: 60 },
      beforePageContent: function(data) {
        doc.text("Rms Passport processing and booking", 40, 50);
      }
    });
    doc.save("RMS passport processsing and booking.pdf");
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
        return fetch("/api/Passport/" + k, {
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
              this.fetchPassport();
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
          this.fetchPassport();
          if (data.success) {
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
          this.fetchPassport();
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
    let Transcriptstatus = [
      {
        value: "issued",
        label: "issued"
      },
      {
        value: "pending",
        label: "pending"
      },
    ];
    let PassportOption = [
      {
        value: "New",
        label: "New"
      },
      {
        value: "Lost",
        label: "Lost"
      },
    ];
    let CertificateProcessing = [
        {
          value: "Collected",
          label: "Collected"
        },
        {
          value: "Processing",
          label: "Processing"
        },
  
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
            label: "Photo Capture Date",
            field: "POD",
            sort: "asc"
          },
          {
            label: "Type",
            field: "PassportOption",
            sort: "asc"
          },
          {
            label: "Status",
            field: "Status",
            sort: "asc"
          },
        {
          label: "Passport Collection Date",
          field: "Passport_Collection_Date",
          sort: "asc"
        },
        {
          label: "Passport Number",
          field: "PassPortNumber",
          sort: "asc"
        },
        {
            label: "Tracking Number",
            field: "Tracking_Number",
            sort: "asc"
          },
          {
            label: "Location",
            field: "Location",
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
    const rows = [...this.state.Passport];
    if (rows.length > 0) {
      rows.map((k, i) => {
        let Rowdata = {
            Fullname: k.Fullname,
            IDNumber: k.IDNumber,
            Passport: k.Passport,
            POD: new Date(k.POD).toLocaleDateString(),
            Tracking_Number:k.Tracking_Number,
            Passport_Collection_Date: new Date(k.Passport_Collection_Date).toLocaleDateString(),
            Status:k.Status,
            Location:k.Location,
            PassportOption:k.PassportOption,
            PassPortNumber:k.PassPortNumber,
            CostIncurred:k.CostIncurred,
            Cost:k.Cost,
            ID:k.ID,
          action: (
            <span>
              {this.validaterole("Passport processing", "Edit") ? (
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
              {this.validaterole("Passport processing", "Remove") ? (
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
                            <h2 class="content-header-title float-left mb-0">Passport processing</h2>
                            <div class="breadcrumb-wrapper col-12">
                                <ol class="breadcrumb">
                                  
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="content-header-right text-md-right col-md-3 col-12 d-md-block d-none">
                    <div class="form-group breadcrum-right">
                  {this.validaterole("Passport processing", "AddNew") ? (
                <button
                  type="button"
                  onClick={this.openModal}
                  className="btn btn-success  fa fa-plus"
                >
                 New
                </button>
              ) : null}
              &nbsp;&nbsp;&nbsp;
              {this.validaterole("Passport processing", "Export") ? (
                <button
                  type="button"
                  onClick={this.exportpdf}
                  className="btn btn-success fa fa-file-pdf-o"
                >
                  &nbsp;Export
                </button>
              ) : null}
           &nbsp;&nbsp;&nbsp;
              {this.validaterole("Passport processing", "Export") ? (
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
                  <ExcelSheet data={rows} name="Passport processing">
                        <ExcelColumn label="Fullname" value="Fullname" />
                        <ExcelColumn label="IDNumber" value="IDNumber" />
                        <ExcelColumn label="DOT" value="DOT" />
                        <ExcelColumn label="Cost" value="Cost" />
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
                      <label for="PEType" className="font-weight-bold">
                        Photo capture date
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <input
                        type="date"
                        class="form-control"
                        name="POD"
                        onChange={this.handleInputChange}
                        value={this.state.POD}
                        required
                      />
                    </div>
                  </div>
                  <br />

                  <div class="row">
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                 Passport Status
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <Select
                        name="Status"
                        value={CertificateProcessing.filter(
                          option => option.label === this.state.Status
                        )}
                        onChange={this.handleSelectChange}
                        options={CertificateProcessing}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Passport Collection Date
                      </label>
                    </div>
                    <div class="col-sm-4">
                      <input
                        type="date"
                        class="form-control"
                        name="Passport_Collection_Date"
                        onChange={this.handleInputChange}
                        value={this.state.Passport_Collection_Date}
                        required
                      />
                    </div>
                  </div>
                  <br/>
                  <div class="row">
                  <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        passport Number
                      </label>
                    </div>
                    <div class="col-sm-3">
                      <input
                        type="text"
                        class="form-control"
                        name="PassPortNumber"
                        onChange={this.handleInputChange}
                        value={this.state.PassPortNumber}
                        required
                      />
                    </div>
                  <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                        Tracking Number
                      </label>
                    </div>
                    <div class="col-sm-2">
                      <input
                        type="text"
                        class="form-control"
                        name="Tracking_Number"
                        onChange={this.handleInputChange}
                        value={this.state.Tracking_Number}
                        required
                      />
                    </div>
                   
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Location
                      </label>
                    </div>
                    <div class="col-sm-2">
                      <input
                        type="text"
                        class="form-control"
                        name="Location"
                        onChange={this.handleInputChange}
                        value={this.state.Location}
                        required
                      />
                    </div>
                  </div>
                  <br/>
                  <div class="row">
                  <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        passport Option
                      </label>
                    </div>
                    <div class="col-sm-3">
                    <Select
                        name="PassportOption"
                        value={PassportOption.filter(
                          option => option.label === this.state.PassportOption
                        )}
                        onChange={this.handleSelectChange}
                        options={PassportOption}
                        required
                      />
                    </div>
                    <div class="col-sm-1">
                      <label for="PEType" className="font-weight-bold">
                        Cost
                      </label>
                    </div>
                    <div class="col-sm-2">
                      <input
                        type="text"
                        class="form-control"
                        name="Cost"
                        onChange={this.handleInputChange}
                        value={this.state.Cost}
                        required
                      />
                    </div>
                    <div class="col-sm-2">
                      <label for="PEType" className="font-weight-bold">
                        Cost incurred
                      </label>
                    </div>
                    <div class="col-sm-2">
                      <input
                        type="text"
                        class="form-control"
                        name="CostIncurred"
                        onChange={this.handleInputChange}
                        value={this.state.CostIncurred}
                        required
                      />
                    </div>
                  </div>
                  <br/>
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

export default Passport;
