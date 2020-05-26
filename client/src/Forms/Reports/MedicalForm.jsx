import React, { Component } from "react";
import swal from "sweetalert";
import Select from "react-select";
var dateFormat = require("dateformat");
class MedicalForm extends Component {
  constructor() {
    super();
    this.state = {
      Applications: [],
      Registration: [],
      IDNumber:"",
     Fullname:"",
     Gender:"",
     phone:"",
     DOB:"",
     Email:"",
     Country:"",
     County:"",
     Village:"",
     Religion:"",
     Marital:"",
     Height:"",
     Weight:"",
     photo:"",
     FullPhoto:"",
     BirthCer:"",
     Husband:"",
     HusbandMobile:"",
     HusbandID:"",
     Languages:"",
     Skills:"",
     Classify:"",
     Job:"",
      File: "",
      FilePath: "",
    };
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.Downloadfile = this.Downloadfile.bind(this);
  }
  fetchApplicantDetails = IDNumber => {
    fetch("/api/Registration/" + IDNumber, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(ApplicantDetails => {
        if (ApplicantDetails.length > 0) {
          this.setState({ Fullname: ApplicantDetails[0].Fullname });
          this.setState({ phone: ApplicantDetails[0].phone });
          this.setState({ Email: ApplicantDetails[0].Email });
          this.setState({ DOB: ApplicantDetails[0].DOB });
          this.setState({ Gender: ApplicantDetails[0].Gender });
        } else {
          swal("", ApplicantDetails.message, "error");
        }
      })
      .catch(err => {
        swal("", err.message, "error");
      });
  };
  handleSelectChange = (UserGroup, actionMeta) => {
    this.setState({ [actionMeta.name]: UserGroup.value });
    var rows = [...this.state.Registration];
    const filtereddata = rows.filter(
      item => item.IDNumber === UserGroup.value
    );

    let data = {
      Fullname: filtereddata[0].Fullname,
      Gender: filtereddata[0].Gender,
      Email: filtereddata[0].Email,
      DOB: filtereddata[0].DOB,
      phone: filtereddata[0].phone,
      County: filtereddata[0].County,
    //   Created_at
    };
    this.setState(data);
    this.fetchApplicantDetails(filtereddata[0].Applicantusername);

  };
  fetchApplications = () => {
    fetch("/api/Applications", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Applications => {
        if (Applications.length > 0) {
          this.setState({ Applications: Applications });
        } else {
          swal("", Applications.message, "error");
        }
      })
      .catch(err => {
        swal("", err.message, "error");
      });
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
              this.fetchApplicantDetails();
              this.fetchRegistration();
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
  PrintFile = () => {
    let filepath = process.env.REACT_APP_BASE_URL + "/MedicalForms/" + this.state.File;
    window.open(filepath);
  };
  formatNumber = num => {
    let newtot = Number(num).toFixed(2);
    return newtot.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
  };
  Downloadfile = () => {
    this.setState({ FilePath: "" });
    if (this.state.IDNumber) {
      const data = {
        Fullname: this.state.Fullname,
        phone: this.state.phone,
        Email: this.state.Email,
        Gender: this.state.Gender,
        DOB: this.state.DOB,
        FullPhoto: this.state.FullPhoto,
        photo: this.state.photo,
        IDNumber:this.state.IDNumber,
        LogoPath: process.env.REACT_APP_BASE_URL + "/images/Harambee.png"
      };

      fetch("/api/MedicalForm", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        },
        body: JSON.stringify(data)
      })
        .then(response =>
          response.json().then(data => {
            if (data.success) {
              let filename = this.state.IDNumber + ".pdf";
              this.setState({
                File: filename,
                FilePath: process.env.REACT_APP_BASE_URL + "/MedicalForms/" + filename
              });
            } else {
                console.log(data)
              swal("", "Error occured while printing the report", "error");
            
            }
          })
        )
        .catch(err => {
          //swal("Oops!", err.message, "error");
        });
    } else {
      swal("", "Select Application No to Continue", "error");
    }
  };
  render() {
    let FormStyle = {
      margin: "20px"
    };
    const ApplicationNoOptions = [...this.state.Registration].map((k, i) => {
      return {
        value: k.IDNumber,
        label: k.IDNumber
      };
    });
    return (
        <div class="app-content content">
        <div class="content-overlay"></div>
        <div class="header-navbar-shadow"></div>
        <div class="content-wrapper">
            <div class="content-header row">
                <div class="content-header-left col-md-9 col-12 mb-2">
                    <div class="row breadcrumbs-top">
                        <div class="col-12">
                            <h2 class="content-header-title float-left mb-0" style={{ color: "#1c84c6" }}>Medical Declaration Form</h2>   
                        </div>
                    </div>
                </div>
            </div>
            <div class="content-body">
                <section id="description" class="card">
                    <div class="card-content">
                        <div class="card-body">
                            <div class="card-text">
                            <div className="row">
            <div className="col-lg-1"></div>
            <div className="col-lg-10 border border-success rounded bg-white">
            <div style={FormStyle}>
                <div class="row">
                  <div class="col-sm-2">
                    <label for="ApplicantID" className="font-weight-bold ">
                      Select IDNumber{" "}
                    </label>
                  </div>
                  <div class="col-sm-4">
                    <div className="form-group">
                      <Select
                        name="IDNumber"
                        onChange={this.handleSelectChange}
                        options={ApplicationNoOptions}
                        required
                      />
                    </div>
                  </div>
                  <div class="col-sm-1">
                    <button
                      onClick={this.Downloadfile}
                      className="btn btn-primary"
                      type="button"
                    >
                      Preview
                    </button>
                  </div>
                  &nbsp; &nbsp; &nbsp;
                  <div class="col-sm-1">
                    <button
                      onClick={this.PrintFile}
                      className="btn btn-success"
                      type="button"
                    >
                      Print
                    </button>
                  </div>
                </div>
                <hr />
                <br />

                <object
                  width="100%"
                  height="450"
                  data={this.state.FilePath}
                  type="application/pdf"
                >
                  {" "}
                </object>
              </div>
            </div>
          </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
    );
  }
}

export default MedicalForm;
