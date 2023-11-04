const Sequelize=require('sequelize');

const sequelize=new Sequelize('gp1','root','123456',{
    dialect:'mysql',
    host:'localhost'
});
module.exports=sequelize;