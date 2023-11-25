const User=require('../models/users');
const Token=require('../models/token');
const Customer=require('../models/customer');
const { validationResult } = require('express-validator');
const nodemailer=require('nodemailer');
const fs = require('fs');
const path = require('path');


const user = Customer.belongsTo(User, { as: 'user' ,constraints:true,onDelete:'CASCADE'});
User.hasOne(Customer);


exports.postAddUser=(req,res,next)=>{

    const userName=req.body.userName;
    const password=req.body.password;
    const Fname=req.body.Fname;
    const Lname=req.body.Lname;
    const email=req.body.email;
    const phoneNumber=req.body.phoneNumber;
    const city=req.body.city;
    const town=req.body.town;
    const street=req.body.street;
    const error=validationResult(req);

    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
    }
    Customer.create({
        user:{
            Fname:Fname,
            Lname:Lname,
            userName:userName,
            password:password,
            email:email,
            phoneNumber:phoneNumber,
            userType:"customer",
            city:city,
            town:town,
            street:street,
            "url":".jpg"
        }
        },
        {
            include:   [user]
        })
        .then((result) => { 
            res.status(201).json({message:'done'}); 
        })
        .catch((err) => {
            res.status(500).json({message:'failed'}); 
            console.log(err);
        });
 };


 exports.postSignin=(req,res,next)=>{
    const userName=req.body.userName;
    const password=req.body.password;
        User.findOne({where:{userName:userName,password:password}})
        .then((result) => {
            if(result)
                res.status(200).json({"result":"found","user":result});
            else
                res.status(200).json({"result":"user not found"});
        
        }).catch((err) => {
        console.log(err);
    });
 }


 function generateRandomNumber() {
    const min = 10000; // Smallest 5-digit number
    const max = 99999; // Largest 5-digit number
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }


 exports.postForgot=(req,res,next)=>{
    const email=req.body.email;
    const error=validationResult(req);
    if(!error.isEmpty()){
    return res.status(422).json({message:'failed',error}); 
    }
    else{
    User.findOne({where:{email:email}})
    .then((result) => {
        if(result){
            const recipientName=result.Fname;

            Token.findOne({where:{email:email}})
            .then(result=>{
                const token=generateRandomNumber();
                const emailTemplate = (recipientName, token) => {
                    return `
                      <html>
                        <body>
                          <p>Hello ${recipientName},</p>
                          <p>We received a request to reset your password for Package4U account. To proceed, please use the following verification code:</p>
                          <p>Verification Code: <strong>${token}</strong></p>
                          <p>If you didn't request a password reset, please ignore this email. Your account security is important to us.</p>
                          <p>Thank you for using Package4U App!</p>
                        </body>
                      </html>
                    `;
                  };
                  
                const trans=nodemailer.createTransport({
                    service:"Gmail",
                    auth:{
                        user:'abood.adas.2001@gmail.com',
                        pass:'layoiychrtedcpvx'
                    }
                });
                const info= trans.sendMail({
                    from:'Package4U <support@Package4U.ps>',
                    to:email,
                    subject:'Password Reset Verification Code for Package4U account',
                    html:emailTemplate(recipientName, token)
                })
                console.log("email send");
                if(result){
                    Token.update(
                        { token:token },
                        {
                          where: { email: email }, // The condition to find the user you want to update
                        }
                      ).then((result) => {
                        res.status(200).json({"message":"done"});
                      }).catch((err) => {
                        console.log(err);
                      });
                }
                else{
                    Token.create({
                        email:email,
                        token:token
                    }).then((result) => {
                        res.status(200).json({"message":"done"});
                    }).catch((err) => {
                        console.log(err);
                    });
                }
            })
            .catch(err=>{
                console.log(err);
            })
            
        }
        else{
            res.status(200).json({"message":"email not found"});
        }
    })
    .catch(
        err=>{console.log(err)}
        )
    }
 }

 exports.postForgotCode=(req,res,next)=>{
    const email=req.body.email;
    const code=req.body.code;
    const error=validationResult(req);
    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
        }
        else{
        Token.findOne({where:{email:email}})
        .then((result) => {
            if(result){
                if(result.token==code){
                    Token.destroy({where:{email:email}})
                        .then((result) => {
                        res.status(200).json({"message":"done"});
                    }).catch((err) => {
                        console.log(err);
                    });
                    
                }
                else res.status(200).json({"message":"We're sorry, but the verification code you entered is incorrect."});
            }
            else{
                 res.status(200).json({"message":"failed no requiest a code"});
            }
        }).catch((err) => {
            console.log(err);
        });
    }
}

