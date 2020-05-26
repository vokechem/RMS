var express = require("express");
var NotifyApprover = express();
var mysql = require("mysql");
var config = require("./../../DB");
let nodeMailer = require("nodemailer");
var con = mysql.createPool(config);
NotifyApprover.post("/", function(req, res) {
  try {
  const ID = req.body.ID;
    
    if (ID === "Notify Applicant Interested Application Approved") {
      const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
      "An Application for review: <b>${req.body.ApplicationNo}: ${req.body.Applicant} VS ${req.body.PE} </b>  with respect to Tender NO: ${req.body.tenderNo} (${req.body.tendername}) has been filed.<br></br>Login to ARCMS."          
    <br></br>
    This is computer generated message.Please do not reply.`;
      con.getConnection(function (err, connection) {
        let sp = "call getSMTPDetails()";
        connection.query(sp, function (error, results, fields) {
          if (error) {
            res.json({
              success: false,
              message: error.message
            });
          } else {
            let Host = results[0][0].Host;
            let Port = results[0][0].Port;
            let Sender = results[0][0].Sender;
            let Password = results[0][0].Password;

            let transporter = nodeMailer.createTransport({
              host: Host,
              port: Port,
              secure: true,
              auth: {
                // should be replaced with real sender's account
                user: Sender,
                pass: Password
              },
              tls: {
                rejectUnauthorized: false
              }
            });

            let mailOptions = {
              to: req.body.to,
              subject: req.body.subject,
              html: output
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                res.json({
                  success: false,
                  message: "Not Sent"
                });
              } else {
                res.json({
                  success: true,
                  message: "Sent"
                });
              }
            });
          }
          connection.release();
        });
      });
    }
    if (ID === "DCI Declined") {
      const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Dear: <b>${req.body.Name}</b>
       your DCI Application that you had submited via Job Majuu has been <b>DECLINED</b>:  
        <br></br>
      This is computer generated message.Please do not reply.`;
      con.getConnection(function(err, connection) {
        let sp = "call getSMTPDetails()";
        connection.query(sp, function(error, results, fields) {
          if (error) {
            res.json({
              success: false,
              message: error.message
            });
          } else {
            let Host = results[0][0].Host;
            let Port = results[0][0].Port;
            let Sender = results[0][0].Sender;
            let Password = results[0][0].Password;
  
            let transporter = nodeMailer.createTransport({
              host: Host,
              port: Port,
              secure: true,
              auth: {
                // should be replaced with real sender's account
                user: Sender,
                pass: Password
              },
              tls: {
                rejectUnauthorized: false
              }
            });
  
            let mailOptions = {
              to: req.body.to,
              subject: req.body.subject,
              html: output
            };
  
            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                res.json({
                  success: false,
                  message: "email not sent"
                });
              } else {
                res.json({
                  success: true,
                  message: "sent"
                });
              }
            });
          }
          connection.release();
        });
      });
    }
  if (ID === "Application Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Dear: <b>${req.body.Name}</b>
     your Application that you had submited to Job Majuu has been <b>DECLINED</b>:  
      <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "email not sent"
              });
            } else {
              res.json({
                success: true,
                message: "sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "MinorMedical Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Minor Medical result 
      that you had submited to Job Majuu has been <b>DECLINED</b>
      <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "email not sent"
              });
            } else {
              res.json({
                success: true,
                message: "sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Passport Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Contract processing
      that you had submited to Job Majuu has been <b>DECLINED</b>
      <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "email not sent"
              });
            } else {
              res.json({
                success: true,
                message: "sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Contract Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Contract processing
      that you had submited to Job Majuu has been <b>DECLINED</b>
      <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "email not sent"
              });
            } else {
              res.json({
                success: true,
                message: "sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Minor Medical Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your minor medical has been approval.Thank         
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
              //console.log(mailOptions);
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
              //console.log(mailOptions);
            }
          });
    
        }
        connection.release();
      });
    });
  }
  
  if (ID === "Notify Applicant on Application Approved") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
      "Dear <b>${req.body.Name}</br>Application that you had submited to Job majuu  has been APPROVED<b></b>."          
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
              // console.log(mailOptions);
            } else {
              res.json({
                
                success: true,
                message: "Sent"
              });
            }
          });
          
        }
        connection.release();
      });
    });
  }
  if (ID === "DCI Approval") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
    DCI processing that you had submited to Job majuu has been <b>Approved<b/>.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
             
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
              //console.log(mailOptions)
            }
          });
        }
        connection.release();
      });
    });
  }
  
  if (ID === "Contract Approval") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
    Contract Processing that you had submited to Job majuu has been <b>Approved<b/>.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
             
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
              //console.log(mailOptions)
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "PEresponseCaseOfficer") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
    <b>${req.body.PEName}.</b> has submited response to Application: <b>${req.body.ApplicationNo}.</b> You are required to form a panel and submit it for review.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Send Hearing Notice") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Hearing date for application: <b>${req.body.ApplicationNo}.</b> has been set.Attached to this email is the Notice with details on the hearing date and venue.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output,
            attachments: {
              // use URL as an attachment
              filename: req.body.AttachmentName,
              path: req.body.Attachmentpath
            }
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "CaseAdjournmentCaseofficer") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to adjourn application: <b>${req.body.ApplicationNo}.</b> has been <b>ACCEPTED</b>.You are requested to re-schedule hearing date.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "CaseadjournRejected") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to adjourn application: <b>${req.body.ApplicationNo}.</b> has been <b>REJECTED</b>.The reason why it was rejected is given below:<br></br><br></br> 
     <b>${req.body.Reason}</b>
     <br></br><br></br>  The Appeal will proceed as scheduled.<br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "CaseAdjournmentAccepted") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to adjourn application: <b>${req.body.ApplicationNo}.</b> has been <b>ACCEPTED</b>.You will be notified on the new date.
    <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "case adjourn Applicant") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Your request to adjourn application: <b>${req.body.ApplicationNo}</b> has been <b>RECEIVED</b> and it's awaiting approval.<br></br><br></br> 
   
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "case adjourn Approver") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to adjourn application: <b>${req.body.ApplicationNo}</b> has been <b>SUBMITED</b> and it's awaiting your review.<br></br><br></br> 
   
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "CaseWithdrawalRejected") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to withdraw appeal: <b>${req.body.ApplicationNo}.</b> has been <b>REJECTED</b>.The reason why it was rejected is given below:<br></br><br></br> 
     <b>${req.body.Reason}</b>
     <br></br><br></br>  The Appeal will proceed as scheduled.<br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "CaseWithdrawalAccepted") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
     Request to withdraw appeal: <b>${req.body.ApplicationNo}.</b> has been <b>ACCEPTED</b>.The Appeal is now marked withdrawn.<br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "casewithdrawal Applicant") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>
      Your request to withdraw appeal: <b>${req.body.ApplicationNo}.</b> has been received and is awaiting approval.<br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "casewithdrawal") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>New request to withdraw appeal: <b>${req.body.ApplicationNo}.</b> Has been submited and it's awaiting your review.<br></br>
    This is computer generated message.Do not reply`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Notify PE") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>New Application: <b>${req.body.ApplicationNo}.</b>
     Has been submited to PUBLIC PROCUREMENT ADMINISTRATIVE REVIEW BOARD, you are required to Login to ARCMS System to submit your response before 
     <b>${req.body.ResponseTimeout}</b>.
      <br></br>
    This is computer generated message.Please do not reply.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "OfficerReasinment") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>You have been asigned to a case for Application: <b>${req.body.ApplicationNo}.</b>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }

  if (ID === "PanelMember") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>You have been selected to be in a Panel for Application: <b>${req.body.ApplicationNo}.</b>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "HEARING SCHEDULING") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Panel List for Application: <b>${req.body.ApplicationNo}</b> 
    has been approved,You are required to schedule hearing date.`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
    if (ID === "DECISION REPORT DECLINED") {
      const output = `<p>Attention <b>${req.body.Name}</b>.<br></br> Decision for Application: <b>${req.body.ApplicationNo} </b> has been <strong>DECLINED</strong> due to:<br></br>
       ${req.body.Remarks}.<br></br>
   Edit and resubmit for reviw.</br>
    </p>`;
      con.getConnection(function (err, connection) {
        let sp = "call getSMTPDetails()";
        connection.query(sp, function (error, results, fields) {
          if (error) {
            res.json({
              success: false,
              message: error.message
            });
          } else {
            let Host = results[0][0].Host;
            let Port = results[0][0].Port;
            let Sender = results[0][0].Sender;
            let Password = results[0][0].Password;

            let transporter = nodeMailer.createTransport({
              host: Host,
              port: Port,
              secure: true,
              auth: {
                // should be replaced with real sender's account
                user: Sender,
                pass: Password
              },
              tls: {
                rejectUnauthorized: false
              }
            });

            let mailOptions = {
              to: req.body.to,
              subject: req.body.subject,
              html: output
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                res.json({
                  success: false,
                  message: "Not Sent"
                });
              } else {
                res.json({
                  success: true,
                  message: "Sent"
                });
              }
            });
          }
          connection.release();
        });
      });
    }
  if (ID === "DECISION REPORT") {
      const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>New Decision  for Application: <b>${req.body.ApplicationNo} </b> has been <strong>Submited</strong> 
   and it's awaiting your reviw.</br>
    </p>`;
      con.getConnection(function (err, connection) {
        let sp = "call getSMTPDetails()";
        connection.query(sp, function (error, results, fields) {
          if (error) {
            res.json({
              success: false,
              message: error.message
            });
          } else {
            let Host = results[0][0].Host;
            let Port = results[0][0].Port;
            let Sender = results[0][0].Sender;
            let Password = results[0][0].Password;

            let transporter = nodeMailer.createTransport({
              host: Host,
              port: Port,
              secure: true,
              auth: {
                // should be replaced with real sender's account
                user: Sender,
                pass: Password
              },
              tls: {
                rejectUnauthorized: false
              }
            });

            let mailOptions = {
              to: req.body.to,
              subject: req.body.subject,
              html: output
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                res.json({
                  success: false,
                  message: "Not Sent"
                });
              } else {
                res.json({
                  success: true,
                  message: "Sent"
                });
              }
            });
          }
          connection.release();
        });
      });
    }
  if (ID === "PanelApprover") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>New Panel List for Application: <b>${req.body.ApplicationNo} </b> has been <strong>Submited</strong> 
   and it's awaiting your reviw.</br>
    </p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "DeadlineExtensionDeclined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Your Request for <b>DEADLINE EXTENSION </b> has been <strong>DECLINED</strong> due to the following reason(s):<br></br>
    ${req.body.Remarks}.<br></br> You are expected to submit your response before the date given earlier which is on: <strong>${req.body.NewDeadline}</strong.</br>
    </p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "DeadlineExtensionApproved") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>Your Request for <b>DEADLINE EXTENSION </b> has been fully approved and the new deadline is on: <strong>${req.body.NewDeadline}</strong.</br>
    .</p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "DeadlineExtension") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></br>New Request for <b>DEADLINE EXTENSION APPROVAL</b> has been submited and is awaiting your review.</br>
    Please Login to ARCMS to view more details.</p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID === "Applicant") {
    const output = `<p>Your Application with APPLICATIONNO :<b>${req.body.ApplicationNo}</b> has been received
         and a response will be sent back to you once it has been verified.</p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }

  if (ID == "Approver") {
    const output = `<p>New application has been sent and its awaiting your review.</p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  if (ID == "FeesApprover") {
    const output = `<p>New application fees approval request for application with ReferenceNo :<b>${req.body.ApplicationNo}</b> has been sent and its awaiting your review.</p>`;
    con.getConnection(function(err, connection) {
      let sp = "call getSMTPDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let Host = results[0][0].Host;
          let Port = results[0][0].Port;
          let Sender = results[0][0].Sender;
          let Password = results[0][0].Password;

          let transporter = nodeMailer.createTransport({
            host: Host,
            port: Port,
            secure: true,
            auth: {
              // should be replaced with real sender's account
              user: Sender,
              pass: Password
            },
            tls: {
              rejectUnauthorized: false
            }
          });

          let mailOptions = {
            to: req.body.to,
            subject: req.body.subject,
            html: output
          };

          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              res.json({
                success: false,
                message: "Not Sent"
              });
            } else {
              res.json({
                success: true,
                message: "Sent"
              });
            }
          });
        }
        connection.release();
      });
    });
  }
  } catch (e) {
    res.json({
      success: false,
      message: "Error occured while sending Email"
    });
  } 
});
NotifyApprover.get("/:ID", function(req, res) {
  const ID = req.params.ID;

  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call GetApproverDetails(?)";
      connection.query(sp, [ID], function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          res.json({
            success: true,
            message: "saved",
            results: results[0]
          });
          //res.json(results[0]);
        }
        connection.release();
        // Don't use the connection here, it has been returned to the pool.
      });
    }
  });
});

module.exports = NotifyApprover;
