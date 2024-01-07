const User = require("../models/users");
const Package = require("../models/package");
const Driver = require("../models/driver");
const DailyReport = require("../models/dailyReport");
const Locations = require("../models/locations");
const Notification = require("../models/nofification");
const Technical = require("../models/technicalMessage");
const Customer = require("./customerController");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const sequelize = require("../util/database");
const { Sequelize } = require("sequelize");
const notification = require("../util/notifications");
const { log } = require("console");
const { Op, fn } = require("sequelize");
const emailTemplate = (recName, result2, result, packageSize, pass) => {
  return `
  <html>
    <body>
      <p>Hello ${recName},</p>
      <p>${
        result2.Fname + " " + result2.Lname
      } has created a new package with number: ${result.packageId} for you, 
      you can track the status of the package by downloading Package4U application and writing the attached package number, and also you can edit delivery location.</p>
      <p>We create an account for you with username: ${
        result.rec_userName
      } and password: ${pass}, you can change your information and password once you sign in to your account.</p>
      <p><strong>Package details:</strong></p>
      <ol>
        <li>The one who will pay to the driver is: ${result.whoWillPay}</li>
        <li>The price of the package is: ${result.packagePrice}</li>
        <li>Total delivery price is: ${result.total.toFixed(2)}</li>
        <li>Package Type: ${packageSize}</li>
        <li>Delivery place:${result.locationFromInfo}</li>
      </ol>
      <p>We will contact you when this package is ready for delivery, and we will also contact you if the package details are modified.</p>
      <p>Thank you</p>
    </body>
  </html>
`;
};

const trans = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: "abood.adas.2001@gmail.com",
    pass: "layoiychrtedcpvx",
  },
});

const updateDilyCreatePackage = async (receivedNumber, deliverdNumber, totalBalance) => {
  console.log(new Date());
  await DailyReport.update(
    {
      packageReceivedNumber: sequelize.literal(
        `packageReceivedNumber + ${receivedNumber}`
      ),
      packageDeliveredNum: sequelize.literal(
        `packageDeliveredNum + ${deliverdNumber}`
      ),
      totalBalance: sequelize.literal(`totalBalance + ${totalBalance}`),
    },
    {
      where: {
        [Op.and]: [
          fn("DATE", fn("NOW")),
          sequelize.where(
            fn("DATE", sequelize.col("dateTime")),
            "=",
            fn("DATE", new Date())
          ),
        ],
      },
    }
  )
    .then((result) => {
      console.log("DailyReport done create new package");
    })
    .catch((err) => {
      console.log(err);
    });
  }

