import React, { Component } from "react";
import swal from "sweetalert";
import { Redirect } from "react-router-dom";
import { Link } from "react-router-dom";
let userdateils = localStorage.getItem("UserData");
let data = JSON.parse(userdateils);
class ResetPassword extends Component {
  constructor() {
    super();
    this.state = {
      Username: data.Username,
      redirect: false,
      OldPassword: "",
      NewPassword: "",
      CorrectOldPassword: false
    };
    this.ValidateOldpassword = this.ValidateOldpassword.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  ValidateOldpassword = () => {
    return fetch(
      "/api/ResetPassword/" +
        this.state.Username +
        "/" +
        this.state.OldPassword,
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json"
        }
      }
    )
      .then(response =>
        response.json().then(data => {
          if (data.success) {
            this.setState({
              CorrectOldPassword: true
            });
          } else {
            swal("", data.message, "error");
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  };
  handleInputChange = event => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });
  };

  handleSubmit = event => {
    event.preventDefault();
    this.ValidateOldpassword();
    const data = {
      Password: this.state.NewPassword,
      Username: this.state.Username
    };
    if (this.state.CorrectOldPassword) {
      this.postData("/api/ResetPassword", data);
    }
  };

  postData(url = ``, data = {}, req, res) {
    return fetch(url, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    })
      .then(response =>
        response.json().then(data => {
          if (data.success) {
            swal("", "Password has been updated", "success");
            this.setRedirect();
          } else {
            swal("", data.results, "error");
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  }

  setRedirect = () => {
    this.setState({
      redirect: true
    });
  };
  render() {
    let formstyle = {
      margin: "50"
    };
    let divconatinerstyle = {
      width: "70%",
      margin: "0 auto",
      backgroundColor: "white",
      border: "1px solid grey",
      "border-radius": "10px"
    };
    if (this.state.redirect) {
      return <Redirect to="/" push />;
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
                        
                      </div>
                  </div>
              </div>
     
          </div>
          <div class="content-body">
              <section id="description" class="card">
                  <div class="card-header">
                      <h4 class="card-title">Change Password</h4>
                  </div>
                  <div class="card-content">
                      <div class="card-body">
                          <div class="card-text">
                          <div>
        <div style={divconatinerstyle}>
          <form
            style={formstyle}
            onSubmit={this.handleSubmit}
            encType="multipart/form-data"
          >
            <div className=" row">
              <div className="col-md-3"></div>
              <div className="col-md-6">
                <br />
                <div className="form-group">
                  <label htmlFor="OldPassword" className="font-weight-bold">
                    Old Password
                  </label>
                  <input
                    name="OldPassword"
                    type="Password"
                    required
                    className="form-control"
                    onChange={this.handleInputChange}
                    value={this.state.OldPassword}
                    required
                  />
                </div>
              </div>
            </div>
            <div className=" row">
              <div className="col-sm-3"></div>
              <div className="col-sm-6">
                <div className="form-group">
                  <label htmlFor="NewPassword" className="font-weight-bold">
                    New Password
                  </label>
                  <input
                    name="NewPassword"
                    type="Password"
                    required
                    className="form-control"
                    onChange={this.handleInputChange}
                    value={this.state.NewPassword}
                    required
                  />
                </div>
              </div>
            </div>
            <div className=" row">
              <div className="col-sm-7"></div>
              <div className="d-flex justify-content-between">
                <button type="submit" className="btn btn-primary">
                  Update Now
                </button>
                &nbsp;&nbsp;
                <Link to="/">
                  <button type="button" className="btn btn-warning">
                    Cancel
                  </button>
                </Link>
              </div>
            </div>
            <br />
            <br />
          </form>
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
export default ResetPassword;
