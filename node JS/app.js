const express=require('express');
const feedRoutes=require('./routes/feeds');
const usersRoutes=require('./routes/users');
const bodyParser=require('body-parser');
const sequelize=require('./util/database');
const User=require('./models/users');//importent to creat the table
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
sequelize
    .sync()
    .then(result=>{
        //console.log(result);
        app.listen(8080);
    })
    .catch(err=>{
        console.log(err);
    });
