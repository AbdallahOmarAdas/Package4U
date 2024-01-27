const { Op, fn } = require("sequelize");
const Sequelize = require("sequelize");
const DailyReport = require("./models/dailyReport");
const Driver = require("./models/driver");

exports.countDriversWorkingToday = async function countDriversWorkingToday() {
  try {
    const todayDay = new Date().toLocaleDateString("en-US", {
      weekday: "long",
    });
    const todayDate = new Date().toISOString().split("T")[0];
    
    const driversWorkingToday = await Driver.count({
      where: {
        workingDays: {
          [Op.like]: `%${todayDay}%`,
        },
        [Sequelize.Op.or]: [
          { notAvailableDate: null },
          { notAvailableDate: { [Sequelize.Op.ne]: todayDate } },
        ],
      },
    });
    return driversWorkingToday;
  } catch (error) {
    console.error(error);
  }
};

exports.updateDailyWorkingDrivers = async function updateDailyWorkingDrivers () {
  console.log(new Date());
  const driversCount = await exports.countDriversWorkingToday();
  await DailyReport.update(
    {
      DriversWorkingToday: driversCount,
    },
    {
      where: {
        [Op.and]: [
          fn("DATE", fn("NOW")),
          Sequelize.where(
            fn("DATE", Sequelize.col("date")),
            "=",
            fn("DATE", new Date())
          ),
        ],
      },
    }
  )
    .then((result) => {
      console.log("DailyReport");
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.createDailyRecord = async function createDailyRecord()  {
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
          totalBalance: i + i, //Math.floor(Math.random() * 100) + 1,
          packageReceivedNumber: i, //Math.floor(Math.random() * 10) + 1,
          packageDeliveredNum: i, //Math.floor(Math.random() * 10) + 1,
          date: date.toISOString().split("T")[0],
          DriversWorkingToday: Math.floor(Math.random() * 10) + 1, // Random number of drivers for demonstration
        });
  
        console.log(`Record added for ${date.toISOString().split("T")[0]}`);
      }
    }
  }