const User=require('../models/users');
const Driver=require('../models/driver');
const Employee=require('../models/employee');
const fs=require('fs')
const { validationResult } = require('express-validator');
const user = Driver.belongsTo(User, { as: 'user' ,constraints:true,onDelete:'CASCADE'});
//Driver.belongsTo(User,{constraints:true,onDelete:'CASCADE'});
User.hasOne(Driver);

User.hasOne(Employee);
const userE = Employee.belongsTo(User, { onDelete:'CASCADE'});


function generateRandomNumber() {
    const min = 10000; // Smallest 5-digit number
    const max = 99999; // Largest 5-digit number
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

exports.postAddDriver=(req,res,next)=>{
    const userName=req.body.userName;
    const Fname=req.body.Fname;
    const Lname=req.body.Lname;
    const email=req.body.email;
    const phoneNumber=req.body.phoneNumber;
    const userType="driver";
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
        vehicleNumber:vehicleNumber,
        totalBalance:0,
        deliverdNumber:0,
        receivedNumber:0
    },{
        include:   [user]
    }).then((result) => { 
    
        res.status(201).json({message:'done'}); 
        
    }).catch((err) => {
        res.status(500).json({message:'failed'}); 
        console.log(err);
    });
     };

exports.postAddEmployee=(req,res,next)=>{
    const userName=req.body.userName;
    const Fname=req.body.Fname;
    const Lname=req.body.Lname;
    const email=req.body.email;
    const phoneNumber=req.body.phoneNumber;
    const userType="employee";
    const error=validationResult(req);

    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
    }
    Employee.create({
        user:{
        Fname:Fname,
        Lname:Lname,
        userName:userName,
        password:"E"+generateRandomNumber()+"f",
        email:email,
        phoneNumber:phoneNumber,
        userType:userType,
        "url":".jpg"
        }
    },{
        include:   [userE]
    }).then((result) => { 
    
        res.status(201).json({message:'done'}); 
        
    }).catch((err) => {
        res.status(500).json({message:'failed'}); 
        console.log(err);
    });
};

exports.postEditCompanyInfo=(req,res,next)=>{
    const phone2=req.body.phone2;
    const phone1=req.body.phone1;
    const email=req.body.email;
    const facebook=req.body.facebook;
    const openDay=req.body.openDay;
    const openTime=req.body.openTime;
    const closeDay=req.body.closeDay;
    const companyHead=req.body.companyHead;
    const companyManager=req.body.companyManager;
    const aboutCompany=req.body.aboutCompany;
    const error=validationResult(req);

    if(!error.isEmpty()){
        console.log(error)
        return res.status(422).json({message:'failed',error}); 
    }
    const dataToWrite = {
        "phone1": phone1,
        "phone2": phone2,
        "email": email,
        "facebook": facebook,
        "openDay": openDay,
        "openTime": openTime,
        "closeDay": closeDay,
        "companyHead": companyHead,
        "companyManager": companyManager,
        "aboutCompany": aboutCompany
      };
    const updatedJsonString = JSON.stringify(dataToWrite, null, 2);
    fs.writeFile('./json/company.json', updatedJsonString, 'utf8', (err) => {
        if (err) {
          console.error('Error writing to the file:', err);
          res.status(500).json({message:'failed2'}); 
          return;
        }
        return res.status(200).json({message:'done'}); 
      });
}

exports.postEditDeliveryCosts=(req,res,next)=>{
    const openingPrice=req.body.openingPrice;
    const bigPackagePrice=req.body.bigPackagePrice;
    const pricePerKm=req.body.pricePerKm;
    const discount=req.body.discount;
    const error=validationResult(req);

    if(!error.isEmpty()){
        console.log(error)
        return res.status(422).json({message:'failed',error}); 
    }
    const dataToWrite = {
        "openingPrice":openingPrice,
        "bigPackagePrice":bigPackagePrice,
        "pricePerKm":pricePerKm,
        "discount":discount
      };
    const updatedJsonString = JSON.stringify(dataToWrite, null, 2);
    fs.writeFile('./json/cost.json', updatedJsonString, 'utf8', (err) => {
        if (err) {
          console.error('Error writing to the file:', err);
          res.status(500).json({message:'failed2'}); 
          return;
        }
        return res.status(200).json({message:'done'}); 
      });
}