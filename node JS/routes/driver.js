const express=require('express');
const multer = require('multer');
const driverController=require('../controller/driverController')
const signupValidators=require('../validators/signup')
const router=express.Router();
const path = require('path');
const User=require('../models/users');
const { body } = require('express-validator');
const { where } = require('sequelize');

const driverAuth = (req, res, next) => {
    console.log('This is driver Auth middleware');
    const driverUserName=req.body.driverUserName;
    const driverPassword=req.body.driverPassword;
    User.findOne({where:{userName:driverUserName,password:driverPassword,userType:"driver"}})
    .then((result) => {
        if(result){
            next();
        }
        else {
            res.status(403).json({message:'failed',message2:'This operation is allowed only for driver'}); 
        }
    })
    .catch(err=>console.log(err));
    
  };
  router.post(driverAuth);
router.post('/getDeliverdDriver',                                       
            driverController.getDeliverdDriver);
router.post('/getPreparePackageDriver',                                       
            driverController.getPreparePackageDriver);
router.post('/AcceptPreparePackageDriver',                                       
            driverController.postAcceptPreparePackageDriver);
router.post('/RejectPreparePackageDriver',                                       
            driverController.postRejectPreparePackageDriver);
router.post('/onGoingPackagesDriver',                                       
            driverController.postOnGoingPackagesDriver);
router.post('/cancelOnGoingPackageDriver',
            driverController.postCancelOnGoingPackageDriver);
router.post('/compleatePackageDriver',
            driverController.postCompleatePackageDriver);
router.post('/RejectWorkOnPackageDriver',
            driverController.postRejectWorkOnPackageDriver);
router.get('/summary',driverController.getSummary)
router.get('/driverListManager',driverController.GetDriverListManager)

module.exports=router;