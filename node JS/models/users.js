const Sequelize=require('sequelize');

const sequelize=require('../util/database');

const User=sequelize.define('users',{
    userName:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true
    },
    password:{
        type:Sequelize.STRING,
        allowNull:false
    },
    Fname:{
        type:Sequelize.STRING,
        allowNull:false
    },
    Lname:{
        type:Sequelize.STRING,
        allowNull:false
    },
    email:{
        type:Sequelize.STRING,
        allowNull:false
    },
    phoneNumber:{
        type:Sequelize.INTEGER,
        allowNull:false
    },
    userType:{
        type:Sequelize.STRING,
        allowNull:false
    }
});

module.exports=User;