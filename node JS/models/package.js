const Sequelize=require('sequelize');
const sequelize=require('../util/database');

const Package=sequelize.define('package',{
    packageId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
    status:{
        type:Sequelize.STRING,
        allowNull:false
    },
    whoWillPay:{
        type:Sequelize.STRING,
        allowNull:false
    },
    shippingType:{
        type:Sequelize.STRING,
        allowNull:false
    },
    recName:{
        type:Sequelize.STRING,
        allowNull:false
    },
    recEmail:{
        type:Sequelize.STRING,
        allowNull:false
    },
    recPhone:{
        type:Sequelize.INTEGER,
        allowNull:false
    },
    locationFromInfo:{
        type:Sequelize.STRING,
        allowNull:false
    },
    locationToInfo:{
        type:Sequelize.STRING,
        allowNull:false
    },
    distance:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    latTo:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    longTo:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    latFrom:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    longFrom:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    driverComment:{
        type:Sequelize.STRING,
        allowNull:true
    },
    receiveDate:{
        type:Sequelize.DATE,
        allowNull:true
    },
    deliverDate:{
        type:Sequelize.DATE,
        allowNull:true
    },
    packagePrice:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    total:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
});
module.exports=Package;