const User = require("../models/users");
const Sequelize = require("sequelize");
const Driver = require("../models/driver");
const { validationResult } = require("express-validator");
const fs = require("fs");
const path = require("path");
const Package = require("../models/package");
//Driver.belongsTo(User, { as: 'driver' });

exports.getDeliverdDriver = (req, res, next) => {
  const driverUserName = req.body.driverUserName;
  Package.findAll({
    include: [
      { model: User, as: "rec_user" },
      { model: User, as: "send_user" },
    ],
    where: {
      driver_userName: driverUserName,
      status: ["Delivered", "Complete Receive"],
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
  Package.findAll({
    include: [
      { model: User, as: "rec_user" },
      { model: User, as: "send_user" },
    ],
    where: {
      driver_userName: driverUserName,
      status: ["Accepted", "In Warehouse"],
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
  if (status == "Accepted") {
    newStatus = "Wait Driver";
  } else {
    newStatus = "With Driver";
  }
  Package.update(
    {
      status: newStatus,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Accepted", "In Warehouse"],
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
  let newStatus;
  if (status == "Accepted") {
    newStatus = "Receive Rejected";
  } else {
    newStatus = "Deliver Rejected";
  }
  Package.update(
    {
      status: newStatus,
      driverComment: comment,
    },
    {
      where: {
        driver_userName: driverUserName,
        status: ["Accepted", "In Warehouse"],
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
  } else {
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

          deliverDate: Sequelize.fn("NOW"),
        }
      : {
          status: newStatus,
          receiveDate: Sequelize.fn("NOW"),
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

exports.getSummary = (req, res, next) => {
  const driverUserName = req.query.driverUserName;
  let notReceived = 0;
  let notDeliverd = 0;
  Package.count({
    where: { driver_userName: driverUserName, status: "Wait Driver" },
  })
    .then((count) => {
      notReceived = count;
    })
    .catch((err) => {
      console.log(err);
    });
  Package.count({
    where: { driver_userName: driverUserName, status: "With Driver" },
  })
    .then((count) => {
      notDeliverd = count;
    })
    .catch((err) => {
      console.log(err);
    });
  Driver.findOne({ where: { userUserName: driverUserName } })
    .then((Summary) => {
      res.status(200).json({
        balance: Summary.totalBalance,
        deliverd: Summary.deliverdNumber,
        received: Summary.receivedNumber,
        notReceived: notReceived,
        notDeliverd: notDeliverd,
      });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};
exports.GetDriverListManager = (req, res, next) => {
  Driver.findAll({ include: [{ model: User, as: "user" }] })
    .then((drivers) => {
      const driverList = drivers.map((driver) => ({
        late: driver.latitude,
        long: driver.longitude,
        username: driver.userUserName,
        img: driver.userUserName + driver.user.url,
        name: driver.user.Fname + " " + driver.user.Lname,
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
      res.status(200).json({ late: driver.latitude, long: driver.longitude });
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
      latitude: body.latitude+0.05001000001602,
      longitude: body.longitude+0.00110000001602,
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
