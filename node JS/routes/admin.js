const express = require("express");
const adminController = require("../controller/adminController");
const router = express.Router();
const signupValidators = require("../validators/signup");
const { body } = require("express-validator");

router.post(
    "/addManager",
    body("Fname").notEmpty().withMessage("please enter First name"),
    body("Lname").notEmpty().withMessage("please enter Last name"),
    signupValidators.emailIsExist(),
    signupValidators.phoneValidation(),
    signupValidators.UserNameIsUsed(),
    adminController.postAddManager
  );
router.get('/managersList',adminController.GetManagersList)
router.delete('/deleteManager/:userName',adminController.DeleteManager)

module.exports = router;