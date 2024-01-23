const express = require("express");
const CORS = require("cors");
const schedule = require("node-schedule");
const feedRoutes = require("./routes/feeds");
const usersRoutes = require("./routes/users");
const driverRoutes = require("./routes/driver");
const Package = require("./models/package");
const Technical = require("./models/technicalMessage");
const managerRoutes = require("./routes/manager");
const customerRoutes = require("./routes/customer");
const employeeRoutes = require("./routes/employee");
const adminRoutes = require("./routes/admin");
const bodyParser = require("body-parser");
const sequelize = require("./util/database");
const notification = require("./util/notifications");
const User = require("./models/users"); //importent to creat the table
const Token = require("./models/token");
const Notification = require("./models/nofification");
const Customer = require("./models/customer");
const Driver = require("./models/driver");
const DailyReport = require("./models/dailyReport");
const path = require("path");
const Sequelize = require("sequelize");
const app = express();
const admin = require("firebase-admin");
//const serviceAccount = require("./package4u-326de-firebase-adminsdk-4qrk9-3884981a46.json");
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });
//const messaging = admin.messaging();
//app.use(bodyParser.urlencoded());//used in html form x-www-form-urlencoded
app.use(bodyParser.json());
app.use(CORS());
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "OPTIONS, GET, POST, PUT, PATCH, DELETE"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});

app.use("/send", (req, res, next) => {
  notification.SendPackageNotification("Delivered", 8);
  res.status(200).json({ message: "donee" });
});
app.use("/feed", feedRoutes);
app.use("/users", usersRoutes);
app.use("/manager", managerRoutes);
app.use("/driver", driverRoutes);
app.use("/customer", customerRoutes);
app.use("/employee", employeeRoutes);
app.use("/admin", adminRoutes);
app.use("/image", express.static(path.join(__dirname, "user_images")));
app.use("/image", (req, res, next) => {
  res
    .status(200)
    .sendFile(path.join(__dirname, "user_images", "__@@__33&default.jpg"));
});
const createDailyRecord = async () => {
  try {
    const currentDate = new Date();
    const today = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1)
      .toString()
      .padStart(2, "0")}-${currentDate.getDate().toString().padStart(2, "0")}`;

    const dailyReport = await DailyReport.create({
      date: today, //.toISOString().split('T')[0], // Set the date to the current date
      comment: "",
      totalBalance: 0,
      packageReceivedNumber: 0,
      packageDeliveredNum: 0,
      DriversWorkingToday: 0,
    });

    console.log("Daily record created:", dailyReport.toJSON());
  } catch (error) {
    console.error("Error creating daily record:", error);
  }
};
schedule.scheduleJob("1 0 * * *", () => {
  try {
    createDailyRecord();
  } catch (error) {
    console.error("Error in scheduled job:", error);
  }
});
sequelize
  .sync({ force: false })
  .then((result) => {
    //console.log(result);
    app.listen(8080);
  })
  .catch((err) => {
    console.log(err);
  });

//notification.SendPackageNotification("Under review", 28);
// // notification.SendNotification(
// //   "notification.titlePindingToCustomer",
// //   "A new package has been created for you. The package is currently under review",
// //   "This Packade for you",
// //
// //   "abdallahC",
// //
// // );
//addRecordsForPastMonths();
async function addRecordsForPastMonths() {
  const today = new Date();

  for (let i = 1; i <= 1; i++) {
    const year = today.getFullYear();
    const month = today.getMonth();

    // Calculate the number of days in the month
    const lastDayOfMonth = new Date(year, month + 1, 0).getDate();

    for (let day = 1; day <= 24; day++) {
      const date = new Date(year, month, day);

      // Use the create method to add a record
      await DailyReport.create({
        comment: "",
        totalBalance: i+i,//Math.floor(Math.random() * 100) + 1,
        packageReceivedNumber:  i,//Math.floor(Math.random() * 10) + 1,
        packageDeliveredNum: i,//Math.floor(Math.random() * 10) + 1,
        date: date.toISOString().split("T")[0],
        DriversWorkingToday: Math.floor(Math.random() * 10) + 1, // Random number of drivers for demonstration
      });

      console.log(`Record added for ${date.toISOString().split("T")[0]}`);
    }
  }
}
