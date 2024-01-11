const Sequelize = require("sequelize");
const sequelize = require("../util/database");

const Notification = sequelize.define("notification", {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  title: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  body: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  note: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  status: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  dateTime: {
    type: Sequelize.DATE,
    allowNull: true,
  },
});
module.exports = Notification;
