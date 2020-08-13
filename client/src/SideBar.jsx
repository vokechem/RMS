import React, { Component } from "react";

import { Link } from "react-router-dom";
class SideBar extends Component {
  constructor() {
    super();
    this.state = {
      loading: true,
      redirect: true,
      privilages: [],
      showMenuRecruitment: false,
      showMenuAnalytics: false,
      showMenuAdmin: true,
      showMenuEmployement:false,
      showHRPool:false,
      showAdminstration:false,
      showTravel:false,
      showMedical:false,
      showMenuParameteres: false,
      showMenuFeesSettings: false,
      showMenuReports: false,
      showTraining:false,
      CompanyDetails: [],
      Logo: ""
    };
    this.ProtectRoute = this.ProtectRoute.bind(this);
    this.checkPrivilage = this.checkPrivilage.bind(this);
    this.showMenu = this.showMenu.bind(this);
  }
  showMenu = (Module, event) => {
    event.preventDefault();
    if (Module === "System Administration") {
      this.setState({ showMenuAdmin: !this.state.showMenuAdmin });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
           if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
           if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    } else if (Module === "Fees Settings") {
      this.setState({ showMenuFeesSettings: !this.state.showMenuFeesSettings });
    } else if (Module === "Recruitment") {
      this.setState({
        showMenuRecruitment: !this.state.showMenuRecruitment
      });
     
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
        if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
      
    }  else if (Module === "Reports") {
      this.setState({
        showMenuReports: !this.state.showMenuReports
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({ showMenuAdmin: !this.state.showMenuAdmin });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
      
    } else if (Module === "System parameteres") {
      this.setState({
        showMenuParameteres: !this.state.showMenuParameteres
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    }  else if (Module === "Analytics") {
      this.setState({
        showMenuAnalytics: !this.state.showMenuAnalytics
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    } else if (Module === "Employement") {
      this.setState({
        showMenuEmployement: !this.state.showMenuEmployement
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    }  else if (Module === "Hr Pool") {
      this.setState({
        showHRPool: !this.state.showHRPool
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    }  else if (Module === "Adminstration") {
      this.setState({
        showAdminstration: !this.state.showAdminstration
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    } else if (Module === "Medical") {
      this.setState({
        showMedical: !this.state.showMedical
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    } else if (Module === "Travel") {
      this.setState({
        showTravel: !this.state.showTravel
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showTraining) {
        this.setState({
          showTraining: !this.state.showTraining
        });
      }
    } else if (Module === "Training") {
      this.setState({
        showTraining: !this.state.showTraining
      });
      if (this.state.showMenuRecruitment) {
        this.setState({
          showMenuRecruitment: !this.state.showMenuRecruitment
        });
      }
      if (this.state.showMenuAdmin) {
        this.setState({
          showMenuAdmin: !this.state.showMenuAdmin
        });
      }
      if (this.state.showMenuReports) {
        this.setState({
          showMenuReports: !this.state.showMenuReports
        });
      }
      if (this.state.showMenuParameteres) {
        this.setState({
          showMenuParameteres: !this.state.showMenuParameteres
        });
      }
      if (this.state.showMenuAnalytics) {
        this.setState({
          showMenuAnalytics: !this.state.showMenuAnalytics
        });
      }
      if (this.state.showMenuEmployement) {
        this.setState({
          showMenuEmployement: !this.state.showMenuEmployement
        });
      }
      if (this.state.showAdminstration) {
        this.setState({
          showAdminstration: !this.state.showAdminstration
        });
      }
      if (this.state.showMedical) {
        this.setState({
          showMedical: !this.state.showMedical
        });
      }
      if (this.state.showHRPool) {
        this.setState({
          showHRPool: !this.state.showHRPool
        });
      }
      if (this.state.showTravel) {
        this.setState({
          showTravel: !this.state.showTravel
        });
      }
    } 
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
        if (data.length > 0) {
          this.setState({ privilages: data });
        } else {
          localStorage.clear();
          return (window.location = "/#/Logout");
        }
      })
      .catch(err => {
        this.setState({ loading: false, redirect: true });
      });
    //end
  }

  checkPrivilage(key, value) {
    let array = [...this.state.privilages];
    for (var i = 0; i < array.length; i++) {
      if (array[i][key] === value) {
        return array[i];
      }
    }
    return null;
  }
  fetchCompanyDetails = () => {
    fetch("/api/configurations/" + 1, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": localStorage.getItem("token")
      }
    })
      .then(res => res.json())
      .then(data => {
        if (data.length > 0) {
          this.setState({ CompanyDetails: data });
          this.setState({ Logo: data[0].Logo });
        } else {
          // swal("Oops!", data.message, "error");
        }
      })
      .catch(err => {
        // swal("Oops!", err.message, "error");
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
              this.ProtectRoute();
              this.fetchCompanyDetails();
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
  ViewFile = (k, e) => {
    let filepath =
      process.env.REACT_APP_BASE_URL + "/profilepics/ARCMS-UserGuide.pdf";
    window.open(filepath);
    //this.setState({ openFileViewer: true });
  };
  render() {
    let photostyle = {
      height: 70,
      width: 205,
      background: "#a7b1c2",
      margin: 10,
      "border-radius": 2
    };
 
    let menucolor= {
      color:"#E7E7E7",
    }
    let MenuStyle = {
      color: "#E7E7E7",
      cursor: "pointer",
      padding: "14px 20px 14px 25px",
      display: "block",
      "font-weight": 600,
      "font-size": 14
      // "font-family": `"Helvetica Neue", Helvetica, Arial, sans - serif`
    };
    let bgpage={
      background :"#f7ffe6"
    }
    return (
      <div id="wrapper">
      <header id="topnav">
          <div class="navbar-custom">
              <div class="container-fluid">
                  <ul class="list-unstyled topnav-menu float-right mb-0">

                      <li class="dropdown notification-list">
                        
                          <a class="navbar-toggle nav-link">
                              <div class="lines">
                                  <span></span>
                                  <span></span>
                                  <span></span>
                              </div>
                          </a>
                         
                      </li>

                      <li class="d-none d-sm-block">
                          <form class="app-search">
                              <div class="app-search-box">
                                  <div class="input-group">
                                      <input type="text" class="form-control" placeholder="Search..."/>
                                      <div class="input-group-append">
                                          <button class="btn" type="submit">
                                              <i class="fe-search"></i>
                                          </button>
                                      </div>
                                  </div>
                              </div>
                          </form>
                      </li>
          
                      <li class="dropdown notification-list">
                          <a class="nav-link dropdown-toggle  waves-effect waves-light" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                              <i class="fe-bell noti-icon"></i>
                              <span class="badge badge-danger rounded-circle noti-icon-badge">9</span>
                          </a>
                          <div class="dropdown-menu dropdown-menu-right dropdown-lg">

                              <div class="dropdown-item noti-title">
                                  <h5 class="m-0">
                                      <span class="float-right">
                                          <a href="#" class="text-dark">
                                              <small>Clear All</small>
                                          </a>
                                      </span>Notification
                                  </h5>
                              </div>

                              <div class="slimscroll noti-scroll">

                               
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon bg-primary">
                                          <i class="mdi mdi-settings-outline"></i>
                                      </div>
                                      <p class="notify-details">New settings
                                          <small class="text-muted">There are new settings available</small>
                                      </p>
                                  </a>

                                 
                                  <a href="javascript:void(0);" class="dropdown-item notify-item active">
                                      <div class="notify-icon">
                                          <img src="assets/images/users/avatar-1.jpg" class="img-fluid rounded-circle" alt="" /> </div>
                                      <p class="notify-details">Cristina Pride</p>
                                      <p class="text-muted mb-0 user-msg">
                                          <small>Hi, How are you? What about our next meeting</small>
                                      </p>
                                  </a>

                      
                                 
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon bg-warning">
                                          <i class="mdi mdi-bell-outline"></i>
                                      </div>
                                      <p class="notify-details">Updates
                                          <small class="text-muted">There are 2 new updates available</small>
                                      </p>
                                  </a>

                              
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon">
                                          <img src="assets/images/users/avatar-4.jpg" class="img-fluid rounded-circle" alt="" /> </div>
                                      <p class="notify-details">Karen Robinson</p>
                                      <p class="text-muted mb-0 user-msg">
                                          <small>Wow ! this admin looks good and awesome design</small>
                                      </p>
                                  </a>

                               
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon bg-danger">
                                          <i class="mdi mdi-account-plus"></i>
                                      </div>
                                      <p class="notify-details">New user
                                          <small class="text-muted">You have 10 unread messages</small>
                                      </p>
                                  </a>

                                
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon bg-info">
                                          <i class="mdi mdi-comment-account-outline"></i>
                                      </div>
                                      <p class="notify-details">Caleb Flakelar commented on Admin
                                          <small class="text-muted">4 days ago</small>
                                      </p>
                                  </a>
                                  <a href="javascript:void(0);" class="dropdown-item notify-item">
                                      <div class="notify-icon bg-secondary">
                                          <i class="mdi mdi-heart"></i>
                                      </div>
                                      <p class="notify-details">Carlos Crouch liked
                                          <b>Admin</b>
                                          <small class="text-muted">13 days ago</small>
                                      </p>
                                  </a>
                              </div>

                              <a href="javascript:void(0);" class="dropdown-item text-center text-primary notify-item notify-all">
                                  View all
                                  <i class="fi-arrow-right"></i>
                              </a>

                          </div>
                      </li>

                      <li class="dropdown notification-list">
                          <a class="nav-link dropdown-toggle nav-user mr-0 waves-effect waves-light" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                              <img src="assets/images/users/avatar-1.jpg" alt="user-image" class="rounded-circle"/>
                          </a>
                          <div class="dropdown-menu dropdown-menu-right profile-dropdown ">
                              <div class="dropdown-header noti-title">
                                  <h6 class="text-overflow m-0">Welcome !</h6>
                              </div>

                              <a href="javascript:void(0);" class="dropdown-item notify-item">
                                  <i class="fe-user"></i>
                                  <span>Profile</span>
                              </a>

                            
                              <a href="javascript:void(0);" class="dropdown-item notify-item">
                                  <i class="fe-settings"></i>
                                  <span>Settings</span>
                              </a>
                              <a href="javascript:void(0);" class="dropdown-item notify-item">
                                  <i class="fe-lock"></i>
                                  <span>Lock Screen</span>
                              </a>

                              <div class="dropdown-divider"></div>
                              <a href="javascript:void(0);" class="dropdown-item notify-item">
                                  <i class="fe-log-out"></i>
                                  <span>Logout</span>
                              </a>

                          </div>
                      </li>
                      <li class="dropdown notification-list">
                          <a href="javascript:void(0);" class="nav-link right-bar-toggle waves-effect waves-light">
                              <i class="fe-settings noti-icon"></i>
                          </a>
                      </li>
                  </ul>
                  <div class="logo-box">
                      <a href="index-2.html" class="logo text-center logo-light">
                          <span class="logo-lg">
                              <img src="assets/images/logo-light.png" alt="" height="20"/>
                              
                          </span>
                          <span class="logo-sm">
                            
                              <img src="assets/images/logo-sm.png" alt="" height="24"/>
                          </span>
                      </a>

                      <a href="index-2.html" class="logo text-center logo-dark">
                          <span class="logo-lg">
                              <img src="assets/images/logo-dark.png" alt="" height="20"/>
               
                          </span>
                          <span class="logo-sm">
                        
                              <img src="assets/images/logo-sm.png" alt="" height="24"/>
                          </span>
                      </a>
                  </div>
              </div>
          </div>
          <div class="topbar-menu">
      <div class="container-fluid">
          <div id="navigation">
              <ul class="navigation-menu">

                  <li class="has-submenu">
                      <a href="index-2.html">
                          <i class="fe-airplay"></i>Dashboard
                      </a>
                  </li>

                  <li class="has-submenu">
                      <a href="#">
                          <i class="fe-briefcase"></i>UI Elements <div class="arrow-down"></div>
                      </a>
                      <ul class="submenu megamenu">
                          <li>
                              <ul>
                                  <li><a href="ui-typography.html">Typography</a></li>
                                  <li><a href="ui-cards.html">Cards</a></li>
                                  <li><a href="ui-buttons.html">Buttons</a></li>
                                  <li><a href="ui-modals.html">Modals</a></li>
                                  <li><a href="ui-checkbox-radio.html">Checkboxs-Radios</a></li>
                                  <li><a href="ui-tabs.html">Tabs</a></li>
                                  <li><a href="ui-progressbars.html">Progress Bars</a></li>
                              </ul>
                          </li>
                          <li>
                              <ul>
                                  <li><a href="ui-notifications.html">Notification</a></li>
                                  <li><a href="ui-carousel.html">Carousel</a></li>
                                  <li><a href="ui-video.html">Video</a></li>
                                  <li><a href="ui-tooltips-popovers.html">Tooltips & Popovers</a></li>
                                  <li><a href="ui-images.html">Images</a></li>
                                  <li><a href="ui-bootstrap.html">Bootstrap UI</a></li>
                              </ul>
                          </li>
                      </ul>
                  </li>

                  <li class="has-submenu">
                      <a href="#"> <i class="fe-target"></i>Admin UI <div class="arrow-down"></div></a>
                      <ul class="submenu">
                          <li><a href="calendar.html">Calender</a></li>
                          <li><a href="admin-grid.html">Grid</a></li>
                          <li><a href="admin-sweet-alert.html">Sweet Alert</a></li>
                          <li><a href="admin-widgets.html">Widgets</a></li>
                          <li><a href="admin-nestable.html">Nestable List</a></li>
                          <li><a href="admin-rangeslider.html">Range Slider</a></li>
                          <li><a href="admin-ratings.html">Ratings</a></li>
                      </ul>
                  </li>

                  <li class="has-submenu">
                      <a href="#">
                          <i class="fe-layers"></i>Components <div class="arrow-down"></div></a>
                      <ul class="submenu">
                          <li class="has-submenu">
                              <a href="#">Icons <div class="arrow-down"></div></a>
                              <ul class="submenu">
                                  <li><a href="icons-colored.html">Colored Icons</a></li>
                                  <li><a href="icons-materialdesign.html">Material Design</a></li>
                                  <li><a href="icons-dripicons.html">Dripicons</a></li>
                                  <li><a href="icons-fontawesome.html">Font awesome</a></li>
                                  <li><a href="icons-feather.html">Feather Icons</a></li>
                              </ul>
                          </li>
                          <li class="has-submenu">
                              <a href="#">Forms <div class="arrow-down"></div></a>
                              <ul class="submenu">
                                  <li><a href="form-elements.html">Form Elements</a></li>
                                  <li><a href="form-advanced.html">Form Advanced</a></li>
                                  <li><a href="form-validation.html">Form Validation</a></li>
                                  <li><a href="form-pickers.html">Form Pickers</a></li>
                                  <li><a href="form-wizard.html">Form Wizard</a></li>
                                  <li><a href="form-mask.html">Form Masks</a></li>
                                  <li><a href="form-summernote.html">Summernote</a></li>
                                  <li><a href="form-quilljs.html">Quilljs Editor</a></li>
                                  <li><a href="form-uploads.html">Multiple File Upload</a></li>
                              </ul>
                          </li>
                          <li class="has-submenu">
                              <a href="#">Tables <div class="arrow-down"></div></a>
                              <ul class="submenu">
                                  <li><a href="tables-basic.html">Basic Tables</a></li>
                                  <li><a href="tables-layouts.html">Tables Layouts</a></li>
                                  <li><a href="tables-datatable.html">Data Table</a></li>
                                  <li><a href="tables-responsive.html">Responsive Table</a></li>
                                  <li><a href="tables-tablesaw.html">Tablesaw Table</a></li>
                                  <li><a href="tables-editable.html">Editable Table</a></li>
                              </ul>
                          </li>
                          <li class="has-submenu">
                              <a href="#">Graphs <div class="arrow-down"></div></a>
                              <ul class="submenu">
                                  <li><a href="charts-flot.html">Flot Charts</a></li>
                                  <li><a href="charts-morris.html">Morris Charts</a></li>
                                  <li><a href="charts-google.html">Google Charts</a></li>
                                  <li><a href="charts-chartist.html">Chartist Charts</a></li>
                                  <li><a href="charts-chartjs.html">Chartjs Charts</a></li>
                                  <li><a href="charts-c3.html">C3 Charts</a></li>
                                  <li><a href="charts-sparkline.html">Sparkline Charts</a></li>
                                  <li><a href="charts-knob.html">Jquery Knob</a></li>
                              </ul>
                          </li>
                          <li class="has-submenu">
                              <a href="#">Maps <div class="arrow-down"></div></a>
                              <ul class="submenu">
                                  <li>
                                      <a href="maps-google.html">Google Maps</a>
                                  </li>
                                  <li>
                                      <a href="maps-vector.html">Vector Maps</a>
                                  </li>
                                  <li>
                                      <a href="maps-mapael.html">Mapael Maps</a>
                                  </li>
                              </ul>
                          </li>
                      </ul>
                  </li>

                  <li class="has-submenu">
                      <a href="#"> <i class="fe-layout"></i>Layouts <div class="arrow-down"></div></a>
                      <ul class="submenu">
                          <li>
                              <a href="layouts-vertical.html">Vertical</a>
                          </li>
                          <li>
                              <a href="layouts-topbar-light.html">Topbar Light</a>
                          </li>
                          <li>
                              <a href="layouts-center-menu.html">Center Menu</a>
                          </li>
                          <li>
                              <a href="layouts-normal-header.html">Unsticky Header</a>
                          </li>
                          <li>
                              <a href="layouts-boxed.html">Boxed</a>
                          </li>
                      </ul>
                  </li>

                  <li class="has-submenu">
                      <a href="#"> <i class="fe-book-open"></i>Pages <div class="arrow-down"></div></a>
                      <ul class="submenu megamenu">
                          <li>
                              <ul>
                                  <li><a href="pages-starter.html">Starter Page</a></li>
                                  <li><a href="pages-login.html">Login</a></li>
                                  <li><a href="pages-register.html">Register</a></li>
                                  <li><a href="pages-logout.html">Logout</a></li>
                                  <li><a href="pages-recoverpw.html">Recover Password</a></li>
                                  <li><a href="pages-lock-screen.html">Lock Screen</a></li>
                              </ul>
                          </li>
                          <li>
                              <ul>
                                  <li><a href="pages-confirm-mail.html">Confirm Mail</a></li>
                                  <li><a href="pages-404.html">Error 404</a></li>
                                  <li><a href="pages-404-alt.html">Error 404-alt</a></li>
                                  <li><a href="pages-500.html">Error 500</a></li>
                              </ul>
                          </li>
                      </ul>
                  </li>

                  <li class="has-submenu">
                      <a href="#"> <i class="fe-folder-plus"></i>Extra Pages <div class="arrow-down"></div></a>
                      <ul class="submenu">
                          <li><a href="extras-about.html">About Us</a></li>
                          <li><a href="extras-contact.html">Contact</a></li>
                          <li><a href="extras-members.html">Members</a></li>
                          <li><a href="extras-timeline.html">Timeline</a></li>
                          <li><a href="extras-invoice.html">Invoice</a></li>
                          <li><a href="extras-maintenance.html">Maintenance</a></li>
                          <li><a href="extras-coming-soon.html">Coming Soon</a></li>
                          <li><a href="extras-faq.html">FAQ</a></li>
                          <li><a href="extras-pricing.html">Pricing</a></li>
                      </ul>
                  </li>

              </ul>
              <div class="clearfix"></div>
          </div>
      </div>
  </div>
    </header>
    {this.props.children}
</div>

    );
  }
}
const Employement = props => {
  if (props.validaterole("Employement", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle" href="#" data-toggle="dropdown" data-i18n="Employment Request">
          <i class="feather icon-codepen"></i>Employment Request</a>
      <ul class="dropdown-menu">
                      {props.validaterole("Contract Processing", "View") ? (
                            <li data-menu="">
                          <Link to="/Contract">
                  <div className="dropdown-item" 
                    data-i18n="Contract Processing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Contract Processing</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("NEAA", "View") ? (
                            <li data-menu="">
                          <Link to="/NEAA">
                  <div className="dropdown-item" 
                    data-i18n="NEA">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">NEA</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Attestation", "View") ? (
                            <li data-menu="">
                          <Link to="/Attestation">
                  <div className="dropdown-item" 
                    data-i18n="Attestation">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Attestation</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
      </ul>
  </li>
    );
  } else {
    return <div />;
  }
};
const Recruitment = props => {
  if (props.validaterole("Recruitment", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle" href="#" data-toggle="dropdown" data-i18n="Other">
          <i class="feather icon-layers"></i>Other</a>
      <ul class="dropdown-menu">
                      {props.validaterole("Training", "View") ? (
                            <li data-menu="">
                          <Link to="/Training">
                  <div className="dropdown-item" 
                    data-i18n="Training">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Training</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Ticketing", "View") ? (
                            <li data-menu="">
                          <Link to="/Ticketing">
                  <div className="dropdown-item" 
                    data-i18n="Ticketing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Ticketing </span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Travelling", "View") ? (
                            <li data-menu="">
                          <Link to="/Travelling">
                  <div className="dropdown-item" 
                    data-i18n="Travel">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Travel</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
      </ul>
  </li>
    );
  } else {
    return <div />;
  }
};
const Administration = props => {
  if (props.validaterole("Administration", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle" href="#" data-toggle="dropdown" data-i18n="Extenal Services">
          <i class="feather icon-layers"></i>Extenal Services</a>
      <ul class="dropdown-menu">
                      {props.validaterole("DCI Clearance", "View") ? (
                            <li data-menu="">
                          <Link to="/DCI">
                  <div className="dropdown-item" 
                    data-i18n="DCI Clearance">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">DCI Clearance</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Passport processing", "View") ? (
                            <li data-menu="">
                          <Link to="/Passport">
                  <div className="dropdown-item" 
                    data-i18n="Passport processing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Passport processing</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Visa Prcoessing", "View") ? (
                            <li data-menu="">
                          <Link to="/Visa">
                  <div className="dropdown-item" 
                    data-i18n="Visa Prcoessing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Visa Prcoessing</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
      </ul>
  </li>
    );
  } else {
    return <div />;
  }
};
const HR = props => {
  if (props.validaterole("Hr Pool", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle" href="#" data-toggle="dropdown" data-i18n="HR Pool">
          <i class="feather icon-layers"></i>HR Pool</a>
      <ul class="dropdown-menu">
      {props.validaterole("Registration", "View") ? (
             <li data-menu="">
          <Link to="/Registration">
  <div className="dropdown-item" 
    data-i18n="Registration">
<i class="feather icon-grid"i/>{" "}
  <span className="nav-label">Registration</span>
  </div>
</Link>
        </li>
          ) : null}
      </ul>
  </li>
    );
  } else {
    return <div />;
  }
};
const Reports = props => {
  if (props.validaterole("Reports", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle" href="#" data-toggle="dropdown" data-i18n="Reports">
          <i class="feather icon-bar-chart-2"></i>Reports</a>
      <ul class="dropdown-menu">
                      {props.validaterole("Custom Reports", "View") ? (
                            <li data-menu="">
                          <Link to="/RegistrationCustom">
                  <div className="dropdown-item" 
                    data-i18n="Custom Reports">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Registration Reports</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Custom Reports", "View") ? (
                            <li data-menu="">
                          <Link to="/MinorCustom">
                  <div className="dropdown-item" 
                    data-i18n="CustomReports">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label">Minor Reports</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                             {props.validaterole("Custom Reports", "View") ? (
                            <li data-menu="">
                          <Link to="/DCICustom">
                  <div className="dropdown-item" 
                    data-i18n="Prcoesing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label"> DCI reports</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                           {props.validaterole("Custom Reports", "View") ? (
                            <li data-menu="">
                          <Link to="/PassportCustom">
                  <div className="dropdown-item" 
                    data-i18n="Proessing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label"> Passport reports</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
                           {props.validaterole("Custom Reports", "View") ? (
                            <li data-menu="">
                          <Link to="/TrainingCustom">
                  <div className="dropdown-item" 
                    data-i18n="Prcossing">
                <i class="feather icon-server"i/>{" "}
                  <span className="nav-label"> Training reports</span>
                  </div>
                </Link>
                        </li>
                          ) : null}
      </ul>
  </li>
    );
  } else {
    return <div />;
  }
};
const SystemAdmin = props => {
  if (props.validaterole("System Administration", "View")) {
    return (
      <li class="dropdown nav-item" data-menu="dropdown">
                        <a class="dropdown-toggle nav-link" href="#" data-toggle="dropdown">
                            <i class="feather icon-settings"></i>
                            <span data-i18n="Starter kit">System Admin</span></a>
                            {props.showmenuvalue ? (
                        <ul class="dropdown-menu">
                                {props.validaterole("System Users", "View") ? (
                            <li data-menu="">
                           <Link to="/users">
                             <div className="dropdown-item" 
                              data-i18n="System Users">
                           <i class="feather icon-users"i/>{" "}
                             <span className="nav-label">System Users</span>
                             </div>
                           </Link>
                             </li>
                               ) : null}
                                 {props.validaterole("Security Groups", "View") ? (
                            <li data-menu="">
                           <Link to="/Usergroups">
                             <div className="dropdown-item" 
                              data-i18n="Security Groups">
                           <i class="feather icon-user"i/>{" "}
                             <span className="nav-label">Security Groups</span>
                             </div>
                           </Link>
                             </li>
                               ) : null}
                                         {props.validaterole("Approvers", "View") ? (
                            <li data-menu="">
                           <Link to="/Approvers">
                             <div className="dropdown-item"
                              data-i18n="Audit Trails">
                          <i class="feather icon-command"></i>{" "}
                             <span className="nav-label">Approval Hierarchy</span>
                             </div>
                           </Link>
                             </li>
                               ) : null}
                                 {props.validaterole("Audit Trails", "View") ? (
                            <li data-menu="">
                           <Link to="/Auditrails">
                             <div className="dropdown-item"
                              data-i18n="Audit Trails">
                          <i class="feather icon-activity"></i>{" "}
                             <span className="nav-label">Audit Trails</span>
                             </div>
                           </Link>
                             </li>
                               ) : null}
                                 {props.validaterole("Roles", "View") ? (
                            <li data-menu="">
                           <Link to="/Roles">
                             <div className="dropdown-item" data-toggle="dropdown"
                              data-i18n="Roles">
                           <i class="feather icon-user"i/>{" "}
                             <span className="nav-label">Roles</span>
                             </div>
                           </Link>
                             </li>
                               ) : null}
                        </ul>
                           ) : null}
                    </li>
    );
  } else {
    return <div />;
  }
};
const Medical = props => {
  if (props.validaterole("Medical", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle"
         href="#" data-toggle="dropdown" data-i18n="Icons">
           <i class="feather  icon-package"></i>Medical</a>
                <ul class="dropdown-menu">
                {props.validaterole("Minor Medical", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Minor">
                             <div className="dropdown-item" 
                              data-i18n="Minor medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Minor Medical</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                      {props.validaterole("Major Medical", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Major">
                             <div className="dropdown-item" 
                              data-i18n="Major medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Major Medical</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                        {props.validaterole("Final Medical", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Final">
                             <div className="dropdown-item" 
                              data-i18n="Final medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Final Medical</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                </ul>
                            </li>
    );
  } else {
    return <div />;
  }
};
// const DashBoards = props => {
//   if (props.validaterole("Dashboard", "View")) {
//     return (
//       <li className="">
//         <Link to="/Home">
//         <i class="feather icon-home"i/>{" "}
//           <span className="nav-label">Dashboard</span>
//         </Link>
//       </li>
//     );
//   } else {
//     return <div />;
//   }
// };
const DashBoards = props => {
  if (props.validaterole("Dashboard", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle"
         href="#" data-toggle="dropdown" data-i18n="Dashboard">
           <i class="feather  icon-home"></i>Dashboard</a>
                <ul class="dropdown-menu">
                {props.validaterole("Dashboard", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Home">
                             <div className="dropdown-item" 
                              data-i18n="Dashboard">
                           <i class="feather icon-home"i/>{" "}
                             <span className="nav-label">Dashboard</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                      {props.validaterole("Monthly", "View") ? (
                                    <li data-menu="">
                                     <Link to="/MonthlyRegistration">
                             <div className="dropdown-item" 
                              data-i18n="medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Analytics</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                </ul>
                            </li>
    );
  } else {
    return <div />;
  }
};
const Parameteres = props => {
  if (props.validaterole("System parameteres", "View")) {
    return (
      <li class="dropdown dropdown-submenu" data-menu="dropdown-submenu">
        <a class="dropdown-item dropdown-toggle"
         href="#" data-toggle="dropdown" data-i18n="Organisation">
           <i class="feather  icon-chrome"></i>Organisation</a>
                <ul class="dropdown-menu">
                {props.validaterole("Facility", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Facility">
                             <div className="dropdown-item" 
                              data-i18n="Medical Facility">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Medical Facility</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                      {props.validaterole("Major Medical", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Major">
                             <div className="dropdown-item" 
                              data-i18n="Major medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">PartentShip</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                        {props.validaterole("Final Medical", "View") ? (
                                    <li data-menu="">
                                     <Link to="/Final">
                             <div className="dropdown-item" 
                              data-i18n="Final medical">
                           <i class="feather icon-eye"i/>{" "}
                             <span className="nav-label">Airlines</span>
                             </div>
                           </Link>
                                    </li>
                                     ) : null}
                                </ul>
                            </li>
    );
  } else {
    return <div />;
  }
};
export default SideBar;