exports.postForgotSetPass=(req,res,next)=>{
    const email=req.body.email;
    const password=req.body.password;
    const error=validationResult(req);
    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
        }
        else{
            User.update(
                { password:password },
                {
                  where: { email: email }, // The condition to find the user you want to update
                }
              ).then((result) => {
                res.status(200).json({"message":"done"});
              }).catch((err) => {
                console.log(err);
              });
        }
 }



 exports.postEditProfile=(req,res,next)=>{
    const userName=req.body.userName;
    const oldUserName=req.body.oldUserName;
    const Fname=req.body.Fname;
    const Lname=req.body.Lname;
    const email=req.body.email;
    const oldEmail=req.body.oldEmail;
    const phoneNumber=req.body.phoneNumber;
    const city=req.body.city;
    const town=req.body.town;
    const street=req.body.street;
    const url=req.body.url;
    function updateEditProfile(){
        User.update(
            { 
                userName:userName,
                Fname:Fname,
                Lname:Lname,
                email:email,
                phoneNumber:phoneNumber,
                city:city,
                town:town,
                street:street
            },
            {
              where: { userName: oldUserName,}, // The condition to find the user you want to update
            }
          ).then((result) => {
            if(result[0]===1){
                const currentFileName = path.join(__dirname,'..','user_images','/')+oldUserName+url; // Replace with the actual current file name
                const newFileName = path.join(__dirname,'..','user_images','/')+userName+url; 
                fs.rename(currentFileName, newFileName, (err) => {
                    if (err) {
                      console.error(`Error renaming file: ${err}`);
                    } else {
                      console.log('File renamed successfully.');
                    }
                  });
                res.status(200).json({"message":"done"});
            }
            else
                res.status(200).json({"message":"please check the old username."});
          }).catch((err) => {
            console.log(err);
          });
     }
    const error=validationResult(req);
    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
        }
        else{
            if(userName===oldUserName)
                {
                    if(email===oldEmail)updateEditProfile();
                    else{
                        User.findOne({where:{email:email}})
                        .then((result) => {
                            if(result){
                                res.status(200).json({"message":"This email already used for another account."});
                            }
                            else{
                                updateEditProfile();
                            }    
                        }).catch((err) => {
                            console.log(err);
                        });
                    }
                }
            else{
                User.findOne({where:{userName:userName}})
                .then((result) => {
                    if(result){
                        res.status(200).json({"message":"This username is not available."});
                    }
                    else{
                        if(email===oldEmail)updateEditProfile();
                    else{
                        User.findOne({where:{email:email}})
                        .then((result) => {
                            if(result){
                                res.status(200).json({"message":"This email already used for another account."});
                            }
                            else{
                                updateEditProfile();
                            }    
                        }).catch((err) => {
                            console.log(err);
                        });
                    }
                    }    
                }).catch((err) => {
                    
                });
            }
        }
 }
 exports.postChangePassword=(req,res,next)=>{
    const userName=req.body.userName;
    const oldPassword=req.body.oldPassword;
    const password=req.body.password;
    const error=validationResult(req);
    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
        }
        else{
            if(oldPassword===password)res.status(200).json({"message":"please choose a different password."});
            else
            User.update(
                { password:password },
                {
                  where: { userName: userName,password:oldPassword }, // The condition to find the user you want to update
                }
              ).then((result) => {
                if(result[0]===1)
                    res.status(200).json({"message":"done"});
                else
                    res.status(200).json({"message":"The old password is incorrect, please verify it."});
              }).catch((err) => {
                console.log(err);
              });
        }
 }