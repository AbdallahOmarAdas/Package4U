const axios = require("axios");
const Notification = require("../models/nofification");
const User = require("../models/users");
const Package = require("../models/package");

exports.titledeliverd = "Package Delivered";
exports.titlePindingFromCustomer = "You Create new package";
exports.titlePindingToCustomer = "New Package for you";
const Sequelize = require("sequelize");

const userNoti = Notification.belongsTo(User, {
  foreignKey: "noti_userName",
  onDelete: "CASCADE",
  as: "noti_user",
});
User.hasMany(Notification, { foreignKey: "noti_userName" });

const packageNoti = Notification.belongsTo(Package, {
  foreignKey: "noti_packageId",
  onDelete: "CASCADE",
  as: "noti_package",
});
Package.hasMany(Notification, { foreignKey: "noti_packageId" });

// const user = Package.belongsTo(User, {
//   foreignKey: "rec_userName",
//   onDelete: "CASCADE",
//   as: "rec_user",
// });
// User.hasMany(Package, { foreignKey: "rec_userName" });

// const user2 = Package.belongsTo(User, {
//   foreignKey: "send_userName",
//   onDelete: "CASCADE",
//   as: "send_user",
// });
// User.hasMany(Package, { foreignKey: "send_userName" });

exports.SendPackageNotification = (status, packageId) => {
  let title, body;
  if (status == "Delivered") {
    title = "Pacakge Delivered";
    body = `Your Package number ${packageId} has been delivered`;
  } else {
    title = "hhhhh";
    body = `hhhhh Package number ${packageId} has been delivered`;
  }
  Package.findOne({
    include: [
      {
        model: User,
        as: "rec_user",
        attributes: ["Fname", "Lname", "NotificationToken"],
      },
      {
        model: User,
        as: "send_user",
        attributes: ["Fname", "Lname", "NotificationToken"],
      },
    ],
    attributes: ["send_userName", "rec_userName"],
    where: { packageId: packageId },
  })
    .then((result) => {
      console.log(result);
      const noteFrom = `Note: this package from you to ${result.rec_user.Fname} ${result.rec_user.Lname}`;
      const noteFor = `Note: this package for you from ${result.send_user.Fname} ${result.send_user.Lname}`;
      const dataToSend1 = preperData(
        title,
        body,
        result.rec_user.NotificationToken
      );
      const dataToSend2 = preperData(
        title,
        body,
        result.send_user.NotificationToken
      );
      const config1 = prpereConfig(dataToSend1);
      const config2 = prpereConfig(dataToSend2);
      sendNoti(
        config1,
        title,
        body,
        noteFrom,
        status,
        result.send_userName,
        packageId
      );
      sendNoti(
        config2,
        title,
        body,
        noteFor,
        status,
        result.rec_userName,
        packageId
      );
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.SendNotification = (title, body, note, status, sendTo, packageId) => {
  process.env.TZ = "UTC";
  let token;
  User.findOne({ where: { userName: sendTo } })
    .then((result) => {
      token = result.NotificationToken;
      let data = JSON.stringify({
        "notification": {
          "title": title,
          "text": " ",
          "body": body,
          // click_action: "FLUTTER_NOTIFICATION_CLICK",,
          "click_action": "FLUTTER_NOTIFICATION_CLICK", // This is important for opening the app
          //'default_notification_channel_id': 'default_channel_id',
          //click_action: "OPEN_ACTIVITY_1",
        },
         "data": {
        //   key: "value",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        //   // click_action: "FLUTTER_NOTIFICATION_CLICK",
        //   // default_notification_channel_id: "com.example.Package4U",
         },
        to: token,
      });
      let config = {
        method: "post",
        maxBodyLength: Infinity,
        url: "https://fcm.googleapis.com/fcm/send",
        headers: {
          "Content-Type": "application/json",
          Authorization:
            "key=AAAA4SCLSDA:APA91bEyHZju04v8GYoKsiKrrPo7lqqG8zMSOVjeKYOoMQeycgIvwDUzn6rKxNq3wPVBRg_kLzCs_4-RajgVM6_eJDuAgb0_vVlXC843yg6C1XBFUggNw_M0NXIyZTEan0Uyn4ErVn40",
        },
        data: data,
      };
      axios
        .request(config)
        .then((response) => {
          Notification.create(
            {
              title: title,
              body: body,
              note: note,
              status: status,
              dateTime: Sequelize.fn("NOW"),
              noti_userName: sendTo,
              noti_packageId: packageId,
            },
            {
              include: [userNoti, packageNoti],
            }
          )
            .then((result) => {})
            .catch((err) => {
              console.log(err);
            });

          console.log(JSON.stringify(response.data));
        })
        .catch((error) => {
          console.log(error);
        });
    })
    .catch((err) => {
      console.log(err);
    });
};

function preperData(title, body, token) {
  let data = JSON.stringify({
    notification: {
      title: title,
      text: " ",
      body: body,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
    },
    data: {
      key: "value",
    },
    to: token,
  });
  return data;
}

function prpereConfig(data) {
  let config = {
    method: "post",
    maxBodyLength: Infinity,
    url: "https://fcm.googleapis.com/fcm/send",
    headers: {
      "Content-Type": "application/json",
      Authorization:
        "key=AAAA4SCLSDA:APA91bEyHZju04v8GYoKsiKrrPo7lqqG8zMSOVjeKYOoMQeycgIvwDUzn6rKxNq3wPVBRg_kLzCs_4-RajgVM6_eJDuAgb0_vVlXC843yg6C1XBFUggNw_M0NXIyZTEan0Uyn4ErVn40",
    },
    data: data,
  };
  return config;
}

function sendNoti(config, title, body, note, status, sendTo, packageId) {
  axios
    .request(config)
    .then((response) => {
      Notification.create(
        {
          title: title,
          body: body,
          note: note,
          status: status,
          dateTime: Sequelize.fn("NOW"),
          noti_userName: sendTo,
          noti_packageId: packageId,
        },
        {
          include: [userNoti, packageNoti],
        }
      )
        .then((result) => {})
        .catch((err) => {
          console.log(err);
        });

      console.log(JSON.stringify(response.data));
    })
    .catch((error) => {
      console.log(error);
    });
}

exports.Under_review = "Under review";
exports.Accepted = "Accepted";
exports.Wait_Driver = "Wait Driver";
exports.In_Warehouse = "In Warehouse";
exports.With_Driver = "With Driver";
exports.Delivered = "Delivered";
exports.Rejected_by_driver = "Rejected";
