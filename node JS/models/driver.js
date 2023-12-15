const Sequelize=require('sequelize');
const sequelize=require('../util/database');
const User=require('./users');

const Driver=sequelize.define('driver',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
    fromCity:{
        type:Sequelize.STRING,
        allowNull:false
    },
    toCity:{
        type:Sequelize.STRING,
        allowNull:false
    },
    vehicleNumber:{
        type:Sequelize.STRING,
        allowNull:true
    },
    workingDays:{
        type:Sequelize.STRING,
        allowNull:true
    },
    latitude:{
        type:Sequelize.DOUBLE,
        allowNull:true
    },
    longitude:{
        type:Sequelize.DOUBLE,
        allowNull:true
    },
    notAvailableDate:{
        type:Sequelize.DATE,
        allowNull:true
    },
    totalBalance:{
        type:Sequelize.DOUBLE,
        allowNull:true
    },
    deliverdNumber: {
        type: Sequelize.INTEGER,
        allowNull:true
      },
      receivedNumber: {
        type: Sequelize.INTEGER,
        allowNull:true
      },
});
module.exports=Driver;