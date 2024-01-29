const User = require("../models/users");
const Package = require("../models/package");
const PackagePrice = require("../models/packagePrice");
const Driver = require("../models/driver");
const DailyReport = require("../models/dailyReport");
const Technical = require("../models/technicalMessage");
const Customer = require("./customerController");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const sequelize = require("../util/database");
const { Sequelize, where } = require("sequelize");
const notification = require("../util/notifications");
const { log } = require("console");
const { Op, fn } = require("sequelize");

const reciveDriver = PackagePrice.belongsTo(User, {
  foreignKey: "reciveDriver_userName",
  onDelete: "CASCADE",
  as: "reciveDriver",
});
Package.hasMany(PackagePrice, { foreignKey: "reciveDriver_userName" });

const deliverDriver = PackagePrice.belongsTo(User, {
  foreignKey: "deliverDriver_userName",
  onDelete: "CASCADE",
  as: "deliverDriver",
});
Package.hasMany(PackagePrice, { foreignKey: "deliverDriver_userName" });

const pkt = PackagePrice.belongsTo(Package, {
  foreignKey: "pkt_packageId",
  onDelete: "CASCADE",
  as: "pktId",
});
Package.hasMany(PackagePrice, { foreignKey: "pkt_packageId" });

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

function getPackageTo(status) {
  if (
    status == "In Warehouse" ||
    status == "With Driver" ||
    status == "Delivered" ||
    status == "Assigned to deliver" ||
    status == "Completed"
  )
    return 1;
  return 0;
}

const updateDilyCreatePackage = async (
  receivedNumber,
  deliverdNumber,
  totalBalance
) => {
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
            fn("DATE", sequelize.col("date")),
            "=",
            fn("DATE", new Date())
          ),
        ],
      },
    }
  )
    .then((result) => {
      console.log("DailyReport done");
    })
    .catch((err) => {
      console.log(err);
    });
};

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

