import React, { Component } from "react";
import swal from "sweetalert";
import Chart from "react-google-charts";

class MonthlyRegistration extends Component {
  constructor() {
    super();
    this.state = {
      Applications: [],
      // AsAt: "",
      TotalApplicants:[],
      Minor:[],
      DCI:[],
      Data: [],
      Data1:[],
      Data2:[],
      Data3:[],
      Data4:[]
    };
  }
  handleInputChange = event => {
    // event.preventDefault();
    // this.setState({ [event.target.name]: event.target.value });
    const target = event.target;
    const value = target.type === "checkbox" ? target.checked : target.value;
    const name = target.name;
    this.setState({ [name]: value, Data: [] });
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

  fetchData = () => {
    this.setState({ FilePath: "" });
      fetch("/api/ExecutiveReports/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(res => res.json())
        .then(Applications => {
          if (Applications.length > 0) {
            this.setState({ Data: Applications });
          } else {
            swal("", Applications.message, "error");
          }
        })
        .catch(err => {
          swal("", err.message, "error");
        });
    // } else {
    //   swal("", "Select Date to Continue", "error");
    // }
  };
  fetchTravelling = () => {
    fetch("/api/Travelling", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(Travelling => {
        if (Travelling.length > 0) {
          this.setState({ Travelling: Travelling });
        } else {
          swal("Oops!", Travelling.message, "error");
        }
      })
      .catch(err => {
        swal("Oops!", err.message, "error");
      });
  };

  fetchTravelldReport = () => {
    this.setState({ FilePath: "" });
      fetch("/api/TravelledReport/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(res => res.json())
        .then(Travelling => {
          if (Travelling.length > 0) {
            this.setState({ Data1: Travelling });
          } else {
            swal("", Travelling.message, "error");
          }
        })
        .catch(err => {
          swal("", err.message, "error");
        });
    // } else {
    //   swal("", "Select Date to Continue", "error");
    // }
  };
  fetchMinorMedicalReport = () => {
    this.setState({ FilePath: "" });
      fetch("/api/MinorMedicalReport/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(res => res.json())
        .then(Minor => {
          if (Minor.length > 0) {
            this.setState({ Data2: Minor });
          } else {
            swal("", Minor.message, "error");
          }
        })
        .catch(err => {
          swal("", err.message, "error");
        });
    // } else {
    //   swal("", "Select Date to Continue", "error");
    // }
  };
  FetchDCIReport = () => {
    this.setState({ FilePath: "" });
      fetch("/api/DCIReport/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(res => res.json())
        .then(DCI => {
          if (DCI.length > 0) {
            this.setState({ Data3: DCI });
          } else {
            swal("", DCI.message, "error");
          }
        })
        .catch(err => {
          swal("", err.message, "error");
        });
    // } else {
    //   swal("", "Select Date to Continue", "error");
    // }
  };
  FetchPassportReport = () => {
    this.setState({ FilePath: "" });
      fetch("/api/PassportReport/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      })
        .then(res => res.json())
        .then(PassportReport => {
          if (PassportReport.length > 0) {
            this.setState({ Data4: PassportReport });
          } else {
            swal("", PassportReport.message, "error");
          }
        })
        .catch(err => {
          swal("", err.message, "error");
        });
    // } else {
    //   swal("", "Select Date to Continue", "error");
    // }
  };
  TotalApplicants = () => {
    fetch(
   "/api/TotalApplicant/" ,
   {
     method: "GET",
     headers: {
       "Content-Type": "application/json",
       "x-access-token": localStorage.getItem("token")
     }
   }
 )
   .then(res => res.json())
   .then(TotalApplicants=> {
     if (TotalApplicants.length > 0) {
       this.setState({ TotalApplicants: TotalApplicants});
     } else {
       //swal("", PendingApplication.message, "error");
     }
   })
   .catch(err => {
     // swal("", err.message, "error");
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
              this.fetchData();
              this.TotalApplicants();
              this.fetchApplications();
              this.fetchTravelling();
              this.fetchTravelldReport();
              this.fetchMinorMedicalReport();
              this.FetchDCIReport();
              this.FetchPassportReport();
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
    let filepath = process.env.REACT_APP_BASE_URL + "/Cases/" + this.state.File;
    window.open(filepath);
  };
  formatNumber = num => {
    let newtot = Number(num).toFixed(2);
    return newtot.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
  };
  render() {
    let FormStyle = {
      margin: "20px"
    };
    const data = [["Month", "Registration"]];
    [...this.state.Data].map((k, i) => {
      let d = [k.Month, k.Count];
      data.push(d);
    });
    const data1 = [["Month", "Travelling"]];
    [...this.state.Data1].map((k, i) => {
      let d = [k.Month, k.Count];
      data1.push(d);
    });
    const data2 = [["Month", "Minor medical"]];
    [...this.state.Data2].map((k, i) => {
      let d = [k.Month, k.Count];
      data2.push(d);
    });
    const data3 = [["Month", "DCI Cost"]];
    [...this.state.Data3].map((k, i) => {
      let d = [k.Month, k.Count];
      data3.push(d);
    });
    const data4 = [["Month", "passport"]];
    [...this.state.Data4].map((k, i) => {
      let d = [k.Month, k.Count];
      data4.push(d);
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
                            <h2 class="content-header-title float-left mb-0">Analytics</h2>
                        </div>
                    </div>
                </div>
            </div>
          <div class="content-body">
              <section id="dashboard-analytics">
              <div class="row">
              <div class="col-lg-2 col-md-12 col-sm-12">
                            <div class="card bg-analytics text-white">
                                <div class="card-content">
                                <div class="ibox ">
                        <div class="ibox-content">
                        {this.state.TotalApplicants.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather icon-users text-success font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.totalApplicants} Total Applicant</h3>
                            </div>        
                        </div>
                          )}
                           {this.state.TotalApplicants.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather icon-institution text-success font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.totalApplicants} Total Applicant</h3>
                            </div>        
                        </div>
                          )}
                        </div>
                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5 col-md-12 col-sm-12">
                            <div class="card bg-analytics text-white">
                                <div class="card-content">
                                <div class="ibox ">
                        <div class="ibox-content">
                            <div>
                            {this.state.Data.length > 0 ? (
                  <div className="App">
                    <Chart
                      chartType="Bar"
                      width={'100%'}
                      height={'300px'}
                      data={data}
                      loader={<div>Loading Chart</div>}
                      options={{
                        colors: [ '#80ABA3'],
                        // Material design options
                        chart: {
                         title: "Monthly Registration"
                        }
                      }}
                    />
                  </div>
                ) : null}
                            </div>
                        </div>
                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5 col-md-6 col-12">
                            <div class="card">
                            {/* <div class="ibox-title">
                            <h5>Montly Minor medical Cost</h5>
                        </div> */}
                        <div class="ibox-content">
                            <div class="text-center">
                            {this.state.Data.length > 0 ? (
                  <div className="App">
                    <Chart
                      chartType="Bar"
                      width={'100%'}
                      height={'300px'}
                      data={data2}
                      loader={<div>Loading Chart</div>}
                      options={{
                        colors: [ '#CD6155'],
                        sliceVisibilityThreshold: 0.2,
                        // Material design options
                        chart: {
                          title: "Montly Minor medical Cost"
                        }
                      }}
                    />
                  </div>
                ) : null}
                            </div>
                        </div>
                   
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="card bg-analytics text-white">
                                <div class="card-content">
                                <div class="ibox ">
                        <div class="ibox-content">
                            <div>
                            {this.state.Data.length > 0 ? (
                  <div className="App">
                    <Chart
                      chartType="Bar"
                      width={'100%'}
                      height={'300px'}
                      data={data}
                      loader={<div>Loading Chart</div>}
                      options={{
                        colors: [ '#80ABA3'],
                        // Material design options
                        chart: {
                         title: "Monthly Registration"
                        }
                      }}
                    />
                  </div>
                ) : null}
                            </div>
                        </div>
                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-12">
                            <div class="card">
                            {/* <div class="ibox-title">
                            <h5>Montly Minor medical Cost</h5>
                        </div> */}
                        <div class="ibox-content">
                            <div class="text-center">
                            {this.state.Data.length > 0 ? (
                  <div className="App">
                    <Chart
                      chartType="Bar"
                      width={'100%'}
                      height={'300px'}
                      data={data2}
                      loader={<div>Loading Chart</div>}
                      options={{
                        colors: [ '#CD6155'],
                        sliceVisibilityThreshold: 0.2,
                        // Material design options
                        chart: {
                          title: "Montly Minor medical Cost"
                        }
                      }}
                    />
                  </div>
                ) : null}
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

export default MonthlyRegistration;
