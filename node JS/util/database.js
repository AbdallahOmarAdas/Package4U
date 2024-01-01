const Sequelize = require("sequelize");

const sequelize = new Sequelize("gp1", "root", "123456", {
  dialect: "mysql",
  host: "localhost",
  logging: false,
  timezone: "+02:00",
  dialectOptions: {
    // for reading
    timezone: "+02:00",
  }
});
module.exports = sequelize;
