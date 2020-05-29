import React, { Component } from "react";
import { Link } from "react-router-dom";
import Chart from "react-google-charts";
import swal from "sweetalert";

import { Calendar, momentLocalizer } from "react-big-calendar";
import moment from "moment";
import withDragAndDrop from "react-big-calendar/lib/addons/dragAndDrop";
import "./Styles/App.css";

let userdateils = localStorage.getItem("UserData");
let data = JSON.parse(userdateils);
const localizer = momentLocalizer(moment);
const DnDCalendar = withDragAndDrop(Calendar);
class DashBoard extends Component {
  constructor() {
    super();
    this.state = {
      Applications: [],
      Data: [],
      ChangePassword: data.ChangePassword,
      PendingApplication:[],
      TotalApplicants: [],
      SystemUsers:[],
      TotalCost:[],
      ResolvedApplications: [],
      MinorRedAlerts:[],
      DCIRedAlerts:[],
      PassportRedAlerts:[],
      minormedicalRedAlerts:[],
      TrainingRedAlerts:[],
      MajorRedAlerts:[],
      ContractRedAlerts:[],
      NEARedAlerts:[],
      VisaRedAlerts:[],
      AttestationRedAlerts:[],
      TicketingRedAlerts:[],
      TravelledApplicant:[],
      FinalRedAlerts:[],
      events: []
    };
  }
  onEventResize = (type, { event, start, end, allDay }) => {
    this.setState(state => {
      state.events[0].start = start;
      state.events[0].end = end;
      return { events: state.events };
    });
  };

