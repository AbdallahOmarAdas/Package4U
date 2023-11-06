const Sequelize=require('sequelize');

const sequelize=require('../util/database');

const Token=sequelize.define('token',{
    email:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true
    },
    token:{
        type:Sequelize.INTEGER,
        allowNull:false
    }
});
module.exports=Token;