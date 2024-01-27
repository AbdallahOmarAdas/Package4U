const User = require("../models/users");
const Driver = require("../models/driver");
const Employee = require("../models/employee");
const fs = require("fs");
const { validationResult } = require("express-validator");
const DailyReport = require("../models/dailyReport");
const { Op, fn } = require("sequelize");
const sequelize = require("../util/database");
const { Sequelize, where } = require("sequelize");
const Package = require("../models/package");
const PackagePrice = require("../models/packagePrice");

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
  const totalPaiedPaclagePrices = await GetTotalPaiedPackagePrices(
    todayReports.date
  );
  const totalRecivedPaclagePrices = await GetTotalRecivedPackagePrices(
    todayReports.date
  );
  res.json({
    todayReports,
    oldestDay,
    totalPaiedPaclagePrices,
    totalRecivedPaclagePrices,
  });
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

    const totalPaidPromises = thisMonthDaysWork.map(async (report) => {
      const totalPaiedPaclagePrices = await GetTotalPaiedPackagePrices(
        report.date
      );
      const totalRecivedPaclagePrices = await GetTotalRecivedPackagePrices(
        report.date
      );
      return {
        ...report.toJSON(),
        totalPaiedPaclagePrices,
        totalRecivedPaclagePrices,
      };
    });

    const modifiedThisMonthDaysWork = await Promise.all(totalPaidPromises);
    res.json({ thisMonthDaysWork: modifiedThisMonthDaysWork });
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
        [sequelize.fn("YEAR", sequelize.col("date")), "year"],
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
      group: [sequelize.fn("YEAR", sequelize.col("date"))],
    });

    res.json(yearlySummary);
  } catch (err) {
    console.error("Error fetching yearly summary:", err);
    res.status(500).send("Internal Server Error");
  }
};

exports.GetDateRangeSummary = async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;

    const dateRangeSummary = await DailyReport.findAll({
      attributes: [
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
      where: {
        date: {
          [Sequelize.Op.between]: [startDate, endDate],
        },
      },
    });
    const intervalTotalPaiedPackagePrices =
      await GetIntervalTotalPaiedPackagePrices(startDate, endDate);
    const intervalTotalRecivedPackagePrices =
      await GetIntervalTotalRecivedPackagePrices(startDate, endDate);
    res.json({
      dateRangeSummary,
      intervalTotalPaiedPackagePrices,
      intervalTotalRecivedPackagePrices,
    });
  } catch (err) {
    console.error("Error fetching date range summary:", err);
    res.status(500).send("Internal Server Error");
  }
};

