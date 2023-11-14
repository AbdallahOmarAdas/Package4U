const Sequelize=require('sequelize');
const Driver=require('./driver')
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
    },
    city:{
        type:Sequelize.STRING,
        allowNull:true
    },
    town:{
        type:Sequelize.STRING,
        allowNull:true
    },
    street:{
        type:Sequelize.STRING,
        allowNull:true
    },
    url:{
        type:Sequelize.STRING,
        allowNull:true
    
    }
});
// Driver.associate=models=>{
//     User.hasOne(models.Driver,{
//         foreignKey:{
//             onDelete:"cascade"
//         }
//     });
// }
module.exports=User;