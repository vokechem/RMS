import React, { Component } from "react";
import {
  Button,
  Card,
  CardBody,
  Row,
  Col,
  Form,
  FormGroup,
  Input,
  Label
} from "reactstrap"
import swal from "sweetalert";
import { User, Lock } from "react-feather"
import { Link } from "react-router-dom";
class Login extends Component {
  constructor() {
    super();
    this.state = {
      username: "",
      password: "",
      redirect: false,
      msg1: "",
      answer: "",
      Correctanswer: "",
      MobileNO: "",
      SMSCode: "",
      UserSMSCode: "",
      MobileVerified: false,
      ShowVerificationText: false,
      token: "",
      VerifyEmailWindow: false,
      stopcounter: true
    };
    this.VerifySMS = this.VerifySMS.bind(this);
  }

  handleInputChange = event => {
    event.preventDefault();
    this.setState({ [event.target.name]: event.target.value });
  };
  handleSubmit = event => {
    event.preventDefault();
    const data = {
      username: this.state.username,
      password: this.state.password
    };

    this.postData("/api/login", data);
  };

  postData(url = ``, data = {}, req, res) {
    return fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    })
      .then(response =>
        response.json().then(data => {
          if (data.success) {
            let Code = Math.floor(100000 + Math.random() * 900000);
            //  this.SendSMS(data.userdata.Phone, Code);
            //timer start
            this.setState({ stopcounter: false });

            var i = 120;
            var inv = setInterval(() => {
              if (i > 0) {
                document.getElementById("counter").innerHTML = --i;
              } else {
                this.setState({ stopcounter: true });
                clearInterval(inv);
              }
            }, 60000 / 60);

            //timer
            const statedata = {
              ShowVerificationText: true,
              SMSCode: Code,
              MobileNO: data.userdata.Phone,
              token: data.token
            };
            this.setState(statedata);
            localStorage.setItem("UserName", data.userdata.Username);
            localStorage.setItem("UserData", JSON.stringify(data.userdata));
            localStorage.setItem("UserPhoto", data.userdata.Photo);
            localStorage.setItem("UserCategory", data.userdata.Category);
          } else {
            let Msgg = data.message;
            if (Msgg === "Email Not Verified!") {
              let emailaddress = data.userdata.Email;
              let activationCode = data.userdata.ActivationCode;
              localStorage.setItem(
                "Unverifiedusername",
                data.userdata.Username
              );
              swal({
                title: "Email Not verified",
                text: "Click OK to send verification code to your email",
                icon: "warning",
                dangerMode: false
              }).then(ValidateNow => {
                if (ValidateNow) {
                  alert("Verification Code has been sent to your email");
                  this.setState({
                    VerifyEmailWindow: true
                  });
                  this.SendMail(activationCode, emailaddress);
                }
              });
            } else {
              swal("", data.message, "error");
            }
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  }
  SendMail(activationCode, email) {
    const emaildata = {
      to: email,
      subject: "EMAIL ACTIVATION",
      activationCode: activationCode
    };
    fetch("/api/sendMail/EmailVerification", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(emaildata)
    })
      .then(response =>
        response.json().then(data => {
          // if (data.success) {
          // } else {
          //   swal("", "Email Could not be sent", "error");
          // }
        })
      )
      .catch(err => {
        //swal("Oops!", err.message, "error");
      });
  }
  SendSMS(MobileNumber, Code) {
    let message =
      "Your Activation Code is: " +
      Code +
      " Use this to activate your account.";
    let data = {
      MobileNumber: MobileNumber,
      Message: message
    };
    return fetch("/api/sendsms", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    })
      .then(response =>
        response.json().then(data => {
          if (data.success) {
          } else {
            swal("", data.message, "error");
          }
        })
      )
      .catch(err => {
        swal("", err.message, "error");
      });
  }
  VerifySMS = () => {
    alert(this.state.SMSCode);
    if (this.state.UserSMSCode) {
      if (this.state.SMSCode == this.state.UserSMSCode) {
        this.setState({
          MobileVerified: true
        });
        localStorage.setItem("token", this.state.token);
        this.setRedirect();
      } else {
        this.setState({ msg1: "Wrong Verification code" });
        this.setState({
          MobileVerified: false
        });
      }
    } else {
      alert("SMS Code is required");
    }
  };
  setRedirect = () => {
    this.setState({
      redirect: true
    });
  };

  render() {
    if (this.state.redirect) {
      return (window.location = "/");
    }
    if (this.state.VerifyEmailWindow) {
      return (window.location = "#/EmailVerification");
    }

    let pstyle = {
      color: "red"
    };
    let btnstyle = {
      background: "#1ab394",
      color: "white"
    };
    return (
      <div class="app-content content">
      <div class="content-overlay"></div>
      <div class="header-navbar-shadow"></div>
      <div class="content-wrapper">
          <div class="content-header row">
          </div>
          <div class="content-body">
              <section class="row flexbox-container">
                  <div class="col-xl-8 col-11 d-flex justify-content-center">
                      <div class="card bg-authentication rounded-0 mb-0">
                          <div class="row m-0">
                              <div class="col-lg-6 d-lg-block d-none text-center align-self-center px-1 py-0">
                                  <img src="../../../app-assets/images/pages/login.png" alt="branding logo"/>
                              </div>
                              <div class="col-lg-6 col-12 p-0">
                                  <div class="card rounded-0 mb-0 px-2">
                                      <div class="card-header pb-1">
                                          <div class="card-title">
                                              <h4 class="mb-0">Login</h4>
                                          </div>
                                      </div>
                                      <p class="px-2">Welcome back, please login to your account.</p>
                                      <div class="card-content">
                                          <div class="card-body pt-1">
                                          <Form onSubmit={this.handleSubmit}>
                          <FormGroup className="form-label-group position-relative has-icon-left">
                            <Input
                              type="text"
                              required
                              placeholder="Username"
                              onChange={this.handleInputChange}
                              name="username"
                              value={this.state.username}
                            />
                            <div className="form-control-position">
                              <User size={15} />
                            </div>
                            <Label>Username</Label>
                          </FormGroup>
                          <FormGroup className="form-label-group position-relative has-icon-left">
                            <Input
                              type="password"
                              required
                              placeholder="Password"
                              onChange={this.handleInputChange}
                              value={this.state.password}
                              name="password"
                            />
                            <div className="form-control-position">
                              <Lock size={15} />
                            </div>
                            <Label>Password</Label>
                          </FormGroup>
                          <FormGroup className="d-flex justify-content-between align-items-center">
                          <label
                        htmlFor="Datereceived"
                        className="font-weight-bold"
                      >
                        SMS Verification Code
                      </label>

                      <div className="input-group form-group">
                        <input
                          type="text"
                          className="form-control"
                          onChange={this.handleInputChange}
                          value={this.state.UserSMSCode}
                          name="UserSMSCode"
                        />{" "}
                        &nbsp; &nbsp;
                        {this.state.stopcounter ? (
                          <button
                            type="submit"
                            className="btn btn-sm btn-success  text-uppercase float-left"
                          >
                           Get SMS
                          </button>
                        ) : (
                            <b
                              style={btnstyle}
                              className="btn btn-sm btn-btn-success"
                              id="counter"
                            ></b>
                          )}
                      </div>
                      <label
                        htmlFor="Datereceived"
                        className="font-weight-bold"
                        style={pstyle}
                      >
                        {this.state.msg1}
                      </label>
                          </FormGroup>
                        </Form>
                             </div>
                           </div>
                                      <div className="d-flex justify-content-between">
                                <Link to="ForgotPassword">Forgot password?</Link>
                            <button type="submit"
                                      onClick={this.VerifySMS}
                                      style={btnstyle}
                                       class="btn btn-success float-center btn-inline">Login</button>
                          </div>
                      <div className="auth-footer">
                        <div className="divider">
                        </div>
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

export default Login;