  onEventDrop = ({ event, start, end, allDay }) => {
    console.log(start);
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
 
  fetchPendingApplication = () => {
    fetch(
      "/api/Dashboard/" + localStorage.getItem("UserName") + "/Notresolved",
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      }
    )
      .then(res => res.json())
      .then(PendingApplication => {
        if (PendingApplication.length > 0) {
          this.setState({ PendingApplication: PendingApplication });
        } else {
          //swal("", PendingApplication.message, "error");
        }
      })
      .catch(err => {
        // swal("", err.message, "error");
      });
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
  TotalCost = () => {
    fetch(
   "/api/TotalCost/" ,
   {
     method: "GET",
     headers: {
       "Content-Type": "application/json",
       "x-access-token": localStorage.getItem("token")
     }
   }
 )
   .then(res => res.json())
   .then(TotalCost=> {
     if (TotalCost.length > 0) {
       this.setState({ TotalCost: TotalCost});
     } else {
       //swal("", PendingApplication.message, "error");
     }
   })
   .catch(err => {
     // swal("", err.message, "error");
   });
};

SystemUsers = () => {
  fetch(
 "/api/TotalUsers/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(SystemUsers=> {
   if (SystemUsers.length > 0) {
     this.setState({ SystemUsers: SystemUsers});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
MinorRedAlerts = () => {
  fetch(
 "/api/MinorRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(MinorRedAlerts=> {
   if (MinorRedAlerts.length > 0) {
     this.setState({ MinorRedAlerts: MinorRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
DCIRedAlerts = () => {
  fetch(
 "/api/DCIRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(DCIRedAlerts=> {
   if (DCIRedAlerts.length > 0) {
     this.setState({ DCIRedAlerts: DCIRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
PassportRedAlerts = () => {
  fetch(
 "/api/PassportRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(PassportRedAlerts=> {
   if (PassportRedAlerts.length > 0) {
     this.setState({ PassportRedAlerts: PassportRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
TrainingRedAlerts = () => {
  fetch(
 "/api/TrainingRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(TrainingRedAlerts=> {
   if (TrainingRedAlerts.length > 0) {
     this.setState({ TrainingRedAlerts: TrainingRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
MajorRedAlerts = () => {
  fetch(
 "/api/MajorRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(MajorRedAlerts=> {
   if (MajorRedAlerts.length > 0) {
     this.setState({ MajorRedAlerts: MajorRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
ContractRedAlerts = () => {
  fetch(
 "/api/ContractRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(ContractRedAlerts=> {
   if (ContractRedAlerts.length > 0) {
     this.setState({ ContractRedAlerts: ContractRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
NEARedAlerts = () => {
  fetch(
 "/api/NEARedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(NEARedAlerts=> {
   if (NEARedAlerts.length > 0) {
     this.setState({ NEARedAlerts: NEARedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
VisaRedAlerts = () => {
  fetch(
 "/api/VisaRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(VisaRedAlerts=> {
   if (VisaRedAlerts.length > 0) {
     this.setState({ VisaRedAlerts: VisaRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
AttestationRedAlerts = () => {
  fetch(
 "/api/TicketingRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(AttestationRedAlerts=> {
   if (AttestationRedAlerts.length > 0) {
     this.setState({ AttestationRedAlerts: AttestationRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
TicketingRedAlerts = () => {
  fetch(
 "/api/TicketingRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(TicketingRedAlerts=> {
   if (TicketingRedAlerts.length > 0) {
     this.setState({ TicketingRedAlerts: TicketingRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
FinalRedAlerts = () => {
  fetch(
 "/api/FinalRedAlerts/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(FinalRedAlerts=> {
   if (FinalRedAlerts.length > 0) {
     this.setState({ FinalRedAlerts: FinalRedAlerts});
   } else {
     //swal("", PendingApplication.message, "error");
   }
 })
 .catch(err => {
   // swal("", err.message, "error");
 });
};
TravelledApplicant = () => {
  fetch(
 "/api/TravelledApplicant/" ,
 {
   method: "GET",
   headers: {
     "Content-Type": "application/json",
     "x-access-token": localStorage.getItem("token")
   }
 }
)
 .then(res => res.json())
 .then(TravelledApplicant=> {
   if (TravelledApplicant.length > 0) {
     this.setState({ TravelledApplicant: TravelledApplicant});
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
              this.TotalApplicants();
              this.SystemUsers();
              this.TotalCost();
              this.fetchApplications();
              this.MinorRedAlerts();
              this.DCIRedAlerts();
              this.PassportRedAlerts();
              this.fetchData();
              this.TrainingRedAlerts();
              this.MajorRedAlerts();
              this.ContractRedAlerts();
              this.NEARedAlerts();
              this.VisaRedAlerts();
              this.AttestationRedAlerts();
              this.TicketingRedAlerts();
              this.FinalRedAlerts();
              this.TravelledApplicant();
              this.fetchPendingApplication();
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
    const divStyle = {
      margin: "19px"
    };
    let FormStyle = {
      margin: "20px"
      
    };
    let head = {
      font: "12px",
      color:"#FF0000"
      
    };
    let judy={
      font:"12px",
      color:"#0D3140",
    }
    const data = [["Month", "Registration"]];
    [...this.state.Data].map((k, i) => {
      let d = [k.Month, k.Count];
      data.push(d);
    });
    let bodymargin={
      margin:"20px"
          }

    return (
      <div class="app-content content">
      <div class="content-overlay"></div>
      <div class="header-navbar-shadow"></div>
      <div class="content-wrapper">
          <div class="content-header row">
              <div class="content-header-left col-md-9 col-12 mb-2">
                  <div class="row breadcrumbs-top">
                      <div class="col-12">
                          <h2 class="content-header-title float-left mb-0">Dashboard</h2>
                      </div>
                  </div>
              </div>
          </div>
          <div class="content-body">
          <section id="dashboard-ecommerce">
                <div class="row">
                    <div class="col-lg-3 col-sm-6 col-12">
                    {this.state.SystemUsers.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                        <i class="feather icon-users text-primary font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.SystemUsers}</h3>
                        <p>System users</p>
                        <Link to="/Users" className="text-info">
                                  More info <i className="fa fa-arrow-circle-right" />
                                </Link>
                            </div>        
                        </div>
                          )}
                    </div>
                    <div class="col-lg-3 col-sm-6 col-12">
                    {this.state.TotalApplicants.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather icon-credit-card text-success font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.totalApplicants}</h3>
                        <p>Applicants</p>
                        <Link to="/Registration" className="text-info">
                                  More info <i className="fa fa-arrow-circle-right" />
                                </Link>
                            </div>        
                        </div>
                          )}
                    </div>
                    <div class="col-lg-3 col-sm-6 col-12">
                    {this.state.TotalCost.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather icon-package text-warning font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.TotalCost}</h3>
                        <p>Cost</p>
                        <Link to="/Registration" className="text-info">
                                  More info <i className="fa fa-arrow-circle-right" />
                                </Link>
                            </div>        
                        </div>
                          )}
                    </div>
                    <div class="col-lg-3 col-sm-6 col-12">
                    {this.state.TravelledApplicant.map((r, i) =>
                        <div class="card">
                            <div class="card-header d-flex flex-column align-items-start pb-0">
                                <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather icon-shopping-cart text-danger font-medium-5"></i>
                                    </div>
                                </div>
                                <h3>{r.travelled}</h3>
                        <p>Travel</p>
                        <Link to="/Registration" className="text-info">
                                  More info <i className="fa fa-arrow-circle-right" />
                                </Link>
                            </div>        
                        </div>
                          )}
                    </div>
                </div>
                <div class="row">
                        <div class="col-lg-9 col-md-6 col-12">
                            <div class="card">
                                <div class="card-content">
                                        {this.state.Data.length > 0 ? (
                                        <div className="App">
                                          <Chart
                                            chartType="Bar"
                                            width={'100%'}
                                            height={'300px'}
                                            data={data}
                                            loader={<div>Loading Chart</div>}
                                            options={{
                                            colors: [ '#bbeeff'],
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
                        <div class="col-lg-3 col-md-6 col-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-end">
                                    <h4 class="mb-0" style={head}>Pending Notification</h4>
                                    <div class="avatar bg-rgba-primary p-50 m-0">
                                    <div class="avatar-content">
                                    <i class="feather  icon-help-circle text-danger font-medium-5"></i>
                                    </div>
                                </div>
                                </div>
                                <br/>
                                <div class="card-content">
            {this.state.PendingApplication.map((r, i) =>
              i % 2 == 0 ? (
                <div className="row">
                  <div className="col-lg-12 ">
                    <div className="small-box bg-green">
                      <div className="inner">
                        <h5 style={judy}>{r.Total}</h5>
                        <h6 style={head}>{r.Description}</h6>
                      </div>
                      <div className="icon">
                        <i className="ion ion-stats-bars" />
                      </div>
                      {r.Category === "Applications Approval" ? (
                        <a href="/#" className="small-box-footer ">
                          <Link
                            to="/ApplicationsApprovals"
                            className="text-info"
                          >
                            More info <i className="fa fa-arrow-circle-right" />
                          </Link>
                        </a>
                      ) : null}
                                           {r.Category === "Minor Medical Approval" ? (
                        <a href="/#" className="small-box-footer ">
                          <Link
                            to="/ApplicationsApprovals"
                            className="text-info"
                          >
                            More info <i className="fa fa-arrow-circle-right" />
                          </Link>
                        </a>
                      ) : null}
                       {r.Category === "DCI Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/DCIApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Passport Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/PassportApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                            {r.Category === "Major Medical Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/MajorApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Contract Processing Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/ContractApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Training Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TrainingApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Attestation Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/AttestationApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Final Medical Approval " ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/FinalApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Ticketing Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TicketingApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Travelling Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TravelApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                        {r.Category === "Visa Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/VisaApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                           {r.Category === "NEA Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/NEAApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                    </div>
                  </div>
                </div>
              ) : (
                  <div className="row">
                    <div className="col-lg-12 ">
                      <div className="small-box bg-aqua">
                        <div className="inner">
                        <h5 style={judy}>{r.Total}</h5>
                        <h6 style={head}>{r.Description}</h6>
                        </div>
                        <div className="icon">
                          <i className="ion ion-stats-bars" />
                        </div>
                        {r.Category === "Applications Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link
                              to="/ApplicationsApprovals"
                              className="text-info"
                            >
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                        {r.Category === "Minor Medical Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/MinormedicalApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "DCI Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/DCIApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Passport Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/PassportApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                            {r.Category === "Major Medical Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/MajorApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Contract Processing Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/ContractApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                         {r.Category === "Training Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TrainingApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                        {r.Category === "NEA Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/NEAApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                                                {r.Category === "Attestation Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/AttestationApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Final Medical Approval " ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/FinalApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Ticketing Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TicketingApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                          {r.Category === "Travelling Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/TravelApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                        {r.Category === "Visa Approval" ? (
                          <a href="/#" className="small-box-footer ">
                            <Link to="/VisaApproval" className="text-info">
                              More info <i className="fa fa-arrow-circle-right" />
                            </Link>
                          </a>
                        ) : null}
                      </div>
                    </div>
                  </div>
                )
            )}
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
      
      export default DashBoard;