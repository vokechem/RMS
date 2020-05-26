var express = require("express");
var FinalMedicalApproval
 = express();
var mysql = require("mysql");
var config = require("../../DB");
var Joi = require("joi");
var con = mysql.createPool(config);
var auth = require("../../auth");
FinalMedicalApproval
.get(
  "/:ID",
  auth.validateRole("Final Medical"),
  function(req, res) {
    const ID = req.params.ID;
    con.getConnection(function(err, connection) {
      if (err) {
        res.json({
          success: false,
          message: err.message
        });
      } // not connected!
      else {
        let sp = "call getFinalPendingApprovals(?)";
        connection.query(sp, [ID], function(error, results, fields) {
          if (error) {
            res.json({
              success: false,
              message: error.message
            });
          } else {
            res.json(results[0]);
          }
          connection.release();
          // Don't use the connection here, it has been returned to the pool.
        });
      }
    });
  }
);
FinalMedicalApproval
.put(
  "/",
  auth.validateRole("Final Medical"),
  function(req, res) {
    const schema = Joi.object().keys({
      Approver: Joi.string()
        .min(1)
        .required(),
      Number: Joi.number()
        .min(1)
        .required(),
      Remarks: Joi.string()
        .min(1)
        .required()
    });
    const result = Joi.validate(req.body, schema);
    if (!result.error) {
      let data = [req.body.Approver, req.body.Number, req.body.Remarks];
      con.getConnection(function(err, connection) {
        if (err) {
          res.json({
            success: false,
            message: err.message
          });
        } // not connected!
        else {
          let sp = "call DeclineFinal(?,?,?)";
          connection.query(sp, data, function(error, results, fields) {
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
            }
            connection.release();
          });
        }
      });
    } else {
      res.json({
        success: false,
        message: result.error.details[0].message
      });
    }
  }
);
FinalMedicalApproval
.post(
  "/",
  auth.validateRole("Final Medical"),
  function(req, res) {
    const schema = Joi.object().keys({
      Approver: Joi.string()
        .min(1)
        .required(),
      Number: Joi.number()
        .min(1)
        .required(),
      Remarks: Joi.string()
        .min(1)
        .required()
    });

    const result = Joi.validate(req.body, schema);
    if (!result.error) {
      let data = [req.body.Approver, req.body.Number, req.body.Remarks];
      con.getConnection(function(err, connection) {
        if (err) {
          res.json({
            success: false,
            message: err.message
          });
        } // not connected!
        else {
          let sp = "call ApproveFinalMedical(?,?,?)";
          connection.query(sp, data, function(error, results, fields) {
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
            }
            connection.release();
            // Don't use the connection here, it has been returned to the pool.
          });
        }
      });
    } else {
      res.json({
        success: false,
        message: result.error.details[0].message
      });
    }
  }
);

module.exports = FinalMedicalApproval
;
