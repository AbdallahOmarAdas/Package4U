const express=require('express');
const usersController=require('../controller/usersController')
const signupValidators=require('../validators/signup')
const router=express.Router();
const User=require('../models/users');
const { body } = require('express-validator');

router.post('/signin',usersController.postSignin);
router.post('/addUser',body('Fname').notEmpty().withMessage('please enter First name'),body('Lname').notEmpty().withMessage('please enter Last name'),signupValidators.emailIsExist(),signupValidators.phoneValidation(),signupValidators.UserNameIsUsed(),body('city').notEmpty().withMessage('please enter your city'),body('town').notEmpty().withMessage('please enter your town'),body('street').notEmpty().withMessage('please enter your street'),signupValidators.passwordValidation(),usersController.postAddUser);
router.post('/forgot',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),usersController.postForgot);
router.post('/forgotCode',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),body('code').notEmpty().withMessage('Please the code').isLength({ min: 5, max: 5 }).withMessage('code must be exactly 5 digits long'),usersController.postForgotCode);
router.post('/forgotSetPass',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),signupValidators.passwordValidation(),usersController.postForgotSetPass);
router.post('/changePassword',body('oldPassword').notEmpty().withMessage('please enter the old password first'),signupValidators.passwordValidation(),usersController.postChangePassword);

router.get('/showAll',(req,res,next)=>{
User.findAll().then((result) => {
    res.status(200).send(result)
}).catch((err) => {
    console.log(err);
});
});
router.get('/get/:userName',(req,res,next)=>{
    //const userName=req.query.userName;//localhost:8080/users/get?userName=abdallah.omar///'/get'
    const userName=req.params.userName;//localhost:8080/users/get/abdallah.omar///'/get/:userName'
    console.log(userName);
    User.findByPk(userName).then((result) => {
        res.status(200).json({resulta:result})
    }).catch((err) => {
        console.log(err);
    });
    // User.findOne({where:{userName:userName}}).then((result) => {
    //     res.status(200).json({resulta:result})
    // }).catch((err) => {
    //     console.log(err);
    // });
    // User.findAll({where:{userName:userName}}).then((result) => {
    //     res.status(200).json({resulta:result})
    // }).catch((err) => {
    //     console.log(err);
    // });
     });
router.use('/', (req,res)=>res.status(404).json({msg:"page not found"}))
module.exports=router;