const User = require("../models/users");
const Package = require("../models/package");
const Driver = require("../models/driver");
const Locations = require("../models/locations");
const Notification = require("../models/nofification");
const Technical = require("../models/technicalMessage");
const Customer = require("../models/customer");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const sequelize = require("../util/database");
const { Sequelize } = require("sequelize");
const notification = require("../util/notifications");
const { log } = require("console");

exports.newPackages = (req, res, next) => {
  console.log("Get newPackages");
  Package.findAll({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "userName", "url"],
      },
      {
        model: User,
        as: "send_user",
        attributes: ["Fname", "Lname", "userName", "url"],
      },
    ],
    where: { status: "Under review" },
  })
    .then((result) => {
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.PostAcceptPackage = (req, res, next) => {
  console.log("post AcceptPackage");
  const { packageId } = req.body;
  Package.update({ status: "Accepted" }, { where: { packageId } })
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.PostRejectPackage = (req, res, next) => {
  console.log("Post RejectPackage");
  const { packageId, comment } = req.body;
  Package.update(
    { status: "Rejected by employee", driverComment: comment },
    { where: { packageId } }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};
