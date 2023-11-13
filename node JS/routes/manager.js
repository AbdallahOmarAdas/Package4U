const express=require('express');
const multer = require('multer');
const managerController=require('../controller/managerController')
const signupValidators=require('../validators/signup')
const router=express.Router();
const path = require('path');

const User=require('../models/users');
const { body } = require('express-validator');
const { where } = require('sequelize');

const managerAuth = (req, res, next) => {
    console.log('This is manager Auth middleware');
    const managerUserName=req.body.managerUserName;
    const managerPassword=req.body.managerPassword;
    User.findOne({where:{userName:managerUserName,password:managerPassword,userType:"manager"}})
    .then((result) => {
        if(result){
            next();
        }
        else {
            res.status(403).json({message:'failed',message2:'This operation is allowed only for manager'}); 
        }
    })
    .catch(err=>console.log(err));
    
  };
router.use(managerAuth);
router.post('/addDriver',
                        body('Fname').notEmpty().withMessage('please enter First name'),
                        body('Lname').notEmpty().withMessage('please enter Last name'),
                        signupValidators.emailIsExist(),
                        signupValidators.phoneValidation(),
                        signupValidators.UserNameIsUsed(),
                        body('fromCity').notEmpty().withMessage('please enter from city'),
                        body('toCity').notEmpty().withMessage('please enter To city'),
                        body('vehicleNumber').notEmpty().withMessage('please enter the vehicle number'),
                        body('workingDays').notEmpty().withMessage('please enter working Days'),
                        managerController.postAddDriver);

router.post('/addEmployee',
                        body('Fname').notEmpty().withMessage('please enter First name'),
                        body('Lname').notEmpty().withMessage('please enter Last name'),
                        signupValidators.emailIsExist(),
                        signupValidators.phoneValidation(),
                        signupValidators.UserNameIsUsed(),
                        managerController.postAddEmployee);

                        
module.exports=router;