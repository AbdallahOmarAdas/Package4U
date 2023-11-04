const User=require('../models/users');
const { validationResult } = require('express-validator');
const nodemailer=require('nodemailer');
exports.postAddUser=(req,res,next)=>{
const userName=req.body.userName;
const password=req.body.password;
const Fname=req.body.Fname;
const Lname=req.body.Lname;
const email=req.body.email;
const phoneNumber=req.body.phoneNumber;
const userType=req.body.userType;
const city=req.body.city;
const town=req.body.town;
const street=req.body.street;
const error=validationResult(req);
console.log(error);
if(!error.isEmpty()){
    console.log('$$$$$$$$$$$$$$$$$$$$$$$$$')
   return res.status(422).json({message:'failed',error}); 
}
console.log(userName);
console.log(password);
console.log(Fname);
console.log(Lname);
console.log(email);
console.log(userType);
console.log(phoneNumber);
console.log(city);
console.log(town);
console.log(street);
User.create({
    Fname:Fname,
    Lname:Lname,
    userName:userName,
    password:password,
    email:email,
    phoneNumber:phoneNumber,
    userType:userType
}).then((result) => { 

    res.status(201).json({message:'done'}); 
    
}).catch((err) => {
    res.status(500).json({message:'failed'}); 
    console.log(err);
});
 };
 exports.postSignin=(req,res,next)=>{
    const userName=req.body.userName;
    const password=req.body.password;
    // const trans=nodemailer.createTransport({
    //     service:"Gmail",
    //     auth:{
    //         user:'abood.adas.2001@gmail.com',
    //         pass:'layoiychrtedcpvx'
    //     }
    // });
    // const info= trans.sendMail({
    //     from:'sdfsdsdf <abood@openjavascript.info>',
    //     to:'omaradas1234@gmail.com',
    //     subject:'sdfgsdfg',
    //     messageId:888,
    //     text:"drtfgvwwdfgerrgerrgerrgewrrg"
    // })
    // console.log("message send"+info.messageId);
        User.findOne({where:{userName:userName,password:password}}).then((result) => {
            if(result)res.status(200).json({"result":"found","user":result});
            else res.status(200).json({"result":"user not found"});
        
        }).catch((err) => {
        console.log(err);
    });
 }