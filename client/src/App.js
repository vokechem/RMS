import React from "react";
import SideBar from "./SideBar";
import Header from "./Header";
//import { Redirect } from "react-router-dom";
import { Route, Switch } from "react-router-dom";
//import { BrowserRouter, Route, Switch } from "react-router-dom";
//system admin
import Auditrails from "./Forms/SystemAdmin/Auditrails";
import configurations from "./Forms/SystemAdmin/configurations";
import UserGroups from "./Forms/SystemAdmin/UserGroups";
import Roles from "./Forms/SystemAdmin/Roles";
import Users from "./Forms/SystemAdmin/Users";


//general
import Login from "./Login";
import DashBoard from "./DashBoard";
import Footer from "./Footer";
import Notfound from "./Notfound";
import Profile from "./Profile";
import createacc from "./createacc";
import AdminDashboard from "./AdminDashboard";
import ForgotPassword from "./ForgotPassword";
import decode from "jwt-decode";
import EmailVerification from "./EmailVerification";
import Mymenu from "./Mymenu";
//setups
import ResetPassword from "./ResetPassword";
import { HashRouter } from "react-router-dom";
//applications
import Logout from "./Logout";
import SMSdetails from "./Forms/SetUps/SMSdetails";
import smtpdetails from "./Forms/SetUps/smtpdetails";
import Facility from "./Forms/SetUps/Facility";
import Registration from "./Forms/Recruitment/Registration";
import Minor from "./Forms/Recruitment/Minor";
import Major from "./Forms/Recruitment/Major";
import DCI from "./Forms/Recruitment/DCI";
import Passport from "./Forms/Recruitment/Passport";
import Training from "./Forms/Recruitment/Training";
import Contract from "./Forms/Recruitment/Contract";
import NEAA from "./Forms/Recruitment/NEAA";
import Visa from "./Forms/Recruitment/Visa";
import Attestation from "./Forms/Recruitment/Attestation";
import Ticketing from "./Forms/Recruitment/Ticketing";
import Final from "./Forms/Recruitment/Final";
import Travelling  from "./Forms/Recruitment/Travelling";
import CustomReport from "./Forms/Reports/CustomReport";
import MonthlyRegistration from "./Forms/Reports/MonthlyRegistration";
import TravelledReports from "./Forms/Reports/TravelledReports";
import ApplicantsProfile from "./Forms/Reports/ApplicantsProfile";
import RegistrationCustom from "./Forms/Reports/RegistrationCustom";
import MinorCustom from "./Forms/Reports/MinorCustom";
import Counties from "./Forms/SetUps/Counties";
import Countries from "./Forms/SetUps/Countries";
import Cost from "./Forms/Recruitment/Cost";
import requesthandled from "./Forms/Reports/requesthandled";
import PassportCustom from "./Forms/Reports/PassportCustom";
import TrainingCustom from "./Forms/Reports/TrainingCustom";
import DCICustom from "./Forms/Reports/DCICustom";
import NewApprovers from "./Forms/SystemAdmin/NewApprovers";
import ApplicationsApprovals from "./Forms/Recruitment/ApplicationsApprovals";
import MinormedicalApproval from "./Forms/Recruitment/MinormedicalApproval";
import MajorApproval from "./Forms/Recruitment/MajorApproval";
import DCIApproval from "./Forms/Recruitment/DCIApproval";
import PassportApproval from "./Forms/Recruitment/PassportApproval";
import MedicalForm from "./Forms/Reports/MedicalForm";
import ContractApproval from "./Forms/Recruitment/ContractApproval";
import NEAApproval from "./Forms/Recruitment/NEAApproval";
import AttestationApproval from "./Forms/Recruitment/AttestationApproval";
import VisaApproval from "./Forms/Recruitment/VisaApproval";
import FinalApproval from "./Forms/Recruitment/FinalApproval";
import TrainingApproval from "./Forms/Recruitment/TrainingApproval";
import TicketingApproval from "./Forms/Recruitment/TicketingApproval";
import TravelApproval from "./Forms/Recruitment/TravelApproval";
function App() {
  let token = localStorage.getItem("token");
  let UserCategory = localStorage.getItem("UserCategory");
  if (token) {
    if (UserCategory === "System_User") {
      return (
        <div id="wrapper">
          <HashRouter>
            <Header>
                <SideBar />
              <Switch>
                <Route path="/Logout" exact component={Logout} />;
                <Route exact path="/" component={DashBoard} />
                <Route exact path="/Users" component={Users} />
                <Route exact path="/Roles" component={Roles} />
                <Route exct path="/Usergroups" component={UserGroups} />
                <Route exact path="/Auditrails" component={Auditrails} />
                <Route exact path="/configurations" component={configurations}/>
                <Route exact path="/home" component={DashBoard} />
                <Route exact path="/Profile" component={Profile} />
                <Route exact path="/ResetPassword" component={ResetPassword} />
                <Route exact path="/SMSdetails" component={SMSdetails} />
                <Route exact path="/smtpdetails" component={smtpdetails} />
                <Route exact path="/Facility" component={Facility}/>
                <Route exact path="/Registration"component={Registration}/>
                <Route exact path="/Minor"component={Minor}/>
                <Route exact path="/DCI" component={DCI}/>
                <Route exact path="/Passport" component={Passport}/>
                <Route exact path="/Training"component={Training}/>
                <Route exact path="/Major"component={Major}/>
                <Route exact path="/Contract" component={Contract}/>
                <Route exact path="/NEAA" component={NEAA}/>
                <Route exact path="/Visa" component={Visa}/>
                <Route exact path="/Attestation" component={Attestation}/>
                <Route exact path="/Ticketing" component={Ticketing}/>
                <Route exact path="/Final" component={Final}/>
                <Route exact path="/Travelling" component={Travelling}/>
                <Route exact path="/CustomReport" component={CustomReport} />
                <Route exact path="/MonthlyRegistration" component={MonthlyRegistration} />
                <Route exact path="/TravelledReports" component={TravelledReports}/>
                <Route exact path ="/Counties" component={Counties}/>
                <Route exact path ="/Countries" component={Countries}/>
                <Route exact path="/Cost" component={Cost}/>
                <Route exact path="/ApplicantsProfile" component={ApplicantsProfile}/>
                <Route exact path="/RegistrationCustom" component={RegistrationCustom}/>
                <Route exact path="/MinorCustom" component={MinorCustom}/>
                <Route exact path="/PassportCustom" component={PassportCustom}/>
                <Route exact path="/TrainingCustom" component={TrainingCustom}/>
                <Route exact path="/DCICustom" component={DCICustom}/>
                <Route exact path="/Approvers" component={NewApprovers} />
                <Route exact path="/ApplicationsApprovals" component={ApplicationsApprovals} /> 
                <Route exact path ="/MinormedicalApproval" component={MinormedicalApproval}/>
                <Route exact path ="/MajorApproval" component={MajorApproval}/>
                <Route exact path ="/PassportApproval" component={PassportApproval}/>
                <Route exact path ="/DCIApproval" component={DCIApproval}/>
                <Route exact path ="/MedicalForm" component={MedicalForm}/>
                <Route exact path ="/ContractApproval" component={ContractApproval}/>
                <Route exact path ="/NEAApproval"component={NEAApproval}/>
                <Route exact path ="/AttestationApproval" component={AttestationApproval} />
                <Route exact path ="/VisaApproval" component={VisaApproval} />
                <Route exact path ="/FinalApproval" component={FinalApproval} />
                <Route exact path ="/TrainingApproval" component={TrainingApproval} />
                <Route exact path ="/TicketingApproval" component={TicketingApproval} />
                <Route exact path ="/TravelApproval" component={TravelApproval} />
                <Route
                  exact
                  path="/requesthandled"
                  component={requesthandled}
                />
                 <Route component={Notfound} />
              </Switch>
              <Footer />
            </Header>
          </HashRouter>
        </div>
      );
    } else {
      if (UserCategory === "Applicant") {
        return (
          <div id="wrapper">
            <HashRouter>
              <Mymenu />
              <Header>
                <Switch>
                  <Route path="/Logout" exact component={Logout} />;
                  <Route exact path="/" component={DashBoard} />
                  <Route exact path="/Profile" component={Profile} />
                    <Route
                    exact
                    path="/ResetPassword"
                    component={ResetPassword}
                  />
                 Route component={Notfound} />
                </Switch>
                <Footer />
              </Header>
            </HashRouter>
          </div>
        );
      } else {
        return (
          <div id="wrapper">
            <HashRouter>
              <Mymenu />
              <Header>
                <Switch>
                  <Route path="/Logout" exact component={Logout} />;
                  <Route exact path="/" component={DashBoard} />
                  <Route exact path="/Profile" component={Profile} />
                    <Route
                    exact
                    path="/ResetPassword"
                    component={ResetPassword}
                  />
                  <Route component={Notfound} />
                </Switch>
                <Footer />
              </Header>
            </HashRouter>
          </div>
        );
      }
    }
  } else {
    return (
      <div id="wrapper">
        <HashRouter>
          <Switch>
            <Route path="/Logout" exact component={Logout} />;
            <Route path="/" exact component={Login} />
            <Route path="/Login" exact component={Login} />
            <Route path="/AdminDashboard" exact component={AdminDashboard}/>
            <Route path="/createacc" exact component={createacc} />
            <Route path="/ForgotPassword" exact component={ForgotPassword} />
            <Route
              path="/EmailVerification"
              exact
              strict
              component={EmailVerification}
            />
            <Route component={Notfound} />
           
          </Switch>
        </HashRouter>
      </div>
    );
  }
}

export default App;
