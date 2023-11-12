const express=require('express');
const feedRoutes=require('./routes/feeds');
const usersRoutes=require('./routes/users');
const driverRoutes=require('./routes/driver');
const bodyParser=require('body-parser');
const sequelize=require('./util/database');
const User=require('./models/users');//importent to creat the table
const Token=require('./models/token');
const Driver=require('./models/driver');
const path = require('path');
const Sequelize=require('sequelize');
const app=express();
//app.use(bodyParser.urlencoded());//used in html form x-www-form-urlencoded
app.use(bodyParser.json());
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

app.use('/feed',feedRoutes);
app.use('/users',usersRoutes);
app.use('/driver',driverRoutes);
app.use('/image',express.static(path.join(__dirname,'user_images')));
app.use('/image',(req,res,next)=>{
    res.status(200).sendFile(path.join(__dirname,'user_images','__@@__33&default.jpg'));
});

sequelize
    .sync({force:false})
    .then(result=>{
        //console.log(result);
        app.listen(8080);
    })
    .catch(err=>{
        console.log(err);
    });
