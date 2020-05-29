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
  if (ID === "Major Medical Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Major medical Result
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
  if (ID === "NEA Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>NEA 
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
  if (ID === "Attestation Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Attestation 
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
  if (ID === "Travel Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Travel  
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
  if (ID === "Training Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Training  
     at Job Majuu has been <b>DECLINED</b>
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
  if (ID === "Ticketing Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Ticketing booking  
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
  if (ID === "Final Medical Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Final Medical 
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
  if (ID === "Visa Declined") {
    const output = `<p>Attention <b>${req.body.Name}</b>.<br></b>Visa Processing 
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
  }  if (ID === "Passport Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Passport processing has been approval.Thank you       
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
  if (ID === "Final Medical Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Final medical has been approval.Thank         
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
  if (ID === "NEA Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your NEA  has been approval.Thank         
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
  if (ID === "Attestation Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Attestation  has been approval.Thank         
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
  if (ID === "Visa Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your visa Processing  has been approval.Thank         
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
  if (ID === "Ticket Processing Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Ticket Processing  has been approval.Thank         
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
  if (ID === "Travel Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Travel has been approval.Thank         
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
  if (ID === "Major Medical Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your major medical has been approval....         
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
  if (ID === "Training Approval") {
    const output = `<p>Dear <b>${req.body.Name}</b>.<br></br>
    Your Training at job majuu has been approval....         
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
