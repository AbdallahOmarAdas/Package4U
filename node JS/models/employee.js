const Sequelize=require('sequelize');
const sequelize=require('../util/database');

const Employee=sequelize.define('employee',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    }
});
module.exports=Employee;