exports.newPackages = (req, res, next) => {
  console.log("Get newPackages");
  Package.findAll({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "userName", "url"],
      },
      {
        model: User,
        as: "send_user",
        attributes: ["Fname", "Lname", "userName", "url"],
      },
    ],
    where: { status: "Under review" },
  })
    .then((result) => {
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.PostAcceptPackage = (req, res, next) => {
  console.log("post AcceptPackage");
  const { packageId } = req.body;
  Package.update(
    { status: "Accepted", receiveDate: Sequelize.fn("NOW") },
    { where: { packageId } }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.PostRejectPackage = (req, res, next) => {
  console.log("Post RejectPackage");
  const { packageId, comment } = req.body;
  Package.update(
    {
      status: "Rejected by employee",
      receiveDate: Sequelize.fn("NOW"),
      driverComment: comment,
    },
    { where: { packageId } }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.GetDriverListEmployee = (req, res, next) => {
  Driver.findAll({ include: [{ model: User, as: "user" }] })
    .then((drivers) => {
      const driverList = drivers.map((driver) => ({
        username: driver.userUserName,
        img: "/image/" + driver.userUserName + driver.user.url,
        name: driver.user.Fname + " " + driver.user.Lname,
        working_days: driver.workingDays,
        city: driver.toCity,
        vehicleNumber: driver.vehicleNumber,
      }));

      res.status(200).json(driverList);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.PostEditDriverWorkingDays = (req, res, next) => {
  const { driverUsername, workingDays } = req.body;
  Driver.update(
    {
      workingDays: workingDays,
    },
    {
      where: {
        userUserName: driverUsername,
      },
    }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.postAddVacationDriver = (req, res, next) => {
  const { driverUsername, notAvailableDate } = req.body;
  Driver.update(
    {
      notAvailableDate: notAvailableDate,
    },
    {
      where: {
        userUserName: driverUsername,
      },
    }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.postEditDriverWorkingCity = (req, res, next) => {
  const { driverUsername, newCity } = req.body;
  Driver.update(
    {
      toCity: newCity,
    },
    {
      where: {
        userUserName: driverUsername,
      },
    }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.postEditDriverVehicleNumber = (req, res, next) => {
  const { driverUsername, vehicleNumber } = req.body;
  Driver.update(
    {
      vehicleNumber: vehicleNumber,
    },
    {
      where: {
        userUserName: driverUsername,
      },
    }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.getDistributionOrders = (req, res, next) => {
  console.log("Get DistributionOrders");
  Package.findAll({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "userName", "phoneNumber"],
      },
      {
        model: User,
        as: "send_user",
        attributes: ["Fname", "Lname", "userName", "phoneNumber"],
      },
      {
        model: User,
        as: "driver",
        attributes: ["Fname", "Lname", "userName", "phoneNumber"],
      },
    ],
    where: {
      driver_userName: {
        [Sequelize.Op.not]: null,
      },
      status: ["Accepted", "In Warehouse"],
    },
  })
    .then((results) => {
      const DistributionOrders = results.map((result) => ({
        packageId: result.packageId,
        packageType: result.status == "Accepted" ? "Recive" : "Deliver",
        customerName:
          result.status == "Accepted"
            ? result.send_user.Fname + " " + result.send_user.Lname
            : result.rec_user.Fname + " " + result.rec_user.Lname,
        phoneNumber:
          result.status == "Accepted"
            ? result.send_user.phoneNumber
            : result.rec_user.phoneNumber,
        driverName: result.driver.Fname + " " + result.driver.Lname,
        address: result.status == "Accepted" ? result.fromCity : result.toCity,
      }));
      res.status(200).json({ message: "done", result: DistributionOrders });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.GetDriversBalance = (req, res, next) => {
  console.log("Get DriversBalance");
  Driver.findAll({ include: [{ model: User, as: "user" }] })
    .then((drivers) => {
      const driverList = drivers.map((driver) => ({
        username: driver.userUserName,
        img: "/image/" + driver.userUserName + driver.user.url,
        name: driver.user.Fname + " " + driver.user.Lname,
        totalBalance: driver.totalBalance,
        deliverdNumber: driver.deliverdNumber,
        receivedNumber: driver.receivedNumber,
      }));

      res.status(200).json(driverList);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postReceiveDriverBalance = (req, res, next) => {
  console.log("post ReceiveDriverBalance");
  const { driverUsername, deliverdNumber, receivedNumber, totalBalance } =
    req.body;

  const currentDate = new Date();
  Driver.update(
    {
      totalBalance: 0,
      receivedNumber: 0,
      deliverdNumber: 0,
    },
    {
      where: { userUserName: driverUsername },
    }
  )
    .then((result) => {
      updatedaily();
    })
    .catch((err) => {
      console.log(err);
    });
  const updatedaily = async () => {
    await DailyReport.update(
      {
        packageReceivedNumber: sequelize.literal(
          `packageReceivedNumber + ${receivedNumber}`
        ),
        packageDeliveredNum: sequelize.literal(
          `packageDeliveredNum + ${deliverdNumber}`
        ),
        totalBalance: sequelize.literal(`totalBalance + ${totalBalance}`),
      },
      {
        where: {
          [Op.and]: [
            fn("DATE", fn("NOW")),
            sequelize.where(
              fn("DATE", sequelize.col("dateTime")),
              "=",
              fn("DATE", currentDate)
            ),
          ],
        },
      }
    )
      .then((result) => {
        return res.status(200).json({ message: "done", result });
      })
      .catch((err) => {
        console.log(err);
        res.status(500).json({ message: "failed" });
      });
  };
};

exports.PostEditPackage = (req, res, next) => {
  console.log("Post EditPackage");
  const { packageId, newStatus, NewDriverUsername } = req.body;
  Package.update(
    {
      status: newStatus,
      driver_userName: NewDriverUsername,
    },
    { where: { packageId } }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.sendPackage = (req, res, next) => {
  const rec_userName = req.body.rec_userName;
  const recName = req.body.recName;
  const recEmail = req.body.recEmail;
  const send_userName = req.body.send_userName;
  const senderName = req.body.senderName;
  const senderEmail = req.body.senderEmail;
  const phoneNumber = req.body.phoneNumber;
  const senderPhoneNumber = req.body.senderPhoneNumber;
  const packagePrice = req.body.packagePrice;
  const shippingType = req.body.shippingType;
  const whoWillPay = req.body.whoWillPay;
  const distance = req.body.distance;
  const latTo = req.body.latTo;
  const toCity= req.body.toCity;
  const fromCity= req.body.fromCity;
  const longTo = req.body.longTo;
  const latFrom = req.body.latFrom;
  const longFrom = req.body.longFrom;
  const locationFromInfo = req.body.locationFromInfo;
  const locationToInfo = req.body.locationToInfo;
  const error = validationResult(req);

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  const total = Customer.calaulateTotalPrice(shippingType, distance);
  let packageSize;
  let pass = "c" + Customer.generateRandomNumber() + "f";
  if (shippingType == "Package2") {
    packageSize = "Large size box";
  } else if (shippingType == "Package1") {
    packageSize = "Meduim size box";
  } else if (shippingType == "Package0") {
    packageSize = "Small size box";
  } else {
    packageSize = "Document";
  }
  let res_new_username= "C" + Customer.generateRandomNumber() + "fop"
  let send_new_username= "C" + Customer.generateRandomNumber() + "fop"
  let rec_pass = "c" + Customer.generateRandomNumber() + "f";
  let send_pass = "c" + Customer.generateRandomNumber() + "f";
  if(whoWillPay=="The sender")updateDilyCreatePackage(1,0,total);
  if (rec_userName != "" && send_userName != "") {
    Package.create({
      send_userName: send_userName,
      rec_userName: rec_userName,
      status: "In Warehouse",
      whoWillPay: whoWillPay,
      shippingType: shippingType,
      recName: recName,
      recEmail: recEmail,
      recPhone: phoneNumber,
      locationFromInfo: locationFromInfo,
      locationToInfo: locationToInfo,
      distance: distance,
      latTo: latTo,
      longTo: longTo,
      latFrom: latFrom,
      longFrom: longFrom,
      whoWillPay: whoWillPay,
      packagePrice: packagePrice,
      total: total,
      toCity: toCity,
      fromCity: fromCity,
    })
      .then((result) => {
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });
  } 
  else if(rec_userName != "" && send_userName == ""){
    Package.create(
      {
        send_user: {
          Fname: senderName,
          Lname: " ",
          userName: send_new_username,
          password: send_pass,
          email: senderEmail,
          phoneNumber: senderPhoneNumber,
          userType: "customer",
          url: ".jpg",
        },
        rec_userName: rec_userName,
        status: "In Warehouse",
        whoWillPay: whoWillPay,
        shippingType: shippingType,
        recName: recName,
        recEmail: recEmail,
        recPhone: phoneNumber,
        locationFromInfo: locationFromInfo,
        locationToInfo: locationToInfo,
        distance: distance,
        latTo: latTo,
        longTo: longTo,
        latFrom: latFrom,
        longFrom: longFrom,
        whoWillPay: whoWillPay,
        packagePrice: packagePrice,
        total: total,
        toCity: toCity,
        fromCity: fromCity,
      },
      {
        include: [Customer.user, Customer.user2],
      }
    )
      .then((result) => {
        User.findOne({ where: { username: rec_userName } })
          .then((result2) => {
            const info = trans.sendMail({
              from: "Package4U <support@Package4U.ps>",
              to: recEmail,
              subject: "There's a package for you",
              html: emailTemplate(recName, result2, result, packageSize, pass),
            });
            console.log("email send");
          })
          .catch((err) => console.log(err));
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });

  }
  else if(rec_userName == "" && send_userName != ""){
    Package.create(
      {
        send_userName: send_userName,
        rec_user: {
          Fname: recName,
          Lname: " ",
          userName: res_new_username,
          password: rec_pass,
          email: recEmail,
          phoneNumber: phoneNumber,
          userType: "customer",
          url: ".jpg",
        },
        status: "In Warehouse",
        whoWillPay: whoWillPay,
        shippingType: shippingType,
        recName: recName,
        recEmail: recEmail,
        recPhone: phoneNumber,
        locationFromInfo: locationFromInfo,
        locationToInfo: locationToInfo,
        distance: distance,
        latTo: latTo,
        longTo: longTo,
        latFrom: latFrom,
        longFrom: longFrom,
        whoWillPay: whoWillPay,
        packagePrice: packagePrice,
        total: total,
        toCity: toCity,
        fromCity: fromCity,
      },
      {
        include: [Customer.user, Customer.user2],
      }
    )
      .then((result) => {
        User.findOne({ where: { username: res_new_username } })
          .then((result2) => {
            const info = trans.sendMail({
              from: "Package4U <support@Package4U.ps>",
              to: recEmail,
              subject: "There's a package for you",
              html: emailTemplate(recName, result2, result, packageSize, pass),
            });
            console.log("email send");
          })
          .catch((err) => console.log(err));
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });

  }
  else {

    Package.create(
      {
        send_user: {
          Fname: senderName,
          Lname: " ",
          userName: send_new_username,
          password: send_pass,
          email: senderEmail,
          phoneNumber: senderPhoneNumber,
          userType: "customer",
          url: ".jpg",
        },
        rec_user: {
          Fname: recName,
          Lname: " ",
          userName: res_new_username,
          password: rec_pass,
          email: recEmail,
          phoneNumber: phoneNumber,
          userType: "customer",
          url: ".jpg",
        },
        status: "In Warehouse",
        whoWillPay: whoWillPay,
        shippingType: shippingType,
        recName: recName,
        recEmail: recEmail,
        recPhone: phoneNumber,
        locationFromInfo: locationFromInfo,
        locationToInfo: locationToInfo,
        distance: distance,
        latTo: latTo,
        longTo: longTo,
        latFrom: latFrom,
        longFrom: longFrom,
        whoWillPay: whoWillPay,
        packagePrice: packagePrice,
        total: total,
        toCity: toCity,
        fromCity: fromCity,
      },
      {
        include: [Customer.user, Customer.user2],
      }
    )
      .then((result) => {
        User.findOne({ where: { username: res_new_username } })
          .then((result2) => {
            const info = trans.sendMail({
              from: "Package4U <support@Package4U.ps>",
              to: recEmail,
              subject: "There's a package for you",
              html: emailTemplate(recName, result2, result, packageSize, pass),
            });
            console.log("email send");
          })
          .catch((err) => console.log(err));
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });
  }
};
