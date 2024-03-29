const User = require("../models/users");
const Technical = require("../models/technicalMessage");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const { Sequelize, where } = require("sequelize");
const { Op, fn } = require("sequelize");

const user = Technical.belongsTo(User, {
  foreignKey: "send_techincal_userName",
  onDelete: "CASCADE",
  as: "send_user",
});
User.hasMany(Technical, { foreignKey: "send_techincal_userName" });

function generateRandomNumber() {
  const min = 10000; // Smallest 5-digit number
  const max = 99999; // Largest 5-digit number
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

exports.postAddManager = (req, res, next) => {
  const { userName, Fname, Lname, email, phoneNumber } = req.body;
  const userType = "manager";
  const error = validationResult(req);

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  User.create({
    Fname: Fname,
    Lname: Lname,
    userName: userName,
    password: "E" + generateRandomNumber() + "f",
    email: email,
    phoneNumber: phoneNumber,
    userType: userType,
    url: ".jpg",
  })
    .then((result) => {
      res.status(201).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
      console.log(err);
    });
};

exports.GetManagersList = (req, res) => {
  User.findAll({ where: { userType: "manager" } })
    .then((result) => {
      const managersList = result.map((manager) => ({
        username: manager.userName,
        img: "/image/" + manager.userName + manager.url,
        name: manager.Fname + " " + manager.Lname,
        phoneNumber: manager.phoneNumber,
        email: manager.email,
        createdAt: manager.createdAt.toISOString().split("T")[0],
      }));

      res.status(200).json(managersList);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.DeleteManager = async (req, res) => {
  const { userName } = req.params;
  await User.destroy({ where: { userType: "manager", userName: userName } });
  return res.status(200).json({ message: "Success" });
};

exports.getUserTechnicalReports = (req, res, next) => {
  const userName = req.query.userName;
  Technical.findAll({
    where: { send_techincal_userName: userName },
  })
    .then((result) => {
      if (result.length != 0) return res.status(200).json({ result });
      return res.status(404).json({ message: "There are no reports sent" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.getTechnicalReports = async (req, res, next) => {
  const Reports = await Technical.findAll({
    include: [{ model: User, as: "send_user" }],
  });
  const technicalReports = await Promise.all(
    Reports.map(async (report) => ({
      id: report.id,
      username: report.send_techincal_userName,
      img: "/image/" + report.send_techincal_userName + report.send_user.url,
      name: report.send_user.Fname + " " + report.send_user.Lname,
      title: report.Title,
      seen: report.seen,
      reply:report.reply,
      userType: report.send_user.userType,
      isReplied: report.reply==null?false:true,
      createdAt: report.createdAt,
    }))
  );
  return res.status(200).json(technicalReports);
};

exports.getTechnicalReportById = async (req, res, next) => {
  const id = req.query.id;

  await Technical.update({ seen: true }, { where: { id: id, seen: false } });

  const report = await Technical.findOne({
    include: [{ model: User, as: "send_user" }],
    where: { id: id },
  });

  if (!report) {
    return res.status(404).json({ error: 'Technical report not found' });
  }

  const technicalReports = {
    id: report.id,
    username: report.send_techincal_userName,
    img: "/image/" + report.send_techincal_userName + report.send_user.url,
    name: report.send_user.Fname + " " + report.send_user.Lname,
    title: report.Title,
    reply:report.reply,
    message: report.message,
    createdAt: report.createdAt,
    imageUrl: report.imageUrl,
  };

  return res.status(200).json(technicalReports);
};

exports.postSendReplyTechnicalReport = async (req, res, next) => {
    const {id, reply} = req.body;
  
    await Technical.update({ reply: reply }, { where: { id: id } });
  
    return res.status(200).json({ message: "Success" });
  };

  exports.DeleteTechnicalReport = async (req, res) => {
    const { id } = req.params;
    await Technical.destroy({ where: { id: id } });
    return res.status(200).json({ message: "Success" });
  };