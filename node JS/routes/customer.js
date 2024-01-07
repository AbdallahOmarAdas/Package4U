const express = require("express");
const multer = require("multer");
const customerController = require("../controller/customerController");
const signupValidators = require("../validators/signup");
const router = express.Router();
const path = require("path");
const User = require("../models/users");
const { body } = require("express-validator");
const { where } = require("sequelize");

const managerAuth = (req, res, next) => {
  console.log("This is customer Auth middleware");
  const customerUserName = req.body.customerUserName;
  const customerPassword = req.body.customerPassword;
  User.findOne({
    where: {
      userName: customerUserName,
      password: customerPassword,
      userType: "customer",
    },
  })
    .then((result) => {
      if (result) {
        next();
      } else {
        res.status(403).json({
          message: "failed",
          message2: "This operation is allowed only for customer",
        });
      }
    })
    .catch((err) => console.log(err));
};
router.post(managerAuth);

// router.post('/sendPackageEmail',
//                         body('recName').notEmpty().withMessage('please enter recipient name'),
//                         body('recEmail').notEmpty().withMessage('Please enter recipient email').isEmail().withMessage('Please enter vaild email'),
//                         signupValidators.phoneValidation(),
//                         body('packagePrice').notEmpty().withMessage('please enter package Price'),
//                         body('shippingType').notEmpty().withMessage('please enter shipping Type'),
//                         body('whoWillPay').notEmpty().withMessage('please enter the who Will Pay'),
//                         body('distance').notEmpty().withMessage('please enter distance'),
//                         body('latTo').notEmpty().withMessage('please enter latto'),
//                         body('longTo').notEmpty().withMessage('please enter langto'),
//                         body('latFrom').notEmpty().withMessage('please enter latfrom'),
//                         body('longFrom').notEmpty().withMessage('please enter langfrom'),
//                         body('locationFromInfo').notEmpty().withMessage('please enter location From Info'),
//                         body('locationToInfo').notEmpty().withMessage('please enter location To Info'),
//                         customerController.sendPackageEmail);
router.post(
  "/sendPackageUser",
  //body('rec_userName').notEmpty().withMessage('please enter recipient rec_userName'),
  body("recName").notEmpty().withMessage("please enter recipient name"),
  body("recEmail")
    .notEmpty()
    .withMessage("Please enter recipient email")
    .isEmail()
    .withMessage("Please enter vaild email"),
  signupValidators.phoneValidation(),
  body("packagePrice").notEmpty().withMessage("please enter package Price"),
  body("shippingType").notEmpty().withMessage("please enter shipping Type"),
  body("whoWillPay").notEmpty().withMessage("please enter the who Will Pay"),
  body("distance").notEmpty().withMessage("please enter distance"),
  body("latTo").notEmpty().withMessage("please enter latto"),
  body("longTo").notEmpty().withMessage("please enter langto"),
  body("latFrom").notEmpty().withMessage("please enter latfrom"),
  body("longFrom").notEmpty().withMessage("please enter langfrom"),
  body("locationFromInfo")
    .notEmpty()
    .withMessage("please enter location From Info"),
  body("locationToInfo")
    .notEmpty()
    .withMessage("please enter location To Info"),
  customerController.sendPackageUser
);

router.post(
  "/deletePackage",
  body("packageId").notEmpty().withMessage("please enter packageId"),
  body("locationToInfo")
    .notEmpty()
    .withMessage("please enter location To Info"),
  body("latTo").notEmpty().withMessage("please enter latto"),
  body("longTo").notEmpty().withMessage("please enter langto"),
  customerController.postDeletePackage
);

router.post(
  "/editPackageLocationTo",
  body("packageId").notEmpty().withMessage("please enter packageId"),
  customerController.postEditPackageLocation
);

router.post(
  "/editPackageUser",
  //body('rec_userName').notEmpty().withMessage('please enter recipient rec_userName'),
  body("recName").notEmpty().withMessage("please enter recipient name"),
  body("recEmail")
    .notEmpty()
    .withMessage("Please enter recipient email")
    .isEmail()
    .withMessage("Please enter vaild email"),
  signupValidators.phoneValidation(),
  body("packagePrice").notEmpty().withMessage("please enter package Price"),
  body("shippingType").notEmpty().withMessage("please enter shipping Type"),
  body("whoWillPay").notEmpty().withMessage("please enter the who Will Pay"),
  body("distance").notEmpty().withMessage("please enter distance"),
  body("latTo").notEmpty().withMessage("please enter latto"),
  body("longTo").notEmpty().withMessage("please enter langto"),
  body("latFrom").notEmpty().withMessage("please enter latfrom"),
  body("longFrom").notEmpty().withMessage("please enter langfrom"),
  body("locationFromInfo")
    .notEmpty()
    .withMessage("please enter location From Info"),
  body("locationToInfo")
    .notEmpty()
    .withMessage("please enter location To Info"),
  customerController.editPackageUser
);

// router.post('/editPackageEmail',
//             body('recName').notEmpty().withMessage('please enter recipient name'),
//             body('recEmail').notEmpty().withMessage('Please enter recipient email').isEmail().withMessage('Please enter vaild email'),
//             signupValidators.phoneValidation(),
//             body('packagePrice').notEmpty().withMessage('please enter package Price'),
//             body('shippingType').notEmpty().withMessage('please enter shipping Type'),
//             body('whoWillPay').notEmpty().withMessage('please enter the who Will Pay'),
//             body('distance').notEmpty().withMessage('please enter distance'),
//             body('latTo').notEmpty().withMessage('please enter latto'),
//             body('longTo').notEmpty().withMessage('please enter langto'),
//             body('latFrom').notEmpty().withMessage('please enter latfrom'),
//             body('longFrom').notEmpty().withMessage('please enter langfrom'),
//             body('locationFromInfo').notEmpty().withMessage('please enter location From Info'),
//             body('locationToInfo').notEmpty().withMessage('please enter location To Info'),
//             customerController.editPackageEmail);
router.post(
  "/addNewLocation",
  body("locationName").notEmpty().withMessage("please enter locationName"),
  body("locationInfo").notEmpty().withMessage("please enter locationInfo"),
  body("latTo").notEmpty().withMessage("please enter latTo"),
  body("longTo").notEmpty().withMessage("please enter longTo"),
  customerController.postAddNewLocation
);

router.post(
  "/deleteLocation",
  body("id").notEmpty().withMessage("please enter id"),
  customerController.postDeleteLocation
);

router.post("/getTechnicalReports", customerController.getTechnicalReports);

router.get("/getPendingPackages", customerController.PendingPackages);
router.get("/getNotPendingPackages", customerController.notPendingPackages);
router.get("/getPendingPackagesToMe", customerController.PendingPackagesToMe);
router.get(
  "/getNotPendingPackagesToMe",
  customerController.notPendingPackagesToMe
);
router.get("/packageState", customerController.getPackageState);
router.get("/getMyLocations", customerController.getMyLocations);
router.get("/getMyNotifications", customerController.GetMyNotifications);
router.get("/getNotificationCount", customerController.getNotificationCount);
module.exports = router;
