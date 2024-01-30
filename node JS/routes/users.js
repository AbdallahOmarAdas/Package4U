const express=require('express');
const multer = require('multer');
const usersController=require('../controller/usersController')
const signupValidators=require('../validators/signup')
const router=express.Router();
const path = require('path');
const cost=require('../json/cost');
const cities=require('../json/cities');
const company=require('../json/company');
const User=require('../models/users');
const { body } = require('express-validator');
const { where } = require('sequelize');
const { Sequelize, DataTypes } = require('sequelize');

router.post('/signin',usersController.postSignin);
router.post('/addUser',body('Fname').notEmpty().withMessage('please enter First name'),body('Lname').notEmpty().withMessage('please enter Last name'),signupValidators.emailIsExist(),signupValidators.phoneValidation(),signupValidators.UserNameIsUsed(),body('city').notEmpty().withMessage('please enter your city'),body('town').notEmpty().withMessage('please enter your town'),body('street').notEmpty().withMessage('please enter your street'),signupValidators.passwordValidation(),usersController.postAddUser);
router.post('/forgot',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),usersController.postForgot);
router.post('/forgotCode',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),body('code').notEmpty().withMessage('Please the code').isLength({ min: 5, max: 5 }).withMessage('code must be exactly 5 digits long'),usersController.postForgotCode);
router.post('/forgotSetPass',body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),signupValidators.passwordValidation(),usersController.postForgotSetPass);
router.post('/changePassword',body('oldPassword').notEmpty().withMessage('please enter the old password first'),signupValidators.passwordValidation(),usersController.postChangePassword);
router.post('/editProfile',body('oldUserName').notEmpty().withMessage('please enter the old username'),body('userName').notEmpty().withMessage('please enter the new username'),body('Fname').notEmpty().withMessage('please enter First name'),body('Lname').notEmpty().withMessage('please enter Last name'),body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email'),body('oldEmail').notEmpty().withMessage('Please enter your old email').isEmail().withMessage('Please enter vaild email'),signupValidators.phoneValidation(),body('city').notEmpty().withMessage('please enter your city'),body('town').notEmpty().withMessage('please enter your town'),body('street').notEmpty().withMessage('please enter your street'),usersController.postEditProfile)

router.get('/costs',(req,res,next)=>{
  res.status(200).json(cost)
});

router.get('/getCities',(req,res,next)=>{
  res.status(200).json(cities)
});

router.get('/isAvailableUserName',(req,res)=>{
  const userName=req.query.userName;
  User.findOne({where:{userName:userName}}).then((result) => {
    if(result){
      return res.status(409).json({message:"conflict"})
    }
    return res.status(200).json({"message":"ok"})
  });
});

router.get('/isAvailableEmail',(req,res)=>{
  const email=req.query.email;
  User.findOne({where:{email:email}}).then((result) => {
    if(result){
      return res.status(409).json({message:"conflict"})
    }
    return res.status(200).json({"message":"ok"})
  });
});

router.get('/info',(req,res,next)=>{
  res.status(200).json(company)
});
router.get('/showCustomers',(req,res,next)=>{
  const userName=req.query.userName;
  User.findAll(
    {attributes:['userName','Fname','Lname','phoneNumber','email'],
    where:{userName:{[Sequelize.Op.not]: userName},
            userType:"customer"        
  }})
    .then((result) => {
        res.status(200).json({cost:cost,users:result})
    })
    .catch((err) => {
        console.log(err);
    });
});

function generateRandomNumber() {
  const min = 10000; // Smallest 5-digit number
  const max = 99999; // Largest 5-digit number
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

let urlImage;
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './user_images/'); // Define the folder where uploaded images will be stored
    },
    filename: function (req, file, cb) {
        const imageUserName=req.body.userName;
        urlImage=path.extname(file.originalname)+"#"+generateRandomNumber();
        User.update({"url":urlImage},{where:{userName:imageUserName}})
        .then((result) => {
            console.log("image uplodaded "+imageUserName+path.extname(file.originalname));
        }).catch((err) => {
            console.log(err);
        });
      cb(null, imageUserName+ path.extname(file.originalname));
    },
  });
  
  const upload = multer({ storage });
  
  router.post('/imm', upload.single('image'), (req, res) => {
    if (!req.file) {
      return res.status(400).send('No files were uploaded.');
    }
    // Handle the uploaded file (e.g., save it, process it, etc.)
    res.status(200).json({"message":"File uploaded successfully.","url":urlImage});
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