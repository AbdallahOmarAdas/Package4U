const express = require("express");
const adminController = require("../controller/adminController");
const router = express.Router();
const signupValidators = require("../validators/signup");
const { body } = require("express-validator");
const multer = require("multer");
const path = require("path");
const Technical = require("../models/technicalMessage");

router.post(
  "/addManager",
  body("Fname").notEmpty().withMessage("please enter First name"),
  body("Lname").notEmpty().withMessage("please enter Last name"),
  signupValidators.emailIsExist(),
  signupValidators.phoneValidation(),
  signupValidators.UserNameIsUsed(),
  adminController.postAddManager
);
router.get("/managersList", adminController.GetManagersList);
router.delete("/deleteManager/:userName", adminController.DeleteManager);
router.get("/getUserTechnicalReports", adminController.getUserTechnicalReports);
router.get("/getTechnicalReports", adminController.getTechnicalReports);
router.get("/getTechnicalReport", adminController.getTechnicalReportById);
router.post(
  "/sendReplyTechnicalReport",
  adminController.postSendReplyTechnicalReport
);
router.delete(
  "/deleteTechnicalReport/:id",
  adminController.DeleteTechnicalReport
);
const generateRandomNumber = () => {
  const min = 100000; // Smallest 5-digit number
  const max = 999990; // Largest 5-digit number
  return Math.floor(Math.random() * (max - min + 1)) + min;
};
let urlImage;
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "./technicalReporesScreenshots/"); // Define the folder where uploaded images will be stored
  },
  filename: function (req, file, cb) {
    const { userName, title, message } = req.body;
    urlImage =
      userName + generateRandomNumber() + path.extname(file.originalname);
    Technical.create({
      imageUrl: "/technicalImage/" + urlImage,
      send_techincal_userName: userName,
      seen: false,
      message: message,
      Title: title,
    })
      .then((result) => {
        console.log(
          "image uplodaded " + result.id + path.extname(file.originalname)
        );
      })
      .catch((err) => {
        console.log(err);
      });
    cb(null, urlImage);
  },
});

const upload = multer({ storage });

router.post(
  "/sendTechnicalReportWithImage",
  upload.single("image"),
  (req, res) => {
    if (!req.file) {
      return res.status(400).send("No files were uploaded.");
    }
    res
      .status(200)
      .json({ message: "File uploaded successfully.", url: urlImage });
  }
);
router.post("/sendTechnicalReportWithoutImage", (req, res) => {
  const { userName, title, message } = req.body;
  Technical.create({
    imageUrl: null,
    send_techincal_userName: userName,
    seen: false,
    message: message,
    Title: title,
  })
    .then((result) => {
      res
        .status(200)
        .json({ message: "File uploaded successfully.", url: urlImage });
    })
    .catch((err) => {
      console.log(err);
    });
});
module.exports = router;
