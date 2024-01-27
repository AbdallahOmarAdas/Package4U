const express = require("express");
const CORS = require("cors");
const schedule = require("node-schedule");
const feedRoutes = require("./routes/feeds");
const usersRoutes = require("./routes/users");
const driverRoutes = require("./routes/driver");
const Package = require("./models/package");
const PackagePrice = require("./models/packagePrice");
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
const { Op, fn } = require("sequelize");
const appFunctions = require("./appFunctions");

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
app.use("/technicalImage", express.static(path.join(__dirname, "technicalReporesScreenshots")));
app.use("/image", (req, res, next) => {
  res
    .status(200)
    .sendFile(path.join(__dirname, "user_images", "__@@__33&default.jpg"));
});

schedule.scheduleJob("1 0 * * *", () => {
  try {
    appFunctions.createDailyRecord();
  } catch (error) {
    console.error("Error in scheduled job:", error);
  }
});

schedule.scheduleJob("44 23 * * *", () => {
  try {
    appFunctions.updateDailyWorkingDrivers();
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
