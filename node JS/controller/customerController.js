const User = require("../models/users");
const Package = require("../models/package");
const Driver = require("../models/driver");
const Locations = require("../models/locations");
const Notification = require("../models/nofification");
const Technical = require("../models/technicalMessage");
const Customer = require("../models/customer");
const { validationResult } = require("express-validator");
const nodemailer = require("nodemailer");
const fs = require("fs");
const path = require("path");
const sequelize = require("../util/database");
const { Sequelize } = require("sequelize");
const notification = require("../util/notifications");
const { log } = require("console");
//User.hasOne(Package);
const user = Package.belongsTo(User, {
  foreignKey: "rec_userName",
  onDelete: "CASCADE",
  as: "rec_user",
});
User.hasMany(Package, { foreignKey: "rec_userName" });

const user2 = Package.belongsTo(User, {
  foreignKey: "send_userName",
  onDelete: "CASCADE",
  as: "send_user",
});
User.hasMany(Package, { foreignKey: "send_userName" });

const driver = Package.belongsTo(User, {
  foreignKey: "driver_userName",
  onDelete: "CASCADE",
  as: "driver",
});
User.hasMany(Package, { foreignKey: "driver_userName" });

const userLocation = Locations.belongsTo(User, { foreignKey: "userName" });
User.hasMany(Locations, { foreignKey: "userName" });

