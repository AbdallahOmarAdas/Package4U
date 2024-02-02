const User = require("../models/users");
const Sequelize = require("sequelize");
const Driver = require("../models/driver");
const { validationResult } = require("express-validator");
const fs = require("fs");
const path = require("path");
const Package = require("../models/package");
//Driver.belongsTo(User, { as: 'driver' });
const { Op, fn } = require("sequelize");
const sequelize = require("../util/database");
const notification = require("../util/notifications");

exports.getDeliverdDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const currentDate = new Date();

  Package.findAll({
    include: [
      { model: User, as: "rec_user" },
      { model: User, as: "send_user" },
    ],
    where: {
      driver_userName: driverUserName,
      status: ["Delivered", "Complete Receive"],
      [Op.or]: [
        {
          [Op.and]: [
            fn("DATE", fn("NOW")),
            sequelize.where(
              fn("DATE", sequelize.col("deliverDate")),
              "=",
              fn("DATE", currentDate)
            ),
          ],
        },
        {
          [Op.and]: [
            fn("DATE", fn("NOW")),
            sequelize.where(
              fn("DATE", sequelize.col("receiveDate")),
              "=",
              fn("DATE", currentDate)
            ),
          ],
        },
      ],
    },
  })
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.getPreparePackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const currentDate = new Date();
  console.log(currentDate);
  Package.findAll({
    include: [
      { model: User, as: "rec_user" },
      { model: User, as: "send_user" },
    ],
    where: {
      driver_userName: driverUserName,
      status: ["Assigned to receive", "Assigned to deliver"],
      // receiveDate: {
      //   [Op.lte]: currentDate, // Less than or equal to current date
      // },
      [Op.and]: [
        fn("DATE", fn("NOW")),
        sequelize.where(
          fn("DATE", sequelize.col("receiveDate")),
          "=",
          fn("DATE", currentDate)
        ),
      ],
    },
  })
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postAcceptPreparePackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const status = req.body.status;
  const packageId = req.body.packageId;
  let newStatus;
  if (status == "Assigned to receive") {
    notification.SendPackageNotification("Wait Driver", packageId);
    newStatus = "Wait Driver";
  } else {
    notification.SendPackageNotification("With Driver", packageId);
    newStatus = "With Driver";
  }
  Package.update(
    {
      status: newStatus,
      driverComment: null,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Assigned to receive", "Assigned to deliver"],
        packageId: packageId,
      },
    }
  )
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postRejectPreparePackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const status = req.body.status;
  const packageId = req.body.packageId;
  const comment = req.body.comment;
  let msg;
  let newStatus;
  if (status == "Assigned to receive") {
    msg = "reject receive";
    newStatus = "Accepted";
  } else {
    msg = "reject deliver";
    msg = "reject receive";
    newStatus = "In Warehouse";
  }
  Package.update(
    {
      status: newStatus,
      driverComment:
        `The Driver ${msg} this package\nDate: ${new Date().toLocaleDateString()}` +
        "\nDriver Comment: " +
        comment,
      driver_userName: null,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Assigned to receive", "Assigned to deliver"],
        packageId: packageId,
      },
    }
  )
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postOnGoingPackagesDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  Package.findAll({
    include: [
      { model: User, as: "rec_user" },
      { model: User, as: "send_user" },
    ],
    where: {
      driver_userName: driverUserName,
      status: ["Wait Driver", "With Driver"],
    },
  })
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postCancelOnGoingPackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const status = req.body.status;
  const packageId = req.body.packageId;
  let newStatus;
  if (status == "Wait Driver") {
    newStatus = "Accepted";
  } else {
    newStatus = "In Warehouse";
  }
  Package.update(
    {
      status: newStatus,
      driver_userName: null,
      driverComment: null,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Wait Driver", "With Driver"],
        packageId: packageId,
      },
    }
  )
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postCompleatePackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const status = req.body.status;
  const total = req.body.total;
  const whoWillPay = req.body.whoWillPay;
  const packageId = req.body.packageId;
  let newStatus;
  let balanceIncVal = 0;
  if (whoWillPay == "The sender" && status == "Wait Driver") {
    balanceIncVal = total;
  }
  if (whoWillPay == "The recipient" && status == "With Driver") {
    balanceIncVal = total;
  }

  if (status == "Wait Driver") {
    newStatus = "Complete Receive";
    notification.SendPackageNotification("Complete Receive", packageId);
  } else {
    notification.SendPackageNotification("Delivered", packageId);
    newStatus = "Delivered";
  }
  Driver.update(
    newStatus == "Delivered"
      ? {
          status: newStatus,
          totalBalance: Sequelize.literal(`totalBalance + ${balanceIncVal}`),
          deliverdNumber: Sequelize.literal(`deliverdNumber + ${1}`),
          deliverDate: Sequelize.fn("NOW"),
        }
      : {
          status: newStatus,
          totalBalance: Sequelize.literal(`totalBalance + ${balanceIncVal}`),
          receivedNumber: Sequelize.literal(`receivedNumber + ${1}`),
          receiveDate: Sequelize.fn("NOW"),
        },
    {
      where: { userUserName: driverUserName },
    }
  )
    .then((result) => {})
    .catch((err) => {
      console.log(err);
    });
  Package.update(
    newStatus == "Delivered"
      ? {
          status: newStatus,
          driverComment: null,
          deliverDate: Sequelize.fn("NOW"),
        }
      : {
          status: newStatus,
          receiveDate: Sequelize.fn("NOW"),
          driverComment: null,
        },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Wait Driver", "With Driver"],
        packageId: packageId,
      },
    }
  )
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postRejectWorkOnPackageDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  const packageId = req.body.packageId;
  const comment = req.body.comment;
  Package.update(
    {
      status: "Rejected by driver",
      driverComment: comment,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: "Wait Driver",
        packageId: packageId,
      },
    }
  )
    .then((result) => {
      if (result.length != 0) {
        return res.status(200).json({ message: "done", result });
      } else {
        return res.status(404).json();
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.getSummary = async (req, res, next) => {
  try {
    const driverUserName = req.query.driverUserName;
    let notReceived = 0;
    let notDelivered = 0;

    try {
      notReceived = await Package.count({
        where: { driver_userName: driverUserName, status: "Wait Driver" },
      });
    } catch (err) {
      console.log(err);
    }

    try {
      notDelivered = await Package.count({
        where: { driver_userName: driverUserName, status: "With Driver" },
      });
    } catch (err) {
      console.log(err);
    }

    const summary = await Driver.findOne({ where: { userUserName: driverUserName } });

    res.status(200).json({
      balance: summary.totalBalance + (await packagePriceAmountDriver(driverUserName, "Delivered")),
      deliverd: summary.deliverdNumber,
      received: summary.receivedNumber,
      notReceived: notReceived==null?0:notReceived,
      notDelivered: notDelivered==null?0:notDelivered,
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "failed" });
  }
};


exports.GetDriverListManager = (req, res, next) => {
  const todayDay = new Date().toLocaleDateString("en-US", {
    weekday: "long",
  });
  const todayDate = new Date().toISOString().split("T")[0];

  Driver.findAll({
    include: [{ model: User, as: "user" }],
    where: {
      workingDays: {
        [Op.like]: `%${todayDay}%`,
      },
    },
  })
    .then((drivers) => {
      const driverList = drivers.map((driver) => ({
        late: driver.latitude,
        long: driver.longitude,
        username: driver.userUserName,
        img: driver.userUserName + driver.user.url,
        name: driver.user.Fname + " " + driver.user.Lname,
        updatedAt: driver.updatedAt,
      }));

      res.status(200).json(driverList);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.GetDriverLocation = (req, res, next) => {
  const driverUserName = req.query.driverUserName;
  Driver.findOne({ where: { userUserName: driverUserName } })
    .then((driver) => {
      res
        .status(200)
        .json({
          late: driver.latitude,
          long: driver.longitude,
          updatedAt: driver.updatedAt,
        });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.PostEditLocation = (req, res) => {
  const driverUserName = req.body.driverUserName;
  const body = req.body;
  Driver.update(
    {
      latitude: body.latitude + 0.00001000001602,
      longitude: body.longitude + 0.00110000001602,
    },
    {
      where: { userUserName: driverUserName },
    }
  )
    .then((result) => {
      res.status(200).json({ message: "done" });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
      console.log(err);
    });
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