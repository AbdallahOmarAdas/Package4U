const User = require("../models/users");
const Technical = require("../models/technicalMessage");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const { Sequelize, where } = require("sequelize");
const { Op, fn } = require("sequelize");

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
