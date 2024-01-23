const express = require("express");
const multer = require("multer");
const employeeController = require("../controller/employeeController");
const signupValidators = require("../validators/signup");
const router = express.Router();
const path = require("path");
const User = require("../models/users");
const { body } = require("express-validator");
const { where } = require("sequelize");

const employeeAuth = (req, res, next) => {
  console.log("This is customer Auth middleware");
  const employeeUserName = req.body.employeeUserName;
  const employeePassword = req.body.employeePassword;
  User.findOne({
    where: {
      userName: employeeUserName,
      password: employeePassword,
      userType: "employee",
    },
  })
    .then((result) => {
      if (result) {
        next();
      } else {
        res.status(403).json({
          message: "failed",
          message2: "This operation is allowed only for employee",
        });
      }
    })
    .catch((err) => console.log(err));
};
router.post(employeeAuth);

router.get("/getNewOrders", employeeController.newPackages);
router.post("/acceptPackage", employeeController.PostAcceptPackage);
router.post("/rejectPackage", employeeController.PostRejectPackage);
router.get("/GetDriverListEmployee", employeeController.GetDriverListEmployee);
router.post(
  "/editDriverWorkingDays",
  employeeController.PostEditDriverWorkingDays
);
router.post("/addVacationDriver", employeeController.postAddVacationDriver);
router.post(
  "/editDriverWorkingCity",
  employeeController.postEditDriverWorkingCity
);
router.post(
  "/editDriverVehicleNumber",
  employeeController.postEditDriverVehicleNumber
);
router.get("/getDistributionOrders", employeeController.getDistributionOrders);
router.get("/getDriversBalance", employeeController.GetDriversBalance);
router.post(
  "/receiveDriverBalance",
  employeeController.postReceiveDriverBalance
);
router.post("/editPackage", employeeController.PostEditPackage);
router.post("/createOrder", employeeController.sendPackage);
router.post("/AssignPackageToDriver", employeeController.PostAssignPackageToDriver);
router.get("/getAssignPackageToDriver",employeeController.getAssignPackageToDriver);
router.get("/getAllPackages",employeeController.getAllPackages);
router.post("/DeletePackage", employeeController.DeletePackage);
module.exports = router;
