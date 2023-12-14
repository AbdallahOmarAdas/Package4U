const Sequelize=require('sequelize');
const sequelize=require('../util/database');

const Locations=sequelize.define('locations',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
    name:{
        type:Sequelize.STRING,
        allowNull:false
    },
    location:{
        type:Sequelize.STRING,
        allowNull:false
    },
    latTo:{
        type:Sequelize.DOUBLE,
        allowNull:false
    },
    longTo:{
        type:Sequelize.DOUBLE,
        allowNull:false
    }
});
module.exports=Locations;