function generateRandomNumber() {
  const min = 100000; // Smallest 5-digit number
  const max = 999990; // Largest 5-digit number
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
function calaulateTotalPrice(shippingType, distance) {
  var totalPrice;
  const jsonData = require("../json/cost");
  let boxSizePrice;
  if (shippingType == "Package0") {
    boxSizePrice = 0;
  } else if (shippingType == "Package1") {
    boxSizePrice = jsonData.bigPackagePrice / 2;
  } else if (shippingType == "Package2") {
    boxSizePrice = jsonData.bigPackagePrice;
  } else {
    boxSizePrice = 0;
  }
  totalPrice =
    jsonData.openingPrice + boxSizePrice + distance * jsonData.pricePerKm;
  totalPrice *= (100 - jsonData.discount) / 100;
  return totalPrice;
}

// notification.SendNotification(
//   "Package status changed",
//   "your backage now in wherhous",
//   "this bakade from you to abdallah",
//   "Accepted",
//   "omar",
//   42
// );
exports.sendPackageEmail = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const recName = req.body.recName;
  const recEmail = req.body.recEmail;
  const phoneNumber = req.body.phoneNumber;
  const packagePrice = req.body.packagePrice;
  const shippingType = req.body.shippingType;
  const whoWillPay = req.body.whoWillPay;
  const distance = req.body.distance;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  const latFrom = req.body.latFrom;
  const longFrom = req.body.longFrom;
  const locationFromInfo = req.body.locationFromInfo;
  const locationToInfo = req.body.locationToInfo;
  const error = validationResult(req);
  let packageSize;
  if (shippingType == "Package2") {
    packageSize = "Large size box";
  } else if (shippingType == "Package1") {
    packageSize = "Meduim size box";
  } else if (shippingType == "Package0") {
    packageSize = "Small size box";
  } else {
    packageSize = "Document";
  }

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  const total = calaulateTotalPrice(shippingType, distance);
  Package.create(
    {
      send_userName: customerUserName,
      rec_userName: null,
      status: "Under review",
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
    },
    {
      include: [user, user2],
    }
  )
    .then((result) => {
      User.findOne({ where: { username: customerUserName } })
        .then((result2) => {
          const emailTemplate = (recName) => {
            return `
                  <html>
                    <body>
                      <p>Hello ${recName},</p>
                      <p>${
                        result2.Fname + " " + result2.Lname
                      } has created a new package with number: ${
              result.packageId
            } for you, 
                      you can track the status of the package by downloading Package4U application and writing the attached package number.</p>
                      <p><strong>Package details:</strong></p>
                      <ol>
                        <li>The one who will pay to the driver is: ${
                          result.whoWillPay
                        }</li>
                        <li>The price of the package is: ${
                          result.packagePrice
                        }</li>
                        <li>Total delivery price is: ${result.total.toFixed(
                          2
                        )}</li>
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
          const info = trans.sendMail({
            from: "Package4U <support@Package4U.ps>",
            to: recEmail,
            subject: "There's a package for you",
            html: emailTemplate(recName),
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
};
exports.sendPackageUser = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const rec_userName = req.body.rec_userName;
  const recName = req.body.recName;
  const recEmail = req.body.recEmail;
  const phoneNumber = req.body.phoneNumber;
  const packagePrice = req.body.packagePrice;
  const shippingType = req.body.shippingType;
  const whoWillPay = req.body.whoWillPay;
  const distance = req.body.distance;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  const latFrom = req.body.latFrom;
  const longFrom = req.body.longFrom;
  const locationFromInfo = req.body.locationFromInfo;
  const locationToInfo = req.body.locationToInfo;
  const error = validationResult(req);

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  const total = calaulateTotalPrice(shippingType, distance);
  if (rec_userName != "") {
    Package.create(
      {
        send_userName: customerUserName,
        rec_userName: rec_userName,
        status: "Under review",
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
      },
      {
        include: [user, user2],
      }
    )
      .then((result) => {
        notification.SendNotification(
          notification.titlePindingToCustomer,
          "A new package has been created for you. The package is currently under review",
          "This Packade for you",
          "Under review",
          result.rec_userName,
          result.packageId
        );
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed" });
        console.log(err);
      });
  } else {
    let packageSize;
    let pass = "c" + generateRandomNumber() + "f";
    if (shippingType == "Package2") {
      packageSize = "Large size box";
    } else if (shippingType == "Package1") {
      packageSize = "Meduim size box";
    } else if (shippingType == "Package0") {
      packageSize = "Small size box";
    } else {
      packageSize = "Document";
    }
    Package.create(
      {
        send_userName: customerUserName,
        rec_user: {
          Fname: recName,
          Lname: " ",
          userName: "E" + generateRandomNumber() + "fop",
          password: pass,
          email: recEmail,
          phoneNumber: phoneNumber,
          userType: "customer",
          url: ".jpg",
        },
        status: "Under review",
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
      },
      {
        include: [user],
      }
    )
      .then((result) => {
        User.findOne({ where: { username: customerUserName } })
          .then((result2) => {
            const emailTemplate = (recName) => {
              return `
                  <html>
                    <body>
                      <p>Hello ${recName},</p>
                      <p>${
                        result2.Fname + " " + result2.Lname
                      } has created a new package with number: ${
                result.packageId
              } for you, 
                      you can track the status of the package by downloading Package4U application and writing the attached package number, and also you can edit delivery location.</p>
                      <p>We create an account for you with username: ${
                        result.rec_userName
                      } and password: ${pass}, you can change your information and password once you sign in to your account.</p>
                      <p><strong>Package details:</strong></p>
                      <ol>
                        <li>The one who will pay to the driver is: ${
                          result.whoWillPay
                        }</li>
                        <li>The price of the package is: ${
                          result.packagePrice
                        }</li>
                        <li>Total delivery price is: ${result.total.toFixed(
                          2
                        )}</li>
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
            const info = trans.sendMail({
              from: "Package4U <support@Package4U.ps>",
              to: recEmail,
              subject: "There's a package for you",
              html: emailTemplate(recName),
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
exports.PendingPackages = (req, res, next) => {
  const userName = req.query.userName;
  Package.findAll({
    where: { send_userName: userName, status: "Under review" },
  })
    .then((result) => {
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};
exports.notPendingPackages = (req, res, next) => {
  const userName = req.query.userName;
  Package.findAll({
    where: {
      send_userName: userName,
      status: { [Sequelize.Op.not]: "Under review" },
    },
  })
    .then((result) => {
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};

exports.postDeletePackage = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const packageId = req.body.packageId;
  Package.destroy({
    where: {
      send_userName: customerUserName,
      packageId: packageId,
      status: "Under review",
    },
  })
    .then((result) => {
      if (result == 1) res.status(200).json({ message: "done" });
      else res.status(200).json({ message: "failed" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postEditPackageLocation = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const packageId = req.body.packageId;
  const locationToInfo = req.body.locationToInfo;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  Package.update(
    { locationToInfo: locationToInfo, latTo: latTo, longTo: longTo },
    {
      where: {
        rec_userName: customerUserName,
        packageId: packageId,
        status: "Under review",
      },
    }
  )
    .then((result) => {
      if (result[0] == 1) res.status(200).json({ message: "done" });
      else res.status(200).json({ message: "failed1" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed1" });
    });
};
exports.PendingPackagesToMe = (req, res, next) => {
  const userName = req.query.userName;
  Package.findAll({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "phoneNumber", "email"],
        //as: user // Alias for the included model (optional)
      },
    ],
    where: { rec_userName: userName, status: "Under review" },
  })
    .then((result) => {
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      res.status(500).json({ message: "failed" });
    });
};
exports.notPendingPackagesToMe = (req, res, next) => {
  const userName = req.query.userName;
  Package.findAll({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "phoneNumber", "email"],
        //as: user // Alias for the included model (optional)
      },
    ],
    where: {
      rec_userName: userName,
      status: { [Sequelize.Op.not]: "Under review" },
    },
  })
    .then((result) => {
      console.log(result);
      res.status(200).json({ message: "done", result: result });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.editPackageUser = (req, res, next) => {
  const packageId = req.query.packageId;
  const customerUserName = req.body.customerUserName;
  const rec_userName = req.body.rec_userName;
  const recName = req.body.recName;
  const recEmail = req.body.recEmail;
  const phoneNumber = req.body.phoneNumber;
  const packagePrice = req.body.packagePrice;
  const shippingType = req.body.shippingType;
  const whoWillPay = req.body.whoWillPay;
  const distance = req.body.distance;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  const latFrom = req.body.latFrom;
  const longFrom = req.body.longFrom;
  const locationFromInfo = req.body.locationFromInfo;
  const locationToInfo = req.body.locationToInfo;
  const error = validationResult(req);

  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  const total = calaulateTotalPrice(shippingType, distance);
  if (rec_userName != "") {
    Package.update(
      {
        rec_userName: rec_userName,
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
      },
      {
        where: {
          packageId: packageId,
          send_userName: customerUserName,
          status: "Under review",
        },
      },
      {
        include: [user, user2],
      }
    )
      .then((result) => {
        j;
        res.status(201).json({ message: "done" });
      })
      .catch((err) => {
        res.status(500).json({ message: "failed edit" });
        console.log(err);
      });
  } else {
    let packageSize;
    let pass = "c" + generateRandomNumber() + "f";
    if (shippingType == "Package2") {
      packageSize = "Large size box";
    } else if (shippingType == "Package1") {
      packageSize = "Meduim size box";
    } else if (shippingType == "Package0") {
      packageSize = "Small size box";
    } else {
      packageSize = "Document";
    }
    Package.update(
      {
        user: {
          Fname: recName,
          Lname: " ",
          userName: "E" + generateRandomNumber() + "fop",
          password: pass,
          email: recEmail,
          phoneNumber: phoneNumber,
          userType: "customer",
          url: ".jpg",
        },
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
      },
      {
        where: {
          packageId: packageId,
          send_userName: customerUserName,
          status: "Under review",
        },
      },
      {
        include: [user],
      }
    )
      .then((result) => {
        //res.status(201).json({message:'done'});
        User.findOne({ where: { username: customerUserName } })
          .then((result2) => {
            const emailTemplate = (recName) => {
              return `
                  <html>
                    <body>
                      <p>Hello ${recName},</p>
                      <p>${
                        result2.Fname + " " + result2.Lname
                      } has update the package with number: ${
                result.packageId
              } for you, 
                      you can track the status of the package by downloading Package4U application and writing the attached package number, and also you can edit delivery location.</p>
                      <p>We create an account for you with username: ${
                        result.rec_userName
                      } and password: ${pass}, you can change your information and password once you sign in to your account.</p>
                      <p><strong>Package details:</strong></p>
                      <ol>
                        <li>The one who will pay to the driver is: ${
                          result.whoWillPay
                        }</li>
                        <li>The price of the package is: ${
                          result.packagePrice
                        }</li>
                        <li>Total delivery price is: ${result.total.toFixed(
                          2
                        )}</li>
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
            const info = trans.sendMail({
              from: "Package4U <support@Package4U.ps>",
              to: recEmail,
              subject: "There's a package for you",
              html: emailTemplate(recName),
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

exports.editPackageEmail = (req, res, next) => {
  const packageId = req.query.packageId;
  const customerUserName = req.body.customerUserName;
  const recName = req.body.recName;
  const recEmail = req.body.recEmail;
  const phoneNumber = req.body.phoneNumber;
  const packagePrice = req.body.packagePrice;
  const shippingType = req.body.shippingType;
  const whoWillPay = req.body.whoWillPay;
  const distance = req.body.distance;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  const latFrom = req.body.latFrom;
  const longFrom = req.body.longFrom;
  const locationFromInfo = req.body.locationFromInfo;
  const locationToInfo = req.body.locationToInfo;
  console.log(packagePrice);
  const error = validationResult(req);
  let packageSize;
  if (shippingType == "Package2") {
    packageSize = "Large size box";
  } else if (shippingType == "Package1") {
    packageSize = "Meduim size box";
  } else if (shippingType == "Package0") {
    packageSize = "Small size box";
  } else {
    packageSize = "Document";
  }
  if (!error.isEmpty()) {
    return res.status(422).json({ message: "failed", error });
  }
  const total = calaulateTotalPrice(shippingType, distance);
  Package.update(
    {
      rec_userName: null,
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
    },
    {
      where: {
        packageId: packageId,
        send_userName: customerUserName,
        status: "Under review",
      },
    },
    {
      include: [user, user2],
    }
  )
    .then((result) => {
      res.status(201).json({ message: "done" });
      User.findOne({ where: { username: customerUserName } })
        .then((result2) => {
          const emailTemplate = (recName) => {
            return `
                  <html>
                    <body>
                      <p>Hello ${recName},</p>
                      <p>${
                        result2.Fname + " " + result2.Lname
                      } has update the package(${packageId}) detailes, 
                      you can track the status of the package by downloading Package4U application and writing the attached package number.</p>
                      <p><strong>Updated Package details:</strong></p>
                      <ol>
                        <li>The one who will pay to the driver is: ${whoWillPay}</li>
                        <li>The price of the package is: ${packagePrice}</li>
                        <li>Total delivery price is: ${total.toFixed(2)}</li>
                        <li>Package Type: ${packageSize}</li>
                        <li>Delivery place:${locationFromInfo}</li>
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
          const info = trans.sendMail({
            from: "Package4U <support@Package4U.ps>",
            to: recEmail,
            subject: "Update package details",
            html: emailTemplate(recName),
          });
          console.log("email send");
        })
        .catch((err) => console.log(err));
    })
    .catch((err) => {
      res.status(500).json({ message: "failed edit" });
      console.log(err);
    });
};

exports.getPackageState = (req, res, next) => {
  const packageId = req.query.packageId;
  Package.findOne({
    include: [{ model: User, as: "driver" }],
    attributes: [
      "status",
      "driverComment",
      "receiveDate",
      "deliverDate",
      "driver_userName",
    ],
    where: { packageId: packageId },
  })
    .then((result) => {
      if (result == null) res.status(200).json({ message: "invalid id" });
      else {
        Driver.findOne({ where: { userUserName: result.driver_userName } })
          .then((result2) => {
            res
              .status(200)
              .json({ message: "done", result: result, driver: result2 });
          })
          .catch((err) => {
            console.log(err);
            res.status(500).json({ message: "failed" });
          });
      }
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.getMyLocations = (req, res, next) => {
  const userName = req.query.userName;
  Locations.findAll({
    attributes: ["longTo", "latTo", "location", "name", "id"],
    where: { userName: userName },
  })
    .then((result) => {
      if (result.length != 0)
        return res.status(200).json({ message: "done", result });
      return res.status(404).json({ message: "No locations saved" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.postAddNewLocation = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const locationName = req.body.locationName;
  const locationInfo = req.body.locationInfo;
  const latTo = req.body.latTo;
  const longTo = req.body.longTo;
  Locations.create(
    {
      userName: customerUserName,
      name: locationName,
      location: locationInfo,
      latTo: latTo,
      longTo: longTo,
    },
    {
      include: [userLocation],
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
exports.postDeleteLocation = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  const id = req.body.id;
  Locations.destroy({ where: { userName: customerUserName, id: id } })
    .then((result) => {
      if (result == 1) res.status(200).json({ message: "done" });
      else res.status(500).json({ message: "failed" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};
exports.getTechnicalReports = (req, res, next) => {
  const customerUserName = req.body.customerUserName;
  Technical.findAll({
    where: { userName: customerUserName },
  })
    .then((result) => {
      if (result.length != 0)
        return res.status(200).json({ message: "done", result });
      return res.status(404).json({ message: "There are no reports sent" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};

exports.GetMyNotifications = (req, res, next) => {
  const customerUserName = req.query.customerUserName;
  Notification.findAll({
    where: { noti_userName: customerUserName },
  })
    .then((Notifications) => {
      if (Notifications.length != 0)
        return res.status(200).json({ Notifications });
      return res
        .status(404)
        .json({ message: "There are no Notifications for you" });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ message: "failed" });
    });
};
