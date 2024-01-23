const express = require("express");
const multer = require("multer");
const managerController = require("../controller/managerController");
const signupValidators = require("../validators/signup");
const router = express.Router();
const path = require("path");

const User = require("../models/users");
const { body } = require("express-validator");
const { where } = require("sequelize");

const managerAuth = (req, res, next) => {
  console.log("This is manager Auth middleware");
  const managerUserName = req.body.managerUserName;
  const managerPassword = req.body.managerPassword;
  User.findOne({
    where: {
      userName: managerUserName,
      password: managerPassword,
      userType: "manager",
    },
  })
    .then((result) => {
      if (result) {
        next();
      } else {
        res
          .status(403)
          .json({
            message: "failed",
            message2: "This operation is allowed only for manager",
          });
      }
    })
    .catch((err) => console.log(err));
};
router.post(managerAuth);
router.post(
  "/addDriver",
  body("Fname").notEmpty().withMessage("please enter First name"),
  body("Lname").notEmpty().withMessage("please enter Last name"),
  signupValidators.emailIsExist(),
  signupValidators.phoneValidation(),
  signupValidators.UserNameIsUsed(),
  body("toCity").notEmpty().withMessage("please enter To city"),
  body("vehicleNumber")
    .notEmpty()
    .withMessage("please enter the vehicle number"),
  body("workingDays").notEmpty().withMessage("please enter working Days"),
  managerController.postAddDriver
);

router.post(
  "/addEmployee",
  body("Fname").notEmpty().withMessage("please enter First name"),
  body("Lname").notEmpty().withMessage("please enter Last name"),
  signupValidators.emailIsExist(),
  signupValidators.phoneValidation(),
  signupValidators.UserNameIsUsed(),
  managerController.postAddEmployee
);

router.post(
  "/editCompanyInfo",
  body("phone1").notEmpty().withMessage("please enter phone1"),
  body("phone2").notEmpty().withMessage("please enter phone2"),
  body("email").notEmpty().withMessage("please enter email"),
  body("facebook").notEmpty().withMessage("please enter facebook"),
  body("openDay").notEmpty().withMessage("please enter openDay"),
  body("openTime").notEmpty().withMessage("please enter openTime"),
  body("closeDay").notEmpty().withMessage("please enter closeDay"),
  body("companyManager").notEmpty().withMessage("please enter companyManager"),
  body("companyHead").notEmpty().withMessage("please enter companyHead"),
  body("aboutCompany").notEmpty().withMessage("please enter aboutCompany"),
  managerController.postEditCompanyInfo
);

router.post(
  "/editDeliveryCosts",
  body("openingPrice").notEmpty().withMessage("please enter openingPrice"),
  body("bigPackagePrice")
    .notEmpty()
    .withMessage("please enter bigPackagePrice"),
  body("pricePerKm").notEmpty().withMessage("please enter pricePerKm"),
  body("discount").notEmpty().withMessage("please enter discount"),
  managerController.postEditDeliveryCosts
);

router.get('/todayWork',managerController.GetTodayWork)
router.get('/thisMonthDaysWork',managerController.GetThisMonthDaysWork)
router.get('/monthlySummary',managerController.GetMonthlySummary)
router.get('/yearlySummary',managerController.GetYearlySummary)
router.get('/dateRangeSummary',managerController.GetDateRangeSummary)
router.get('/driversDetailsList',managerController.GetDriverDetailsList)
router.get('/employeesDetailsList',managerController.GetEmployeesDetailsList)
router.delete('/deleteEmployee/:userName',managerController.DeleteEmployee)
module.exports = router;
