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
     <div class="horizontal-menu-wrapper">
        <div class="header-navbar navbar-expand-sm navbar navbar-horizontal fixed-top navbar-shadow menu-border"  role="navigation" data-menu="menu-wrapper" style={bgpage}>
            <div class="navbar-header">
                <ul class="nav navbar-nav flex-row">
                    <li class="nav-item mr-auto"><a class="navbar-brand" href="../../../html/ltr/horizontal-menu-template/index.html">
                            <div class="brand-logo"></div>
                            <h2 class="brand-text mb-0">JObMajuu</h2>
                        </a></li>
                    <li class="nav-item nav-toggle"><a class="nav-link modern-nav-toggle pr-0"
                     data-toggle="collapse"><i class="feather icon-x d-block d-xl-none font-medium-4 primary toggle-icon"></i>
                     <i class="toggle-icon feather icon-disc font-medium-4 d-none d-xl-block collapse-toggle-icon primary" data-ticon="icon-disc">
                       </i></a></li>
                </ul>
            </div>
            <div class="navbar-container main-menu-content" data-menu="menu-container">
                <ul class="nav navbar-nav" id="main-menu-navigation" data-menu="menu-navigation"style={menucolor}>
               <DashBoards validaterole={this.validaterole} />
               <HR
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showHRPool}
              MenuStyle={MenuStyle}
            />
              <Administration
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showHRPool}
              MenuStyle={MenuStyle}
            />
              <Employement
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuEmployement}
              MenuStyle={MenuStyle}
            />
               <Medical
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMedical}
            />
             <Recruitment
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuRecruitment}
              MenuStyle={MenuStyle}
            />
            <Parameteres
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuParameteres}
              MenuStyle={MenuStyle}
            />
            <SystemAdmin
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuAdmin}
            />
            <Reports
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuReports}
              MenuStyle={MenuStyle}
            />
              {/* <Analytics
              validaterole={this.validaterole}
              showMenu={this.showMenu}
              showmenuvalue={this.state.showMenuAnalytics}
              MenuStyle={MenuStyle}
            /> */}
                </ul>
            </div>
          
        </div>
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
