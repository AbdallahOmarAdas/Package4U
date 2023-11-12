const express=require('express');
const multer = require('multer');
const driverControler=require('../controller/driverControler')
const signupValidators=require('../validators/signup')
const router=express.Router();
const path = require('path');

const User=require('../models/users');
const { body } = require('express-validator');
const { where } = require('sequelize');

router.post('/addDriver',body('Fname').notEmpty().withMessage('please enter First name'),body('Lname').notEmpty().withMessage('please enter Last name'),signupValidators.emailIsExist(),signupValidators.phoneValidation(),signupValidators.UserNameIsUsed(),body('fromCity').notEmpty().withMessage('please enter from city'),body('toCity').notEmpty().withMessage('please enter To city'),body('vehicleNumber').notEmpty().withMessage('please enter the vehicle number'),body('workingDays').notEmpty().withMessage('please enter working Days'),driverControler.postAddDriver);

module.exports=router;