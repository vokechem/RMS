import React, { Component } from "react";
import swal from "sweetalert";
import Table from "./../../Table";
import TableWrapper from "./../../TableWrapper";
import "react-toastify/dist/ReactToastify.css";
import ReactHtmlParser from "react-html-parser";
import Popup from "reactjs-popup";
import popup from "./../../Styles/popup.css";
import { ToastContainer, toast } from "react-toastify";
var dateFormat = require('dateformat');
class ApplicationsApprovals extends Component {
    constructor() {
        super();
        this.state = {
            open: false,
            openRequest: false,
            Registration: [],
            Parent: [],
            Applications: [],
            Countries:[],
            counties:[],
            NextOFKin: [],
            Educational: [],
            MySiblings:[],
            ApplicationDocuments: [],
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
           selectedFile: null,
            Decription:"",
            Period:"",
            UserGroup:"",
            Institution:"",
            AddEducational:false,
            AddGuardians:false,
            AddDocuments:false,
            AddNextOFKin:false,
            AddSiblings:false,
            EducationalInstitution:"",
            EducationalPeriod:"" ,
            EducationalDecription:"",
            GuardianName:"",
            GuardianIDNO:"",
            GuardianRelationship:"",
            NextOFKinName:"" ,
            NextOfRelationship:"",
            NextOfCurrentResident:"",
            NextOfContact:"" ,
            SiblingName:"",
            SiblingsSex:"" ,
             SiblingsAge:"",
             Institution:"",
             Decription: "",
             Name: "",
             ParentID:"",
             Relationship:"",
             KRelationship:"",
             Period: "",
             SiblingName: "",
             Age: "",
             Sex: "",
             KinName:"",
             CurrentResident:"",
             Contact:"",
            profile: true,
            summary: false,
            IsUpdate: false,
            openPaymentModal: false,
            selectedFile: null,
            loaded: 0,
            loaded1: 0,
            loaded2:0,
            DocName:"",
            DocumentDescription: "",
            openView: false,
            DocumentsAvailable: false,
        };
         this.fetchMyApplications = this.fetchMyApplications.bind(this);
        this.Resetsate = this.Resetsate.bind(this);
        this.fetchApplicantDetails = this.fetchApplicantDetails.bind(this)
    }
    fetchMyApplications = () => {
        this.setState({ Registration: [] });
        fetch("/api/ApplicationsApprovals/" + localStorage.getItem("UserName"), {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem("token")
            }
        })
            .then(res => res.json())
            .then(ApplicantDetails => {
                if (ApplicantDetails.length > 0) {
                    this.setState({ Registration: ApplicantDetails });
                    this.setState({ open: false });
                    this.setState({ profile: false }); 
                } else {
                    swal("", ApplicantDetails.message, "error");
                }
            })
            .catch(err => {
                swal("", err.message, "error");
            });
    };
    fetchcounties = () => {
        fetch("/api/counties", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(counties => {
            if (counties.length > 0) {
              this.setState({ counties: counties });
            } else {
              swal("", counties.message, "error");
            }
          })
          .catch(err => {
            swal("", err.message, "error");
          });
      };
      fetchcountries = () => {
        fetch("/api/Countries", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(Countries => {
            if (Countries.length > 0) {
              this.setState({ Countries: Countries });
            } else {
              swal("", Countries.message, "error");
            }
          })
          .catch(err => {
            swal("", err.message, "error");
          });
      };
    fetchApplicationfees = (Applicationno) => {
        fetch("/api/applicationfees/" + Applicationno, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem("token")
            }
        })
            .then(res => res.json())
            .then(Applicationfees => {
                if (Applicationfees.length > 0) {

                    this.setState({ Applicationfees: Applicationfees });
                    this.setState({ TotalAmountdue: Applicationfees[0].total });

                }
            })
            .catch(err => {
                swal("", err.message, "error");
            });
    };
    fetchNextOFKin = IDNumber => {
        this.setState({ Parent: [] });
        fetch("/api/NextOFKin/" + IDNumber, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(NextOFKin => {
            if (NextOFKin.length > 0) {
              this.setState({ NextOFKin: NextOFKin });
            } else {
              toast.error(NextOFKin.message);
            }
          })
          .catch(err => {
            toast.error(err.message);
          });
      };
      fetchSiblings = IDNumber => {
        this.setState({ MySiblings: [] });
        fetch("/api/Siblings/" + IDNumber, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(MySiblings => {
            if (MySiblings.length > 0) {
              this.setState({ MySiblings: MySiblings });
            } else {
              toast.error(MySiblings.message);
            }
          })
          .catch(err => {
            toast.error(err.message);
          });
      };
      fetchApplicationDocuments = IDNumber => {
        fetch("/api/applicationdocuments/" + IDNumber, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(ApplicationDocuments => {
            if (ApplicationDocuments.length > 0) {
              this.setState({ ApplicationDocuments: ApplicationDocuments });
            } else {
              swal("", ApplicationDocuments.message, "error");
            }
          })
          .catch(err => {
            swal("", err.message, "error");
          });
      };
      fetchEducational = IDNumber => {
        this.setState({ Educational: [] });
        fetch("/api/Educational/" + IDNumber, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(Educational => {
            if (Educational.length > 0) {
              this.setState({ Educational: Educational });
            } else {
              toast.error(Educational.message);
            }
          })
          .catch(err => {
            toast.error(err.message);
          });
      };
      fetchParent = IDNumber => {
        this.setState({ Educational: [] });
        fetch("/api/Parent/" + IDNumber, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(Parent => {
            if (Parent.length > 0) {
              this.setState({ Parent: Parent });
            } else {
              toast.error(Parent.message);
            }
          })
          .catch(err => {
            toast.error(err.message);
          });
      };
    fetchApplicationDocuments = (Applicationno) => {
        fetch("/api/applicationdocuments/" + Applicationno, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem("token")
            }
        })
            .then(res => res.json())
            .then(ApplicationDocuments => {
                if (ApplicationDocuments.length > 0) {
                    this.setState({ ApplicationDocuments: ApplicationDocuments });

                } else {
                    swal("", ApplicationDocuments.message, "error");
                }
            })
            .catch(err => {
                swal("", err.message, "error");
            });
    };
    handleSubmit = event => {
        event.preventDefault();
        const data = {
            Approver: localStorage.getItem("UserName"),
            IDNumber: this.state.IDNumber,
            Remarks: this.state.Remarks
        };     
        if (this.state.IsAccept){
            this.Approve("/api/ApplicationsApprovals", data);
        }
        if (this.state.IsDecline) {
            this.Decline("/api/ApplicationsApprovals", data);
        }
     
        this.setState({ summary: false });
    };
    GenerateRb1(ApplicationNo) {
        let Grounds=[];
        let Request=[]
        let rows = [...this.state.ApplicationGrounds]
        rows.map((k, i) => {
            if (k.EntryType === "Grounds for Appeal") {
                Grounds.push(k);
            }else{
                Request.push(k);
            }
           
        });
        const data = {
            Grounds: Grounds ,
            Request: Request,
            TenderNo: this.state.TenderNo,
            Applicationno: ApplicationNo,
            PEName: this.state.PEName,
            ApplicationDate: this.state.FilingDate,
            ReceivedDate: dateFormat(new Date().toLocaleDateString(), "mediumDate"),
            ApplicantName: this.state.Applicantname,
            PysicalAddress: this.state.ApplicantPOBox +"-"+ this.state.ApplicantPostalCode +" "+ this.state.ApplicantTown,
            Fax: " ",
            Telephone: this.state.ApplicantMobile,
            Email: this.state.ApplicantEmail
        }; 
        fetch("/api/GenerateRB1Form", {
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
                        //swal("", data.message, "success"); 
                    } else {
                        //swal("", data.message, "error");
                    }
                })
            )
            .catch(err => {
                swal("", err.message, "error");
            });
    }
    SendSMS(MobileNumber, Msg) {
        let data = {
            MobileNumber: MobileNumber,
            Message: Msg
        };
        return fetch("/api/sendsms", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(data)
        })
            .then(response =>
                response.json().then(data => {
                    if (data.success) {
                    } else {
                      //  swal("", data.message, "error");
                    }
                })
            )
            .catch(err => {
               // swal("", err.message, "error");
            });
    }
    SendMail = (Name, email, ID, subject, IDNumber) => {
      const emaildata = {
          to: email,
          subject: subject,
          ID: ID,
          Name: Name,
          IDNumber: IDNumber,
          
      };

      fetch("/api/NotifyApprover", {
          method: "POST",
          headers: {
              "Content-Type": "application/json",
              "x-access-token": localStorage.getItem("token")
          },
          body: JSON.stringify(emaildata)
      })
          .then(response => response.json().then(data => { }))
          .catch(err => {
              //swal("Oops!", err.message, "error");
          });
  };
    notifyPanelmembers = (AproverMobile, Name, AproverEmail, IDNumber, Msg) => {        
      if (Msg == "Applicant") {         
          this.SendSMS(
              AproverMobile,
              "Application " + IDNumber +Name + " that you had submited to Job majuu  has been Approved."
          );
          this.SendMail(
              Name,
              AproverEmail,
              "Notify Applicant on Application Approved",
              "APPLICATION APPROVED",
              IDNumber,
             
          );
      }
  }
  Approve(url = ``, data = {}) {
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

                if (data.success) {                   
                    if (data.results.length > 0) {
                        let NewList = [data.results]
                        NewList[0].map((item, key) =>                                
                            this.notifyPanelmembers(item.Mobile, item.Name, item.Email, item.IDNumber, item.Msg)
                        )
                        //this.NotifyCaseOfficer(data.results[0].ApplicationNo) 
                    }                                         
                    swal("", "Application Approved", "success");
                    this.fetchMyApplications();  
                     
                } else {
                    swal("", data.message, "error");
                }
            })
        )
        .catch(err => {
            swal("", err.message, "error");
        });
}
    sendDeclineNotification = (Mobile, Name, Email, IDNumber)=>{
        this.SendSMS(
            Mobile,
            "Application " + IDNumber +Name + " that you had submited to Job majuu  has been declined."
        );
        this.SendMail(
            Name,
            Email,
            "Application Declined",
            "APPLICATION DECLINED",
            IDNumber,
            this.state.Remarks
        );
    }
    Decline(url = ``, data = {}) {
        fetch(url, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem("token")
            },
            body: JSON.stringify(data)
        })
            .then(response =>
                response.json().then(data => {

                    if (data.success) {                      
                        if (data.results.length > 0) {
                            let NewList = [data.results]
                            NewList[0].map((item, key) =>
                                this.sendDeclineNotification(item.Mobile, item.Name, item.Email, item.IDNumber)
                            )
                            
                        }  
                        swal("", "Application Declined", "success"); 
                        this.fetchMyApplications();        
                        
                    } else {
                        swal("", data.message, "error");
                    }
                })
            )
            .catch(err => {
                swal("", err.message, "error");
            });
    }
  
 
    GoBack = e => {
        e.preventDefault();
        this.setState({ summary: false });
    }
    ShowAcceptModal=e=>{
        
        this.setState({ IsAccept: true, IsDecline: false, open: true  });
    }
    ShowRejectModal = e => {
       
        this.setState({ IsDecline: true, IsAccept: false, open: true });
    }
    Resetsate() {
        const data = {
            TenderNo: "",
            TenderID: "",
            TenderValue: "",
            ApplicationID: "",
            TenderName: "",
            PEID: "",
            StartDate: "",
            ClosingDate: "",
            ApplicationREf: "",
            AdendumDescription: "",
            EntryType: "",
            RequestDescription: "",
            GroundDescription: "",
            ApplicationGrounds: [],
            ApplicationDocuments: [],
            Applicationfees: [],
            FilingDate: "",
            PEName: "",
            ApplicationNo: "",
            AddedAdendums: [],
            AdendumStartDate: "",
            RequestsAvailable: false,
            GroundsAvailable: false,
            AdendumsAvailable: false,
            AdendumClosingDate: "",
            AddAdedendums: false,
            IsUpdate: false,
        };
        this.setState(data);
    }

    fetchTenderAdendums = TenderID => {
        fetch("/api/tenderaddendums/" + TenderID, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem("token")
            }
        })
            .then(res => res.json())
            .then(AddedAdendums => {
                if (AddedAdendums.length > 0) {
                    this.setState({ AddedAdendums: AddedAdendums });
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
                            this.fetchMyApplications();  
                            this.fetchApplicantDetails();
                            this.fetchEducational();
                            this.fetchParent();
                            this.fetchNextOFKin();
                           
                            this.fetchSiblings();
                            this.fetchcounties();
                            this.fetchcountries();
                            this.fetchApplicationDocuments();
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
    formatNumber = num => {
        let newtot = Number(num).toFixed(2);
        return newtot.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    };
    fetchApplicantDetails = () => {
        fetch("/api/Registration/", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": localStorage.getItem("token")
          }
        })
          .then(res => res.json())
          .then(ApplicantDetails => {
            if (ApplicantDetails.length > 0) {
              this.setState({
      
                Gender: ApplicantDetails[0].Gender,
                phone: ApplicantDetails[0].phone,
                DOB: ApplicantDetails[0].DOB,
                Email: ApplicantDetails[0].Email,
                Country: ApplicantDetails[0].Country,
                County:ApplicantDetails[0].County,
                BirthCer: ApplicantDetails[0].BirthCer,
                Religion: ApplicantDetails[0].Religion,
                Marital: ApplicantDetails[0].Marital,
                Height: ApplicantDetails[0].Height,
                Weight: ApplicantDetails[0].Weight,
                Village:ApplicantDetails[0].Village,
                Languages:ApplicantDetails[0].Languages,
                Skills: ApplicantDetails[0].Skills,
                IDNumber:ApplicantDetails[0].IDNumber,
                Classify:ApplicantDetails[0].Classify,
                Agent:ApplicantDetails[0].Agent,
                Job:ApplicantDetails[0].Job,
                photo:ApplicantDetails[0].photo,
                FullPhoto:ApplicantDetails[0].FullPhoto,
              });
              this.fetchMyApplications(ApplicantDetails[0].IDNumber);
            } else {
              swal("", ApplicantDetails.message, "error");
            }
          })
          .catch(err => {
            swal("", err.message, "error");
          });
      };
      hideAlert() {
        this.setState({
          alert: null
        });
      }
    handViewRegistration = k => {
        this.setState({
          EducationalDetails: [],
          SiblingDetails: [],
          ApplicationDocuments: [],
          Guardiandetails: [],
          NextOFKinDetails: []
        });
        this.fetchEducational(k.IDNumber);
        this.fetchMyApplications(k.IDNumber);
        this.fetchNextOFKin(k.IDNumber);
        this.fetchParent(k.IDNumber);
        this.fetchSiblings(k.IDNumber);
        this.fetchApplicationDocuments(k.IDNumber)
        const data = {
          IDNumber:k.IDNumber,
          Fullname: k.Fullname,
          phone: k.phone,
          Email: k.Email,
          Gender: k.Gender,
          DOB: new Date(k.DOB).toLocaleDateString(),
          Country: k.Country,
          County: k.County,
          Religion: k.Religion,
          Marital: k.Marital,
          Height: k.Height,
          Weight: k.Weight,
          BirthCer: k.BirthCer,
          Skills: k.Skills,
          Languages:k.Languages,
          Classify:k.Classify,
          photo:k.photo,
          FullPhoto:k.FullPhoto,
          Agent:k.Agent,
          Job:k.Job,
          Institution: k.Institution,
          Decription: k.Decription,
          Name: k.Name,
          ParentID: k.ParentID,
          Relationship: k.Relationship,
          KRelationship:k.KRelationship,
          Period: k.Period,
          SiblingName: k.SiblingName,
          Age: k.Age,
          Sex: k.Sex,
          KinName:k.KinName,
          CurrentResident:k.CurrentResident,
          Contact:k.Contact,
          Description:k.Description,
          DocName:k.DocName,
          summary: true,
          ApplicationCreated_By: k.Created_By,
          PaymentStatus: k.PaymentStatus,
        };
        this.setState({ summary: true });      
        this.setState(data);
     
    }
    handleInputChange = event => {
        event.preventDefault();
        this.setState({ [event.target.name]: event.target.value });
    };
    openRequestTab() {
        document.getElementById("nav-profile-tab").click();
    }
    closeModal=() =>{
        this.setState({ open: false });
    }
    ViewFile = (k, e) => {
        let filepath = k.Path + "/" + k.FileName;
        window.open(filepath);
        //this.setState({ openFileViewer: true });
    };
    render() {
        const ColumnData = [
     
            {
              label: "FullName",
              field: "Fullname",
              sort: "asc"
            },
            { label: "IDNumber", field: "IDNumber" },
      
            {
              label: "phone",
              field: "phone",
              sort: "asc"
            },
            {
              label: "Email",
              field: "Email",
              sort: "asc"
            },
            {
              label: "Gender",
              field: "Gender",
              sort: "asc"
            },
            {
              label: "Action",
              field: "Action",
              sort: "asc",
              width: 200
            }
          ];
          let Rowdata1 = [];
          const rows = [...this.state.Registration];
          if (rows.length > 0) {
            rows.forEach(k => {
              const Rowdata = {
                  Fullname: (
                    <a onClick={e => this.handViewRegistration(k, e)}>
                      {k.Fullname}
                    </a>
                  ),
                  IDNumber: (
                    <a onClick={e => this.handViewRegistration(k, e)}>
                      {k.IDNumber}
                    </a>
                  ),
                  Gender: (
                    <a onClick={e => this.handViewRegistration(k, e)}>
                      {k.Gender}
                    </a>
                  ),
                  phone: (
                    <a onClick={e => this.handViewRegistration(k, e)}>
                      {k.phone}
                    </a>
                  ),
                  Email: (
                    <a onClick={e => this.handViewRegistration(k, e)}>
                      {k.Email}
                    </a>
                  ),
                  Action: (
                    <span>
                      <a
                        style={{ color: "#007bff" }}
                        onClick={e => this.handViewRegistration(k, e)}
                      >
                        {" "}
                        View{" "}
                      </a>
                    </span>
                  )
              };
              Rowdata1.push(Rowdata);
            });
          }
        let headingstyle = {
            color: "#7094db"
        }

        let FormStyle = {
            margin: "20px"
          };
          let formcontainerStyle = {
            border: "1px solid grey",
            "border-radius": "10px"
          };
          let form2containerStyle = {
            border: "1px solid grey",
            "border-radius": "10px",
            margin: "50"
          };
          let divconatinerstyle = {
            width: "95%",
            margin: "0 auto",
            backgroundColor: "white"
          };
            let photostyle = {
              height: 150,
              width: 150
            };
            let Fullstyle = {
              height: 150,
              width: 150
            };
            let photo = this.state.photo;
            if (!this.state.photo) {
              photo = "default.png";
            }
            let FullPhoto = this.state.FullPhoto;
            if (!this.state.FullPhoto) {
              photo = "default.png";
            }
      
          let childdiv = {
            margin: "30px"
          };
          let adendumslink = {
            "margin-left": "40px",
            color: "blue"
          };
          let formstyle = {
            margin: "50"
          };
          let divconatinerstyle1 = {
            width: "70%",
            margin: "0 auto",
            backgroundColor: "white",
            border: "1px solid grey",
            "border-radius": "10px"
          };
          let ViewFile = this.ViewFile;
   
            if (this.state.summary) {
                return (
                    <div class="app-content content">
                    <div class="content-overlay"></div>
                    <div class="header-navbar-shadow"></div>
                    <div class="content-wrapper">
                        <div class="content-header row">
                            <div class="content-header-left col-md-9 col-12 mb-2">
                                <div class="row breadcrumbs-top">
                                    <div class="col-12">
                                        <h4 class="content-header-title float-left mb-0">Profile:{this.state.Fullname}</h4>
                                        <div class="breadcrumb-wrapper col-12">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="content-header-right text-md-right col-md-3 col-12 d-md-block d-none">
                    <div class="form-group breadcrum-right">
                    <button className="btn btn-primary" onClick={this.ShowAcceptModal} style={{ marginTop: 20 }}>Approve</button>
                                  &nbsp;&nbsp;
                                <button className="btn btn-danger " onClick={this.ShowRejectModal} style={{ marginTop: 20 }}>Decline</button>
                                &nbsp;&nbsp;
                                <button
                                    type="button"
                                    style={{ marginTop: 20 }}
                                    onClick={this.GoBack}
                                    className="btn btn-primary"
                                >
                                     Back
                                </button>
                        </div>
                        </div>
                        </div>
                        <div class="content-body">
                            <section id="description" class="card">
                                <div class="card-content">
                                    <div class="card-body">
                                        <div class="card-text">
                                        <div className="border-bottom white-bg p-4">
                        <div className="row">
                          <div className="col-sm-6">
                          <h3 style={headingstyle}>Applicant Details</h3>
                            <div className="col-lg-10 border border-success rounded">
                              <table className="table table-borderless table-sm">
                                <tr>
                                  <td className="font-weight-bold"> Fullname:</td>
                                  <td> {this.state.Fullname}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> EMAIL:</td>
                                  <td> {this.state.Email}</td>
                                </tr>
          
                                <tr>
                                  <td className="font-weight-bold"> Mobile:</td>
          
                                  <td> {this.state.phone}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Gender:</td>
          
                                  <td> {this.state.Gender}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Date of Birth:</td>
          
                                  <td> {this.state.DOB}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Nationality:</td>
                                  <td> {this.state.Country}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Religion:</td>
                                  <td> {this.state.Religion}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Marital Status:</td>
                                  <td> {this.state.Marital}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Languages:</td>
                                  <td> {this.state.Languages}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Skills:</td>
                                  <td> {this.state.Skills}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Classification:</td>
                                  <td> {this.state.Classify}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Height:</td>
                                  <td> {this.state.Height}</td>
                                </tr>
                                <tr>
                                  <td className="font-weight-bold"> Weight:</td>
                                  <td> {this.state.Weight}</td>
                                </tr>
                              </table>
                            </div>
                          </div>
                          <div className="col-lg-6">
                          <h3 style={headingstyle}> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</h3>
                          
                            <div className="col-lg-10 border border-success rounded">
                              <table className="table table-borderless table-sm">
                                <tr>
                                  <td className="font-weight-bold"> Passport:</td>
                                  <td>  <img
                          alt="image"
                          className=""
                          src={process.env.REACT_APP_BASE_URL + "/Passport/" + photo}
                          style={photostyle}
                        /></td>
                        </tr>
                         <tr>
                                  <td className="font-weight-bold"> FullPhoto:</td>
                           <td>  <img
                          alt="image"
                          className=""
                          src={process.env.REACT_APP_BASE_URL + "/Registration/" + FullPhoto}
                          style={photostyle}
                        /></td>
                                </tr>
                              </table>
                            </div>
                          </div>
                        </div>
                        <br />
                        <div className="row">
                          <div className="col-lg-12 ">
                            <h3 style={headingstyle}>Education Details</h3>
                            <div className="col-lg-11 border border-success rounded">
                              <table className="table table-sm">
                                <thead className="thead-light">
                                  <th>Institution</th>
                                  <th>Course</th>
                                  <th>Period</th>
                                </thead>
                                {this.state.Educational.map((r, i) => (
                                  <tr>
                                    <td>{r.Institution}</td>
                                    <td> {r.Decription} </td>
                                    <td> {r.Period} </td>
                                  </tr>
                                ))}
                              </table>
                            </div>
                          </div>
                        </div>
                        <br/>
                        <div className="row">
                          <div className="col-lg-12 ">
                            <h3 style={headingstyle}>Guaridan Details</h3>
                            <div className="col-lg-11 border border-success rounded">
                              <table className="table table-sm">
                                <thead className="thead-light">
                                  <th>Name</th>
                                  <th>ID number</th>
                                  <th>Relationship</th>
                                </thead>
                                {this.state.Parent.map((r, i) => (
                                  <tr>
                                    <td>{r.Name}</td>
                                    <td> {r.ParentID} </td>
                                    <td> {r.Relationship} </td>
                                  </tr>
                                ))}
                              </table>
                            </div>
                          </div>
                        </div>
                        <br/>
                        <div className="row">
                          <div className="col-lg-12 ">
                            <h3 style={headingstyle}>Next of kin Details</h3>
                            <div className="col-lg-11 border border-success rounded">
                              <table className="table table-sm">
                                <thead className="thead-light">
                                  <th>Name</th>
                                  <th>Relationship</th>
                                  <th>Current Resident</th>
                                  <th>Contact</th>
                                </thead>
                                {this.state.NextOFKin.map((r, i) => (
                                  <tr>
                                    <td>{r.KinName}</td>
                                    <td> {r.KRelationship} </td>
                                    <td> {r.CurrentResident} </td>
                                    <td> {r.Contact} </td>
                                  </tr>
                                ))}
                              </table>
                            </div>
                          </div>
                        </div>
                        <br/>
                        <div className="row">
                          <div className="col-lg-12 ">
                            <h3 style={headingstyle}>Siblings Details</h3>
                            <div className="col-lg-11 border border-success rounded">
                              <table className="table table-sm">
                                <thead className="thead-light">
                                  <th>Name</th>
                                  <th>Gender</th>
                                  <th>Age</th>
                                </thead>
                                {this.state.MySiblings.map((r, i) => (
                                  <tr>
                                    <td>{r.SiblingName}</td>
                                    <td> {r.Sex} </td>
                                    <td> {r.Age} </td>
                                  </tr>
                                ))}
                              </table>
                            </div>
                          </div>
                        </div>
                        <br />
                        <div className="row">
                          <div className="col-lg-12 ">
                            <h3 style={headingstyle}>Documents Attached</h3>
                            <div className="col-lg-11 border border-success rounded">
                              <table className="table table-sm">
                                <thead className="thead-light">
                                  <th>#</th>
                                  <th>Document Description</th>
                                  <th>FileName</th>
                                  <th>Actions</th>
                                </thead>
                                {this.state.ApplicationDocuments.map((k, i) => (
                                    <tr>
                                      <td>{i + 1}</td>
                                      <td>{k.Description}</td>
                                      <td>{k.DocName}</td>
                                      <td>
                                        <a
                                          onClick={e => ViewFile(k, e)}
                                          className="text-success"
                                        >
                                          <i class="fa fa-eye" aria-hidden="true"></i>View
                                        </a>
                                      </td>
                                    </tr>
                                  
                                  ))}
                              </table>
                            </div>
                          </div>
                        </div>
                        <br/>
                        <div className="row">
                                <div className="col-lg-9"></div>
                                <div className="col-lg-3">
                                  &nbsp; &nbsp;
                                  <button
                                    type="button"
                                    onClick={this.GoBack}
                                    className="btn btn-danger"
                                  >
                                    Back
                                  </button>
                                </div>
                              </div>
                      </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </div>
                    <Popup
                            open={this.state.open}
                            closeOnDocumentClick
                            onClose={this.closeModal}
                        >
                            <div className={popup.modal}>    
                                <div className={popup.content}>
                                    <div className="container-fluid">
                                        <div className="col-sm-12">
                                            <div className="ibox-content">
                                                <form onSubmit={this.handleSubmit}>
                                                    <div className=" row">
                                                        <div className="col-sm">
                                                            <div className="form-group">
                                                                <label
                                                                    htmlFor="exampleInputPassword1"
                                                                    className="font-weight-bold"
                                                                >
                                                                    Remarks
                                                                 </label>
                                                                <textarea
                                                                    onChange={this.handleInputChange}
                                                                    value={this.state.Remarks}
                                                                    type="text"
                                                                    required
                                                                    name="Remarks"
                                                                    className="form-control"
                                                                    id="exampleInputPassword1"
                                                                   
                                                                />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div className="col-sm-12 ">
                                                        <div className=" row">     
                                                            <div className="col-sm-8" />
                                                            <div className="col-sm-2">
                                                                <button
                                                                    type="submit"
                                                                    className="btn btn-primary "
                                                                >
                                                                    Confirm
                                                                </button>
                                                              </div>
                                                              <div className="col-sm-2">
                                                                <button
                                                                    className="btn btn-danger "
                                                                    onClick={this.closeModal}
                                                                >
                                                                    Cancel
                                                            </button>  
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </Popup>
                </div>
                      
                )

            } else {
                return (
                    <div class="app-content content">
                    <div class="content-overlay"></div>
                    <div class="header-navbar-shadow"></div>
                    <div class="content-wrapper">
                        <div class="content-header row">
                            <div class="content-header-left col-md-9 col-12 mb-2">
                                <div class="row breadcrumbs-top">
                                    <div class="col-12">
                                        <h4 class="content-header-title float-left mb-0">Pending Approval</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="content-body">
                        <section id="description" class="card">
                              <div class="card-header">
                                  <h4 class="card-title">Search</h4>
                              </div>
                              <div class="card-content">
                                  <div class="card-body">
                                      <div class="card-text">
                  
                                      </div>
                                  </div>
                              </div>
                          </section>
                            <section id="description" class="card">
                                <div class="card-content">
                                    <div class="card-body">
                                        <div class="card-text">
                                        <TableWrapper>
                        <Table Rows={Rowdata1} columns={ColumnData} />
                      </TableWrapper>
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
}

export default ApplicationsApprovals;
