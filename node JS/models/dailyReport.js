const Sequelize = require("sequelize");
const sequelize = require("../util/database");

const DailyReport = sequelize.define("dailyReport", {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  packageDeliveredNum: {
    type: Sequelize.INTEGER,
    allowNull: false,
  },
  packageReceivedNumber: {
    type: Sequelize.INTEGER,
    allowNull: false,
  },
  totalBalance: {
    type: Sequelize.DOUBLE,
    allowNull: true,
  },
  comment: {
    type: Sequelize.STRING,
    allowNull: true,
  },
  dateTime: {
    type: Sequelize.DATE,
    allowNull: true,
  },
});
module.exports = DailyReport;
