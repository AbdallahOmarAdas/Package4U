const User=require('../models/users');
const Driver=require('../models/driver');
const { validationResult } = require('express-validator');
const fs = require('fs');
const path = require('path');
const user = Driver.belongsTo(User, { as: 'user' ,constraints:true,onDelete:'CASCADE'});
//Driver.belongsTo(User,{constraints:true,onDelete:'CASCADE'});
User.hasOne(Driver);
function generateRandomNumber() {
    const min = 10000; // Smallest 5-digit number
    const max = 99999; // Largest 5-digit number
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

exports.postAddDriver=(req,res,next)=>{
    const userName=req.body.userName;
    const password=req.body.password;
    const Fname=req.body.Fname;
    const Lname=req.body.Lname;
    const email=req.body.email;
    const phoneNumber=req.body.phoneNumber;
    const userType=req.body.userType;
    const vehicleNumber=req.body.vehicleNumber;
    const toCity=req.body.toCity;
    const fromCity=req.body.fromCity;
    const workingDays=req.body.workingDays;
    const error=validationResult(req);
    console.log(error);
    if(!error.isEmpty()){
       return res.status(422).json({message:'failed',error}); 
    }
    Driver.create({
        user:{
        Fname:Fname,
        Lname:Lname,
        userName:userName,
        password:"D"+generateRandomNumber()+"f",
        email:email,
        phoneNumber:phoneNumber,
        userType:userType,
        "url":".jpg"
        },fromCity:fromCity,
         toCity:toCity,
        workingDays:workingDays,
        vehicleNumber:vehicleNumber
    },{
        include:   [user]
    }).then((result) => { 
    
        res.status(201).json({message:'done'}); 
        
    }).catch((err) => {
        res.status(500).json({message:'failed'}); 
        console.log(err);
    });
     };