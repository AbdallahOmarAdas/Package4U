const User=require('../models/users');
const Package=require('../models/package');
const Customer=require('../models/customer');
const { validationResult } = require('express-validator');
const nodemailer=require('nodemailer');
const fs = require('fs');
const path = require('path');

//User.hasOne(Package);
const user = Package.belongsTo(User, { foreignKey: 'rec_userName',onDelete:'CASCADE'});
User.hasMany(Package, { foreignKey: 'rec_userName' });
const user2 = Package.belongsTo(User, { foreignKey: 'send_userName',onDelete:'CASCADE'});
User.hasMany(Package, { foreignKey: 'send_userName' });
function calaulateTotalPrice(shippingType,distance) {
    var totalPrice;
        const jsonData =require('../json/cost');
        let boxSizePrice;
        if (shippingType == "Package0") {
            boxSizePrice = 0;
        } 
        else if (shippingType == "Package1") {
            boxSizePrice = jsonData.bigPackagePrice / 2;
        }
        else if (shippingType == "Package2"){
            boxSizePrice = jsonData.bigPackagePrice;
        }
        else {
        boxSizePrice = 0;
        }
        totalPrice=jsonData.openingPrice + boxSizePrice + (distance * jsonData.pricePerKm);
    return totalPrice;
  };
  
  exports.sendPackageEmail=(req,res,next)=>{
    const customerUserName=req.body.customerUserName;
    const recName=req.body.recName;
    const recEmail=req.body.recEmail;
    const phoneNumber=req.body.phoneNumber;
    const packagePrice=req.body.packagePrice;
    const shippingType=req.body.shippingType;
    const whoWillPay=req.body.whoWillPay;
    const distance=req.body.distance;
    const latTo=req.body.latTo;
    const longTo=req.body.longTo;
    const latFrom=req.body.latFrom;
    const longFrom=req.body.longFrom;
    const locationFromInfo=req.body.locationFromInfo;
    const locationToInfo=req.body.locationToInfo;
    const error=validationResult(req);
    let packageSize;
    if(shippingType=="Package2"){
        packageSize="Large size box";
    }
    else if(shippingType=="Package1"){
        packageSize="Meduim size box";
    }
    else if(shippingType=="Package0"){
        packageSize="Small size box";
    }
    else{
        packageSize="Document";
    }

    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
    }
    const total=calaulateTotalPrice(shippingType,distance);
    Package.create({
        send_userName:customerUserName,
        rec_userName:null,
        status:"Under review",
        whoWillPay:whoWillPay,
        shippingType:shippingType,
        recName:recName,
        recEmail:recEmail,
        recPhone:phoneNumber,
        locationFromInfo:locationFromInfo,
        locationToInfo:locationToInfo,
        distance:distance,
        latTo:latTo,
        longTo:longTo,
        latFrom:latFrom,
        longFrom:longFrom,
        whoWillPay:whoWillPay,
        packagePrice:packagePrice,
        total:total
    },{
        include:   [user,user2]
    }).then((result) => { 
        User.findOne({where:{username:customerUserName}})
        .then(result2=>{
            const emailTemplate = (recName) => {
                return `
                  <html>
                    <body>
                      <p>Hello ${recName},</p>
                      <p>${result2.Fname+" "+result2.Lname} has created a new package with number: ${result.packageId} for you, 
                      you can track the status of the package by downloading Package4U application and writing the attached package number.</p>
                      <p><strong>Package details:</strong></p>
                      <ol>
                        <li>The one who will pay to the driver is: ${result.whoWillPay}</li>
                        <li>The price of the package is: ${result.packagePrice}</li>
                        <li>Total delivery price is: ${result.total}</li>
                        <li>Package Type: ${packageSize}</li>
                        <li>Delivery place:${result.locationFromInfo}</li>
                      </ol>
                      <p>We will contact you when this package is ready for delivery, and we will also contact you if the package details are modified.</p>
                      <p>Thank you</p>
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
                to:recEmail,
                subject:"There's a package for you",
                html:emailTemplate(recName)
            })
            console.log("email send");
        })
        .catch(err=>console.log(err));
        res.status(201).json({message:'done'}); 
        
    }).catch((err) => {
        res.status(500).json({message:'failed'}); 
        console.log(err);
    });

}
exports.sendPackageUser=(req,res,next)=>{
    const customerUserName=req.body.customerUserName;
    const rec_userName=req.body.rec_userName;
    const recName=req.body.recName;
    const recEmail=req.body.recEmail;
    const phoneNumber=req.body.phoneNumber;
    const packagePrice=req.body.packagePrice;
    const shippingType=req.body.shippingType;
    const whoWillPay=req.body.whoWillPay;
    const distance=req.body.distance;
    const latTo=req.body.latTo;
    const longTo=req.body.longTo;
    const latFrom=req.body.latFrom;
    const longFrom=req.body.longFrom;
    const locationFromInfo=req.body.locationFromInfo;
    const locationToInfo=req.body.locationToInfo;
    const error=validationResult(req);

    if(!error.isEmpty()){
        return res.status(422).json({message:'failed',error}); 
    }
    const total=calaulateTotalPrice(shippingType,distance);
    Package.create({
        send_userName:customerUserName,
        rec_userName:rec_userName,
        status:"Under review",
        whoWillPay:whoWillPay,
        shippingType:shippingType,
        recName:recName,
        recEmail:recEmail,
        recPhone:phoneNumber,
        locationFromInfo:locationFromInfo,
        locationToInfo:locationToInfo,
        distance:distance,
        latTo:latTo,
        longTo:longTo,
        latFrom:latFrom,
        longFrom:longFrom,
        whoWillPay:whoWillPay,
        packagePrice:packagePrice,
        total:total
    },{
        include:   [user,user2]
    }).then((result) => { 
    
        res.status(201).json({message:'done'}); 
        
    }).catch((err) => {
        res.status(500).json({message:'failed'}); 
        console.log(err);
    });

}