exports.GetDriverDetailsList = async (req, res) => {
  try {
    const drivers = await Driver.findAll({
      include: [{ model: User, as: "user" }],
    });
    const driverList = await Promise.all(
      drivers.map(async (driver) => ({
        username: driver.userUserName,
        img: "/image/" + driver.userUserName + driver.user.url,
        name: driver.user.Fname + " " + driver.user.Lname,
        phoneNumber: driver.user.phoneNumber,
        working_days: driver.workingDays,
        city: driver.toCity,
        vehicleNumber: driver.vehicleNumber,
        notAvailableDate: driver.notAvailableDate,
        isAllowToDelete:
          (await isAllowedToDeleteDriver(driver.userUserName)) == 0 ? 1 : 0,
      }))
    );

    res.status(200).json(driverList);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.GetEmployeesDetailsList = (req, res) => {
  User.findAll({ where: { userType: "employee" } })
    .then((result) => {
      const employeeList = result.map((employee) => ({
        username: employee.userName,
        img: "/image/" + employee.userName + employee.url,
        name: employee.Fname + " " + employee.Lname,
        phoneNumber: employee.phoneNumber,
        email: employee.email,
      }));

      res.status(200).json(employeeList);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.DeleteEmployee = async (req, res) => {
  const { userName } = req.params;

  const employeesCount = await User.count({
    where: { userType: "employee" },
  }).then((count) => {
    return count;
  });

  if (employeesCount > 1) {
    User.destroy({ where: { userType: "employee", userName: userName } });
    return res.status(200).json({ message: "Success" });
  }
  return res
    .status(400)
    .json({ message: "There must be at least one employee in the system." });
};

exports.DeleteDriver = async (req, res) => {
  const { userName } = req.params;

  const isAllowToDelete = await isAllowedToDeleteDriver(userName);

  if (isAllowToDelete == 0) {
    await Driver.destroy({ where: { userUserName: userName } });
    await User.destroy({ where: { userType: "driver", userName: userName } });
    return res.status(200).json({ message: "Success" });
  }
  return res.status(400).json({ message: "error in delete the driver" });
};

const isAllowedToDeleteDriver = async (driverUserName) => {
  const isAllowedToDeleteDriver = await Package.count({
    where: {
      driver_userName: { [Op.eq]: driverUserName },
    },
  });
  return isAllowedToDeleteDriver;
};

const GetTotalPaiedPackagePrices = async (date) => {
  const GetTotalPaiedPackagePrices = await PackagePrice.sum("paidAmount", {
    where: {
      [Op.and]: [
        sequelize.literal(`DATE(receiveDate) = '${date}'`), // Compare only the date part
      ],
    },
  });
  return GetTotalPaiedPackagePrices == null ? 0 : GetTotalPaiedPackagePrices;
};

const GetTotalRecivedPackagePrices = async (date) => {
  const GetTotalRecivedPackagePrices = await PackagePrice.sum("receiveAmount", {
    where: {
      [Op.and]: [
        sequelize.literal(`DATE(deliverDate) = '${date}'`), // Compare only the date part
      ],
    },
  });
  return GetTotalRecivedPackagePrices == null
    ? 0
    : GetTotalRecivedPackagePrices;
};

const GetIntervalTotalRecivedPackagePrices = async (startDate, endDate) => {
  const GetIntervalTotalRecivedPackagePrices = await PackagePrice.sum(
    "receiveAmount",
    {
      where: {
        [Op.and]: [
          sequelize.literal(
            `DATE(deliverDate) BETWEEN '${startDate}' AND '${endDate}'`
          ),
        ],
      },
    }
  );
  return GetIntervalTotalRecivedPackagePrices == null
    ? 0
    : GetIntervalTotalRecivedPackagePrices;
};

const GetIntervalTotalPaiedPackagePrices = async (startDate, endDate) => {
  const GetIntervalTotalPaiedPackagePrices = await PackagePrice.sum(
    "paidAmount",
    {
      where: {
        [Op.and]: [
          sequelize.literal(
            `DATE(receiveDate) BETWEEN '${startDate}' AND '${endDate}'`
          ),
        ],
      },
    }
  );
  return GetIntervalTotalPaiedPackagePrices == null
    ? 0
    : GetIntervalTotalPaiedPackagePrices;
};

exports.GetmanagerPackagePrices = async (req, res) => {
  const GetTotalPaiedPackagePricesBalance = await PackagePrice.sum(
    "paidAmount",
    {
      where: {
        deliverDriver_userName: {
          [Op.eq]: null,
        },
      },
    }
  );
  const GetPackagesMustPayForCompany = await PackagePrice.findAll({
    where: {
      deliverDriver_userName: {
        [Op.eq]: null,
      },
      paidAmount: {
        [Op.ne]: 0,
      },
    },
    attributes: [
      "pkt_packageId",
      "receiveDate",
      "reciveDriver_userName",
      "paidAmount",
    ],
        include: [
      {
        model: User,
        as: "reciveDriver",
        attributes: ["Fname", "Lname"],
      }]
  });
  res.json({
    TotalPaiedPackagePrices: GetTotalPaiedPackagePricesBalance,
    GetPackagesMustPayForCompany,
  });
};
