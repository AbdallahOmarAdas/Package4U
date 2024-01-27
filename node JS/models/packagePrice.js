const Sequelize = require("sequelize");
const sequelize = require("../util/database");

const PackagePrice = sequelize.define("packagePrice", {
  rowNumber: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  paidAmount: {
    type: Sequelize.DOUBLE,
    allowNull: true,
    defaultValue: 0.0,
  },
  receiveAmount: {
    type: Sequelize.DOUBLE,
    allowNull: true,
    defaultValue: 0.0,
  },
  receiveDate: {
    type: Sequelize.DATE,
    allowNull: true,
  },
  deliverDate: {
    type: Sequelize.DATE,
    allowNull: true,
  },
});
module.exports = PackagePrice;
