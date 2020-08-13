import React, { Component } from "react";
import { Redirect } from "react-router-dom";
import { Link } from "react-router-dom";
const userphoto = localStorage.getItem("UserPhoto");

class Header extends Component {
  constructor() {
    super();
    this.state = {
      ComapnyName: "",
      LoogedinCompay: ""
    };
    this.logout = this.logout.bind(this);
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
          this.setState({ ComapnyName: data[0].Name });
        } else {
          // swal("Oops!", data.message, "error");
        }
      })
      .catch(err => {
        // swal("Oops!", err.message, "error");
      });
  };
  fetchUsersCompanyDetails = () => {
    fetch(
      "/api/configurations/" +
        localStorage.getItem("UserName") +
        "/" +
        localStorage.getItem("UserCategory"),
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-access-token": localStorage.getItem("token")
        }
      }
    )
      .then(res => res.json())
      .then(data => {
        if (data.length > 0) {
          localStorage.setItem("LoogedinCompay", data[0].Name);

          this.setState({ LoogedinCompay: data[0].Name });
        } else {
          // swal("Oops!", data.message, "error");
        }
      })
      .catch(err => {
        // swal("Oops!", err.message, "error");
      });
  };
  componentDidMount() {
    // this.fetchCompanyDetails();
    // this.fetchUsersCompanyDetails();
  }
  logout() {
    localStorage.clear();

    return <Redirect to="/Login" push />;
  }
  render() {
    const pStyle = {
      color: "white",
      float: "left",
      fontSize: "25px",
      textAlign: "center"
    };
    const pStyle1 = {
      color: "#FFC527",
      fontSize: "22px",
      "font-family": "Montserrat, sans-serif"
    };
    const pStyle3 = {
      color: "white",
      float: "left",
      fontSize: "18px",
      "margin-left": 170,
      textAlign: "Center",
    
    };
    const pStyle2 = {
      color: "white",

      fontSize: "15px",
      "margin-left": 3
    };
    let profile = userphoto;
    if (!userphoto) {
      profile = "default.png";
    }
    let photostyle = {
      height: 40,
      width: 40
    };
    let photostyle1 = {
      height: 50,
      width: 130,
      background :"#0079AD"
    };
    let style2 = {
      "text-align": "center",
      "background-color": "#3c8dbc"
    };
    let dropdownmenu = {
      width: "280px",
      background: "#f3f3f4",
      "border- bottom - right - radius": "4px",
      " border - bottom - left - radius": "4px"
    };
   let margin={
    "margin-bottom": "0px",
   };
   let bgpage={
    background :"#0079AD"
  }
  let page={
    color:"#ffffff"
  }
  let body={
    background: "#ECF0F5"
  }
    return (
      <div className="horizontal-layout horizontal-menu 2-columns  navbar-sticky fixed-footer " data-open="hover" data-menu="horizontal-menu" data-col="2-columns"style={body}>
      <div className="content-overlay"></div>
      <nav className="header-navbar navbar-expand-lg navbar navbar-with-menu navbar-fixed navbar-brand-center"style={bgpage}>
          <div className="navbar-header d-xl-block d-none">
              <ul className="nav navbar-nav flex-row">
                  <li className="nav-item">
                  <b style={pStyle1}>RMS</b>
                  </li>
              </ul>
          </div>
          <div className="navbar-wrapper">
              <div className="navbar-container content">
                  <div className="navbar-collapse" id="navbar-mobile">
                      <div className="mr-auto float-left bookmark-wrapper d-flex align-items-center">
                          <ul className="nav navbar-nav bookmark-icons">
                              <img src={ require("./profilepics/download.png") } style={photostyle1} /> 
                          </ul>
                      </div>
                      <ul className="nav navbar-nav float-right">
                          <li className="dropdown dropdown-user nav-item">
                            <a className="dropdown-toggle nav-link dropdown-user-link" href="#" data-toggle="dropdown">
                                  <div className="user-nav d-sm-flex d-none">
                                    <span className="user-name text-bold-600"style={page}> {localStorage.getItem("UserName")}</span>
                                    </div>
                                    <span>
                                    <img
                    src={process.env.REACT_APP_BASE_URL + "/Photos/" + profile}
                    className="rounded-circle"
                    alt="User Image"
                    style={photostyle}   
                  />
                 </span>
                              </a>
                              <div className="dropdown-menu dropdown-menu-right">
                              <Link to="/Profile">
                        <b className="btn btn-default btn-flat">Profile</b>
                      </Link>
                                
                                  <div className="dropdown-divider"></div><a className="dropdown-item"                         
                                  onClick={this.logout}
                        href="/"><i className="feather icon-power"></i> Logout</a>
                              </div>
                          </li>
                      </ul>
                  </div>
              </div>
          </div>
      </nav>

        {this.props.children}
        
      </div>
    );
  }
}
export default Header;
