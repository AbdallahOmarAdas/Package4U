const express=require('express');
const multer = require('multer');
const customerController=require('../controller/customerController')
const signupValidators=require('../validators/signup')
const router=express.Router();
const path = require('path');

const User=require('../models/users');
const { body } = require('express-validator');
const { where } = require('sequelize');

const managerAuth = (req, res, next) => {
    console.log('This is customer Auth middleware');
    const customerUserName=req.body.customerUserName;
    const customerPassword=req.body.customerPassword;
    User.findOne({where:{userName:customerUserName,password:customerPassword,userType:"customer"}})
    .then((result) => {
        if(result){
            next();
        }
        else {
            res.status(403).json({message:'failed',message2:'This operation is allowed only for customer'}); 
        }
    })
    .catch(err=>console.log(err));
    
  };
router.use(managerAuth);

router.post('/sendPackageEmail',
                        body('recName').notEmpty().withMessage('please enter recipient name'),
                        body('recEmail').notEmpty().withMessage('Please enter recipient email').isEmail().withMessage('Please enter vaild email'),
                        signupValidators.phoneValidation(),
                        body('packagePrice').notEmpty().withMessage('please enter package Price'),
                        body('shippingType').notEmpty().withMessage('please enter shipping Type'),
                        body('whoWillPay').notEmpty().withMessage('please enter the who Will Pay'),
                        body('distance').notEmpty().withMessage('please enter distance'),
                        body('latTo').notEmpty().withMessage('please enter latto'),
                        body('longTo').notEmpty().withMessage('please enter langto'),
                        body('latFrom').notEmpty().withMessage('please enter latfrom'),
                        body('longFrom').notEmpty().withMessage('please enter langfrom'),
                        body('locationFromInfo').notEmpty().withMessage('please enter location From Info'),
                        body('locationToInfo').notEmpty().withMessage('please enter location To Info'),
                        customerController.sendPackageEmail);
router.post('/sendPackageUser',
                        body('rec_userName').notEmpty().withMessage('please enter recipient rec_userName'),
                        body('recName').notEmpty().withMessage('please enter recipient name'),
                        body('recEmail').notEmpty().withMessage('Please enter recipient email').isEmail().withMessage('Please enter vaild email'),
                        signupValidators.phoneValidation(),
                        body('packagePrice').notEmpty().withMessage('please enter package Price'),
                        body('shippingType').notEmpty().withMessage('please enter shipping Type'),
                        body('whoWillPay').notEmpty().withMessage('please enter the who Will Pay'),
                        body('distance').notEmpty().withMessage('please enter distance'),
                        body('latTo').notEmpty().withMessage('please enter latto'),
                        body('longTo').notEmpty().withMessage('please enter langto'),
                        body('latFrom').notEmpty().withMessage('please enter latfrom'),
                        body('longFrom').notEmpty().withMessage('please enter langfrom'),
                        body('locationFromInfo').notEmpty().withMessage('please enter location From Info'),
                        body('locationToInfo').notEmpty().withMessage('please enter location To Info'),
                        customerController.sendPackageUser);
                        
module.exports=router;