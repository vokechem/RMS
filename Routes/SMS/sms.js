var express = require("express");
var sms = express();
var mysql = require("mysql");
var config = require("./../../DB");
var con = mysql.createPool(config);
const http = require("http");
function LogMessage(Recepient, SenderID, Message) {
  let data = [Recepient, SenderID, Message];
  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call Savesms(?,?,?)";
      connection.query(sp, data, function(error, results, fields) {
        if (error) {
        } else {
        }
        connection.release();
        // Don't use the connection here, it has been returned to the pool.
      });
    }
  });
}

sms.post("/", function(req, res) {
  try {
    con.getConnection(function(err, connection) {
      let sp = "call getSMSSenderDetails()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            message: error.message
          });
        } else {
          let mobileno = req.body.MobileNumber;
          let msg = req.body.Message;
          // let SenderID = results[0][0].SenderID;
          let Password = results[0][0].Key;
          let username = results[0][0].UserName;
          let SMSURL = results[0][0].URL;
          //url
          let url =
            SMSURL +
            "username=" +
            username +
            "&password=" +
            Password +
            "&to=" +
            mobileno +
            "&text=" +
            msg;
          http
            .get(url, resp => {
              let data = "";
              
              // A chunk of data has been recieved.
              resp.on("data", chunk => {
                data += chunk;
              });
              resp.on("end", () => {
                var obj = JSON.parse(data);
                console.log(url);
                if (obj[0]== "successful") {
                   LogMessage(mobileno, msg);
                  res.json({
                    success: true,
                    message: "successful"
                  });
                } else {
                  res.json({
                    success: true,
                    message: "successful"
                  });
                }
              });
            })
            .on("error", err => {
              console.log("Error: " + err.message);
              res.json({
                success: false,
                message: err.message
              });
            });
        }
        connection.release();
      });
    });
  } catch (e) {
    res.json({
      success: false,
      message: "Error occured while sending sms"
    });
  }
});

module.exports = sms;