exports.getAssignPackageToDriver = (req, res, next) => {
  console.log("getAssignPackageToDriver");
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
    where: {
      status: ["Accepted", "In Warehouse"],
    },
  })
    .then((result) => {
      if (result.length != 0) {
        const packageList = result.map((result) => ({
          packageId: result.packageId,
          username:
            result.status == "Accepted"
              ? result.send_userName
              : result.rec_userName,
          img:
            result.status == "Accepted"
              ? "/image/" + result.send_user.userName + result.send_user.url
              : "/image/" + result.rec_user.userName + result.rec_user.url,
          name:
            result.status == "Accepted"
              ? result.send_user.Fname + " " + result.send_user.Lname
              : result.rec_user.Fname + " " + result.rec_user.Lname,
          city: result.status == "Accepted" ? result.fromCity : result.toCity,
          packageType: result.status == "Accepted" ? 1 : 0,
          packageSize: result.shippingType,
          reason: result.driverComment,
          status: result.status,
        }));

        res.status(200).json(packageList);
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.getAllPackages = (req, res, next) => {
  console.log("getAllPackages");
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
      {
        model: User,
        as: "driver",
        attributes: ["Fname", "Lname", "userName", "url"],
      },
    ],
  })
    .then((result) => {
      if (result.length != 0) {
        const packageList = result.map((result) => ({
          packageId: result.packageId,
          username: getPackageTo(result.status)
            ? result.rec_userName
            : result.send_userName,

          img: getPackageTo(result.status)
            ? "/image/" + result.rec_user.userName + result.rec_user.url
            : "/image/" + result.send_user.userName + result.send_user.url,

          name: getPackageTo(result.status)
            ? result.rec_user.Fname + " " + result.rec_user.Lname
            : result.send_user.Fname + " " + result.send_user.Lname,

          city: getPackageTo(result.status) ? result.toCity : result.fromCity,
          packageType: getPackageTo(result.status) == 0 ? 1 : 0,
          driverName:
            result.driver != null
              ? result.driver.Fname + " " + result.driver.Lname
              : "null",
          status: result.status,
          driverUsername: result.driver_userName,
          whoWillPay: result.whoWillPay,
          reason: result.driverComment,
        }));

        res.status(200).json(packageList);
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.PostAcceptPackage = (req, res, next) => {
  console.log("post AcceptPackage");
  const { packageId } = req.body;
  Package.update(
    {
      status: "Accepted",
      receiveDate: Sequelize.fn("NOW"),
      driverComment: null,
    },
    { where: { packageId } }
  )
    .then((result) => {
      notification.SendPackageNotification("Accepted", packageId);
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
        notAvailableDate: driver.notAvailableDate,
        assignedPackagesNumber: 4
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
      status: ["Assigned to receive", "Assigned to deliver"],
    },
  })
    .then((results) => {
      const DistributionOrders = results.map((result) => ({
        packageId: result.packageId,
        packageType:
          result.status == "Assigned to receive" ? "Recive" : "Deliver",
        customerName:
          result.status == "Assigned to receive"
            ? result.send_user.Fname + " " + result.send_user.Lname
            : result.rec_user.Fname + " " + result.rec_user.Lname,
        phoneNumber:
          result.status == "Assigned to receive"
            ? result.send_user.phoneNumber
            : result.rec_user.phoneNumber,
        driverName: result.driver.Fname + " " + result.driver.Lname,
        address:
          result.status == "Assigned to receive"
            ? result.fromCity
            : result.toCity,
      }));
      res.status(200).json({ message: "done", result: DistributionOrders });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.GetDriversBalance = async (req, res, next) => {
  console.log("Get DriversBalance");

  try {
    const Drivers = await Driver.findAll({
      include: [{ model: User, as: "user" }],
    });

    const driverList = await Promise.all(Drivers.map(async (driver) => ({
      username: driver.userUserName,
      img: "/image/" + driver.userUserName + driver.user.url,
      name: driver.user.Fname + " " + driver.user.Lname,
      totalBalance: driver.totalBalance,
      deliverdNumber: driver.deliverdNumber,
      receivedNumber: driver.receivedNumber,
      paiedAmount: await packagePriceAmountDriver(driver.userUserName,"Complete Receive"),
      reciveAmount: await packagePriceAmountDriver(driver.userUserName, "Delivered"),
    })));

    res.status(200).json(driverList);
  } catch (error) {
    console.error("Error in GetDriversBalance:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
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
    .then(async (result) => {
      await createRecordINPackagePrice();
      await updateRecordINPackagePrice();
      updatePaclagesInWarehouse();
      updatePaclagesCompleted();
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
              fn("DATE", sequelize.col("date")),
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
  const updatePaclagesInWarehouse = async () => {
    await Package.update(
      {
        status: "In Warehouse",
        driver_userName: null,
        driverComment: null,
      },
      {
        where: {
          driver_userName: driverUsername,
          status: "Complete Receive",
        },
      }
    );
  };
  const updatePaclagesCompleted = async () => {
    await Package.update(
      {
        status: "Completed",
        driver_userName: null,
      },
      {
        where: {
          driver_userName: driverUsername,
          status: "Delivered",
        },
      }
    );
  };
  const createRecordINPackagePrice = async () => {
    const pkgs = await Package.findAll({
      where: {
        driver_userName: driverUsername,
        status: "Complete Receive",
      },
    });
    for (let i = 0; i < pkgs.length; i++) {
      await PackagePrice.create({
        pkt_packageId: pkgs[i].packageId,
        paidAmount: pkgs[i].packagePrice,
        deliverDriver_userName: null,
        reciveDriver_userName: driverUsername,
        receiveDate: Sequelize.fn("NOW"),
      });
    }
  };

  const updateRecordINPackagePrice = async () => {
    const pkgs = await Package.findAll({
      where: {
        driver_userName: driverUsername,
        status: "Delivered",
      },
    });
    for (let i = 0; i < pkgs.length; i++) {
      await PackagePrice.update(
        {
          receiveAmount: pkgs[i].packagePrice,
          deliverDriver_userName: driverUsername,
          deliverDate: Sequelize.fn("NOW"),
        },
        { where: { pkt_packageId: pkgs[i].packageId } }
      );
    }
  };
};

exports.PostEditPackage = (req, res, next) => {
  console.log("Post EditPackage");
  const { packageId, packageStatus, driverUsername, whoWillPay } = req.body;
  let newDriverUsername;
  let newStatus;
  if (packageStatus == "Under review") {
    newStatus = "Under review";
    newDriverUsername = null;
  } else if (packageStatus == "Rejected by employee") {
    newStatus = "Under review";
    newDriverUsername = null;
  } else if (packageStatus == "Accepted") {
    newStatus = "Under review";
    newDriverUsername = null;
  } else if (packageStatus == "Assigned to receive") {
    newStatus = "Accepted";
    newDriverUsername = null;
  } else if (packageStatus == "Wait Driver") {
    newStatus = "Assigned to receive";
    newDriverUsername = driverUsername;
  } else if (
    packageStatus == "Complete Receive" ||
    packageStatus == "Rejected by driver"
  ) {
    newStatus = "Wait Driver";
    newDriverUsername = driverUsername;
    //correct the money in driver table
  } else if (packageStatus == "In Warehouse") {
    //not allowed
    newStatus = "In Warehouse";
    newDriverUsername = null;
  } else if (packageStatus == "Assigned to deliver") {
    newStatus = "In Warehouse";
    newDriverUsername = null;
  } else if (packageStatus == "With Driver") {
    newStatus = "Assigned to deliver";
    newDriverUsername = driverUsername;
  } else if (packageStatus == "Delivered") {
    newStatus = "With Driver";
    newDriverUsername = driverUsername;
    //correct the money in driver table
  } else if (packageStatus == "Completed") {
    //not allowed
    newStatus = "Delivered";
    newDriverUsername = driverUsername;
  } else {
    console.log("errrrrrrrrrrrrrorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    newStatus = "Under review";
    newDriverUsername = null;
  }
  let updateJson;
  if (driverUsername == null) {
    updateJson = {
      status: newStatus,
      driver_userName: newDriverUsername,
    };
  } else {
    updateJson = {
      status: newStatus,
    };
  }
  Package.update(
    updateJson,

    { where: { packageId } }
  )
    .then((result) => {
      updateDriverMoney(packageStatus, packageId, driverUsername);
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });

  const updateDriverMoney = async (
    packageStatus,
    packageId,
    driverUserName
  ) => {
    let balanceDecVal = 0;
    let numberOfPackages = 0;
    let pkt = await getPackageInfo(packageId);
    if (pkt.whoWillPay == "The sender" && packageStatus == "Complete Receive") {
      balanceDecVal = pkt.total;
      console.log(balanceDecVal);
    }
    if (pkt.whoWillPay == "The recipient" && packageStatus == "Delivered") {
      balanceDecVal = pkt.total;
    }
    if (packageStatus == "Delivered" || packageStatus == "Complete Receive")
      numberOfPackages = 1;
    console.log(driverUserName);
    Driver.update(
      packageStatus == "Delivered"
        ? {
            totalBalance: Sequelize.literal(`totalBalance - ${balanceDecVal}`),
            deliverdNumber: Sequelize.literal(
              `deliverdNumber - ${numberOfPackages}`
            ),
            deliverDate: null,
          }
        : {
            totalBalance: Sequelize.literal(`totalBalance - ${balanceDecVal}`),
            receivedNumber: Sequelize.literal(
              `receivedNumber - ${numberOfPackages}`
            ),
            receiveDate: Sequelize.fn("NOW"),
          },
      {
        where: { userUserName: driverUserName },
      }
    )
      .then((result) => {})
      .catch((err) => {});
  };
  const getPackageInfo = async (packageId) => {
    return await Package.findOne({ where: { packageId: packageId } })
      .then((result) => {
        return result;
      })
      .catch((err) => {
        console.log(err);
      });
  };
};

exports.PostAssignPackageToDriver = (req, res, next) => {
  console.log("post PostAssignPackageToDriver");
  const { packageId, driverUsername, assignToDate, packageType } = req.body;
  Package.update(
    {
      status: packageType == 1 ? "Assigned to receive" : "Assigned to deliver",
      receiveDate: assignToDate,
      driver_userName: driverUsername,
      driverComment: null,
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
  const toCity = req.body.toCity;
  const fromCity = req.body.fromCity;
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
  let res_new_username = "C" + Customer.generateRandomNumber() + "fop";
  let send_new_username = "C" + Customer.generateRandomNumber() + "fop";
  let rec_pass = "c" + Customer.generateRandomNumber() + "f";
  let send_pass = "c" + Customer.generateRandomNumber() + "f";
  if (whoWillPay == "The sender") updateDilyCreatePackage(1, 0, total);
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
        notification.SendPackageNotification("In Warehouse", result.packageId);
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });
  } else if (rec_userName != "" && send_userName == "") {
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
        notification.SendPackageNotification("In Warehouse", result.packageId);
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
  } else if (rec_userName == "" && send_userName != "") {
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
        notification.SendPackageNotification("In Warehouse", result.packageId);
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
  } else {
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
        notification.SendPackageNotification("In Warehouse", result.packageId);
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

exports.DeletePackage = (req, res) => {
  const { packageId } = req.body;
  Package.destroy({ where: { packageId: packageId } })
    .then((result) => {
      if (result == 1) res.status(200).json({ message: "done" });
      else res.status(500).json({ message: "failed" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.GetPackageDetailes = async (req, res) => {
  const packageId = req.query.packageId;
  const PackageDeteils = await Package.findOne({
    where: { packageId: packageId },
    attributes: [
      "packageId",
      "status",
      "shippingType",
      "whoWillPay",
      "packagePrice",
      "total",
      "toCity",
      "fromCity",
      "driver_userName",
    ],
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: [
          "Fname",
          "Lname",
          "userName",
          "url",
          "city",
          "phoneNumber",
          "email",
        ],
      },
      {
        model: User,
        as: "send_user",
        attributes: [
          "Fname",
          "Lname",
          "userName",
          "url",
          "city",
          "phoneNumber",
          "email",
        ],
      },
    ],
  });
  const packagePriceDetails = await PackagePrice.findOne({
    where: { pkt_packageId: packageId },
    attributes: ["paidAmount", "receiveAmount", "receiveDate", "deliverDate"],
    include: [
      {
        model: User,
        as: "deliverDriver",
        attributes: ["Fname", "Lname", "userName"],
      },
      {
        model: User,
        as: "reciveDriver",
        attributes: ["Fname", "Lname", "userName"],
      },
    ],
  });
  // const pkgs=await Package.findAll()
  // for(let i=0;i<pkgs.length;i++){
  //   if(pkgs[i].status=="In Warehouse"){
  //    await PackagePrice.create({pkt_packageId:pkgs[i].packageId,deliverDriver_userName:null,reciveDriver_userName:"driver"}).then((result) => {

  //    }).catch((err) => {
  //     console.log(err);
  //    });
  //   }
  // }

  res.status(200).json({ PackageDeteils, packagePriceDetails });
};


const packagePriceAmountDriver = async (username, status) => {
  const totalPaiedAmount = await Package.sum("packagePrice", {
    where: {
      status:status,
      driver_userName: username,
    },
  });
  return totalPaiedAmount==null?0:totalPaiedAmount;
};
