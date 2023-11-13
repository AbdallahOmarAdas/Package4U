const Sequelize=require('sequelize');
const sequelize=require('../util/database');

const Customer=sequelize.define('customer',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
    extraAdreesDescription:{
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
    }
});
module.exports=Customer;