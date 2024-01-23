const User = require("../models/users");
const Driver = require("../models/driver");
const Employee = require("../models/employee");
const fs = require("fs");
const { validationResult } = require("express-validator");
const DailyReport = require("../models/dailyReport");
const { Op, fn } = require("sequelize");
const sequelize = require("../util/database");
const { Sequelize, where } = require("sequelize");

const user = Driver.belongsTo(User, {
  as: "user",
  constraints: true,
  onDelete: "CASCADE",
});
//Driver.belongsTo(User,{constraints:true,onDelete:'CASCADE'});
User.hasOne(Driver);

User.hasOne(Employee);
const userE = Employee.belongsTo(User, { onDelete: "CASCADE" });

function generateRandomNumber() {
  const min = 10000; // Smallest 5-digit number
  const max = 99999; // Largest 5-digit number
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

exports.postAddDriver = (req, res, next) => {
  const userName = req.body.userName;
  const Fname = req.body.Fname;
  const Lname = req.body.Lname;
  const email = req.body.email;
  const phoneNumber = req.body.phoneNumber;
  const userType = "driver";
  const vehicleNumber = req.body.vehicleNumber;
  const toCity = req.body.toCity;
  const workingDays = req.body.workingDays;
  const error = validationResult(req);
  console.log(error);
  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  Driver.create(
    {
      user: {
        Fname: Fname,
        Lname: Lname,
        userName: userName,
        password: "D" + generateRandomNumber() + "f",
        email: email,
        phoneNumber: phoneNumber,
        userType: userType,
        url: ".jpg",
      },
      fromCity: "Nablus",
      toCity: toCity,
      workingDays: workingDays,
      vehicleNumber: vehicleNumber,
      totalBalance: 0,
      deliverdNumber: 0,
      receivedNumber: 0,
    },
    {
      include: [user],
    }
  )
    .then((result) => {
      res.status(201).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
      console.log(err);
    });
};

exports.postAddEmployee = (req, res, next) => {
  const userName = req.body.userName;
  const Fname = req.body.Fname;
  const Lname = req.body.Lname;
  const email = req.body.email;
  const phoneNumber = req.body.phoneNumber;
  const userType = "employee";
  const error = validationResult(req);

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  Employee.create(
    {
      user: {
        Fname: Fname,
        Lname: Lname,
        userName: userName,
        password: "E" + generateRandomNumber() + "f",
        email: email,
        phoneNumber: phoneNumber,
        userType: userType,
        url: ".jpg",
      },
    },
    {
      include: [userE],
    }
  )
    .then((result) => {
      res.status(201).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
      console.log(err);
    });
};

exports.postEditCompanyInfo = (req, res, next) => {
  const phone2 = req.body.phone2;
  const phone1 = req.body.phone1;
  const email = req.body.email;
  const facebook = req.body.facebook;
  const openDay = req.body.openDay;
  const openTime = req.body.openTime;
  const closeDay = req.body.closeDay;
  const companyHead = req.body.companyHead;
  const companyManager = req.body.companyManager;
  const aboutCompany = req.body.aboutCompany;
  const error = validationResult(req);

  if (!error.isEmpty()) {
    console.log(error);
    return res.status(422).json({ message: "failed", error });
  }
  const dataToWrite = {
    phone1: phone1,
    phone2: phone2,
    email: email,
    facebook: facebook,
    openDay: openDay,
    openTime: openTime,
    closeDay: closeDay,
    companyHead: companyHead,
    companyManager: companyManager,
    aboutCompany: aboutCompany,
  };
  const updatedJsonString = JSON.stringify(dataToWrite, null, 2);
  fs.writeFile("./json/company.json", updatedJsonString, "utf8", (err) => {
    if (err) {
      console.error("Error writing to the file:", err);
      res.status(500).json({ message: "failed2" });
      return;
    }
    return res.status(200).json({ message: "done" });
  });
};

exports.postEditDeliveryCosts = (req, res, next) => {
  const openingPrice = req.body.openingPrice;
  const bigPackagePrice = req.body.bigPackagePrice;
  const pricePerKm = req.body.pricePerKm;
  const discount = req.body.discount;
  const error = validationResult(req);

  if (!error.isEmpty()) {
    console.log(error);
    return res.status(422).json({ message: "failed", error });
  }
  const dataToWrite = {
    openingPrice: openingPrice,
    bigPackagePrice: bigPackagePrice,
    pricePerKm: pricePerKm,
    discount: discount,
  };
  const updatedJsonString = JSON.stringify(dataToWrite, null, 2);
  fs.writeFile("./json/cost.json", updatedJsonString, "utf8", (err) => {
    if (err) {
      console.error("Error writing to the file:", err);
      res.status(500).json({ message: "failed2" });
      return;
    }
    return res.status(200).json({ message: "done" });
  });
};

exports.GetTodayWork = async (req, res, next) => {
  const currentDate = new Date();
  const todayDate = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1)
    .toString()
    .padStart(2, "0")}-${currentDate.getDate().toString().padStart(2, "0")}`;

  const todayReports = await DailyReport.findOne({
    where: {
      date: todayDate,
    },
    attributes: [
      "packageDeliveredNum",
      "packageReceivedNumber",
      "DriversWorkingToday",
      "totalBalance",
      "comment",
      "date",
    ],
  });
  const oldestDay = await DailyReport.min("date");
  res.json({ todayReports, oldestDay });
};

exports.GetThisMonthDaysWork = async (req, res, next) => {
  try {
    const firstDayOfMonth = new Date(
      new Date().getFullYear(),
      new Date().getMonth(),
      1
    )
      .toISOString()
      .split("T")[0];
    const lastDayOfMonth = new Date(
      new Date().getFullYear(),
      new Date().getMonth() + 1,
      0
    )
      .toISOString()
      .split("T")[0];

    const thisMonthDaysWork = await DailyReport.findAll({
      where: {
        date: {
          [Op.between]: [firstDayOfMonth, lastDayOfMonth],
        },
      },
      attributes: [
        "packageDeliveredNum",
        "packageReceivedNumber",
        "DriversWorkingToday",
        "totalBalance",
        "comment",
        "date",
      ],
    });

    res.json(thisMonthDaysWork);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.GetMonthlySummary = async (req, res, next) => {
  try {
    const monthlySummary = await DailyReport.findAll({
      attributes: [
        [
          sequelize.fn("DATE_FORMAT", sequelize.col("date"), "%m-%Y"),
          "monthYear",
        ],

        [
          sequelize.fn("SUM", sequelize.col("packageDeliveredNum")),
          "sumPackageDeliveredNum",
        ],
        [
          sequelize.fn("SUM", sequelize.col("packageReceivedNumber")),
          "sumPackageReceivedNumber",
        ],
        [sequelize.fn("SUM", sequelize.col("totalBalance")), "sumTotalBalance"],
        [
          sequelize.fn("AVG", sequelize.col("DriversWorkingToday")),
          "avgDriversWorkingToday",
        ],
      ],
      group: [sequelize.literal('DATE_FORMAT(date, "%m-%Y")')],
    });

    res.json(monthlySummary);
  } catch (err) {
    console.error("Error fetching monthly summary:", err);
    res.status(500).send("Internal Server Error");
  }
};

exports.GetYearlySummary = async (req, res, next) => {
  try {
    const yearlySummary = await DailyReport.findAll({
      attributes: [
        [sequelize.fn('YEAR', sequelize.col('date')), 'year'],
        [sequelize.fn('SUM', sequelize.col('packageDeliveredNum')), 'sumPackageDeliveredNum'],
        [sequelize.fn('SUM', sequelize.col('packageReceivedNumber')), 'sumPackageReceivedNumber'],
        [sequelize.fn('SUM', sequelize.col('totalBalance')), 'sumTotalBalance'],
        [sequelize.fn('AVG', sequelize.col('DriversWorkingToday')), 'avgDriversWorkingToday'],
      ],
      group: [sequelize.fn('YEAR', sequelize.col('date'))],
    });

    res.json(yearlySummary);
  } catch (err) {
    console.error('Error fetching yearly summary:', err);
    res.status(500).send('Internal Server Error');
  }
};

exports.GetDateRangeSummary = async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;

    const dateRangeSummary = await DailyReport.findAll({
      attributes: [
        [sequelize.fn('SUM', sequelize.col('packageDeliveredNum')), 'sumPackageDeliveredNum'],
        [sequelize.fn('SUM', sequelize.col('packageReceivedNumber')), 'sumPackageReceivedNumber'],
        [sequelize.fn('SUM', sequelize.col('totalBalance')), 'sumTotalBalance'],
        [sequelize.fn('AVG', sequelize.col('DriversWorkingToday')), 'avgDriversWorkingToday'],
      ],
      where: {
        date: {
          [Sequelize.Op.between]: [startDate, endDate],
        },
      },
    });

    res.json(dateRangeSummary);
  } catch (err) {
    console.error('Error fetching date range summary:', err);
    res.status(500).send('Internal Server Error');
  }
}