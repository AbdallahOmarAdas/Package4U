const { body } = require('express-validator');
const User=require('../models/users');

exports.emailIsExist=function(){
return body('email').notEmpty().withMessage('Please enter your email').isEmail().withMessage('Please enter vaild email').custom((value,{req})=>{
    return User.findOne({where:{email:value}}).then((result) => {
        if(result)return Promise.reject('This email already used for another account');
    });
    
});

}

exports.UserNameIsUsed=function(){
    return body('userName').notEmpty().withMessage('Please enter your username').custom((value,{req})=>{
        return User.findOne({where:{userName:value}}).then((result) => {
            console.log(result);
            if(result){
                console.log("resul333333"+result+"b");
                return Promise.reject('This username is not available');}
        });
        
    });
    
    }
exports.passwordValidation=function(){
    return body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/\d/)
    .withMessage('Password must contain at least one number')
    .matches(/[A-Z]/)
    .withMessage('Password must contain at least one uppercase letter');
    }

exports.phoneValidation=function(){
    return body('phoneNumber')
    .isLength({ min: 10, max: 10 })
    .withMessage('Phone number must have exactly 10 digits')
    .isNumeric()
    .withMessage('Phone number must contain only numeric digits');
    }