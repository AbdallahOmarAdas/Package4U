const Sequelize=require('sequelize');
const sequelize=require('../util/database');

const Technical=sequelize.define('technical',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
    Title:{
        type:Sequelize.STRING,
        allowNull:false
    },
    message:{
        type:Sequelize.STRING,
        allowNull:false
    },
    imageUrl:{
        type:Sequelize.STRING,
        allowNull:true
    },
    userName:{
        type:Sequelize.STRING,
        allowNull:false
    }
});
module.exports=Technical;