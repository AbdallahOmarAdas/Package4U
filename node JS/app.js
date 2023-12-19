const express = require("express");
const CORS = require("cors");
const feedRoutes = require("./routes/feeds");
const usersRoutes = require("./routes/users");
const driverRoutes = require("./routes/driver");
const Package = require("./models/package");
const Technical = require("./models/technicalMessage");
const managerRoutes = require("./routes/manager");
const customerRoutes = require("./routes/customer");
const bodyParser = require("body-parser");
const sequelize = require("./util/database");
const User = require("./models/users"); //importent to creat the table
const Token = require("./models/token");
const Customer = require("./models/customer");
const Driver = require("./models/driver");
const path = require("path");
const Sequelize = require("sequelize");
const app = express();
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
app.post("/search", (req, res) => {
  res.status(200).json({
    status: 200,
    msg: null,
    results: {
      data: [
        {
          result_type: "geos",
          result_object: {
            location_id: "187147",
            name: "Paris",
            latitude: "48.857037",
            longitude: "2.349401",
            timezone: "Europe/Paris",
            location_string: "Paris, France",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/1c/c2/86/0e/caption.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/1c/c2/86/0e/caption.jpg",
                  height: "50",
                },
                original: {
                  width: "2970",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/1c/c2/86/0e/caption.jpg",
                  height: "3713",
                },
                large: {
                  width: "360",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/1c/c2/86/0e/caption.jpg",
                  height: "450",
                },
                medium: {
                  width: "164",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/1c/c2/86/0e/caption.jpg",
                  height: "205",
                },
              },
              is_blessed: false,
              uploaded_date: "2021-03-19T11:26:28-0400",
              caption: "",
              id: "482510350",
              helpful_votes: "32",
              published_date: "2021-03-19T11:26:28-0400",
              user: null,
            },
            default_options: [
              {
                key: "overview",
                name: "Paris Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
              {
                key: "neighborhoods",
                name: "Neighborhoods",
              },
            ],
            geo_type: "narrow",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: true,
            has_curated_shopping_list: false,
            show_address: true,
            preferred_map_engine: "default",
            description:
              "Paris, inspiring and timeless, is as beautiful as a postcard. Spiraling out from its central islands, its many neighborhoods each have their own character and energy. And the best way to discover their charms is on foot, whether you're strolling the bustling grandeur of the Champs-Elysées or seeking out the final resting place of a favorite figure at Père Lachaise. There's always a café or bakery a few steps away to restore spirits while you explore, or a gorgeously decorated shop window to remind you of this city's love of beauty. Every so often, as you lose yourself down another small street, you’ll glimpse the Eiffel Tower and be instantly reminded why it's so easy to fall in love with the City of Lights.",
            is_localized_description: true,
            ancestors: [
              {
                subcategory: [
                  {
                    key: "region",
                    name: "Region",
                  },
                ],
                name: "Ile-de-France",
                abbrv: null,
                location_id: "187144",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "France",
                abbrv: null,
                location_id: "187070",
              },
            ],
            parent_display_name: "France",
            guide_count: "0",
          },
          scope: "local",
        },
        {
          result_type: "geos",
          result_object: {
            location_id: "2079053",
            name: "Disneyland Paris",
            latitude: "48.86896",
            longitude: "2.783808",
            timezone: "Europe/Paris",
            location_string: "Disneyland Paris, France",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/13/34/d7/64/disneyland-paris.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/13/34/d7/64/disneyland-paris.jpg",
                  height: "50",
                },
                original: {
                  width: "648",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/13/34/d7/64/disneyland-paris.jpg",
                  height: "1152",
                },
                large: {
                  width: "253",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/13/34/d7/64/disneyland-paris.jpg",
                  height: "450",
                },
                medium: {
                  width: "115",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/13/34/d7/64/disneyland-paris.jpg",
                  height: "205",
                },
              },
              is_blessed: false,
              uploaded_date: "2018-06-07T15:17:15-0400",
              caption: "Disneyland Paris",
              id: "322230116",
              helpful_votes: "9",
              published_date: "2018-06-07T15:17:15-0400",
              user: {
                user_id: null,
                member_id: "0",
                type: "user",
              },
            },
            default_options: [
              {
                key: "overview",
                name: "Disneyland Paris Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
            ],
            geo_type: "narrow",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: false,
            has_curated_shopping_list: false,
            show_address: false,
            preferred_map_engine: "default",
            description: "",
            ancestors: [
              {
                subcategory: [
                  {
                    key: "region",
                    name: "Region",
                  },
                ],
                name: "Ile-de-France",
                abbrv: null,
                location_id: "187144",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "France",
                abbrv: null,
                location_id: "187070",
              },
            ],
            parent_display_name: "France",
            guide_count: "0",
          },
          scope: "local",
        },
        {
          result_type: "geos",
          result_object: {
            location_id: "3458458",
            name: "Portland Parish",
            latitude: "18.09495",
            longitude: "-76.47194",
            timezone: "America/Jamaica",
            location_string: "Portland Parish, Jamaica",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/05/48/5e/dd/reach-falls.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/05/48/5e/dd/reach-falls.jpg",
                  height: "50",
                },
                original: {
                  width: "1280",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/05/48/5e/dd/reach-falls.jpg",
                  height: "960",
                },
                large: {
                  width: "550",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/05/48/5e/dd/reach-falls.jpg",
                  height: "412",
                },
                medium: {
                  width: "250",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/05/48/5e/dd/reach-falls.jpg",
                  height: "187",
                },
              },
              is_blessed: false,
              uploaded_date: "2014-01-22T10:00:35-0500",
              caption: "view on way from Port Antonio",
              id: "88628957",
              helpful_votes: "13",
              published_date: "2014-01-22T10:00:35-0500",
              user: {
                user_id: null,
                member_id: "0",
                type: "user",
              },
            },
            default_options: [
              {
                key: "overview",
                name: "Portland Parish Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
            ],
            geo_type: "hybrid",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: true,
            has_curated_shopping_list: false,
            show_address: false,
            preferred_map_engine: "default",
            description: "",
            ancestors: [
              {
                subcategory: [
                  {
                    key: "island",
                    name: "Island",
                  },
                ],
                name: "Jamaica",
                abbrv: null,
                location_id: "147309",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "Caribbean",
                abbrv: null,
                location_id: "147237",
              },
            ],
            parent_display_name: "Jamaica",
            guide_count: "0",
          },
          scope: "local",
        },
        {
          result_type: "geos",
          result_object: {
            location_id: "56424",
            name: "Paris",
            latitude: "33.660763",
            longitude: "-95.557755",
            timezone: "America/Chicago",
            location_string: "Paris, Texas",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/10/51/88/d1/20170804-122339-largejpg.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/10/51/88/d1/20170804-122339-largejpg.jpg",
                  height: "50",
                },
                original: {
                  width: "3264",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/10/51/88/d1/20170804-122339-largejpg.jpg",
                  height: "1836",
                },
                large: {
                  width: "550",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/10/51/88/d1/20170804-122339-largejpg.jpg",
                  height: "309",
                },
                medium: {
                  width: "250",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/10/51/88/d1/20170804-122339-largejpg.jpg",
                  height: "141",
                },
              },
              is_blessed: false,
              uploaded_date: "2017-08-17T18:59:59-0400",
              caption: "",
              id: "273778897",
              helpful_votes: "34",
              published_date: "2017-08-17T18:59:59-0400",
              user: {
                user_id: null,
                member_id: "0",
                type: "user",
              },
            },
            default_options: [
              {
                key: "overview",
                name: "Paris Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
            ],
            geo_type: "narrow",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: true,
            has_curated_shopping_list: false,
            show_address: true,
            preferred_map_engine: "default",
            description: "",
            ancestors: [
              {
                subcategory: [
                  {
                    key: "state",
                    name: "State",
                  },
                ],
                name: "Texas",
                abbrv: "TX",
                location_id: "28964",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "United States",
                abbrv: null,
                location_id: "191",
              },
            ],
            parent_display_name: "Texas",
            guide_count: "0",
          },
          scope: "local",
        },
        {
          result_type: "geos",
          result_object: {
            location_id: "55260",
            name: "Paris",
            latitude: "36.30189",
            longitude: "-88.32588",
            timezone: "America/Chicago",
            location_string: "Paris, Tennessee",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/13/7e/a9/3f/photo0jpg.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/13/7e/a9/3f/photo0jpg.jpg",
                  height: "50",
                },
                original: {
                  width: "2048",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/13/7e/a9/3f/photo0jpg.jpg",
                  height: "2048",
                },
                large: {
                  width: "450",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/13/7e/a9/3f/photo0jpg.jpg",
                  height: "450",
                },
                medium: {
                  width: "205",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/13/7e/a9/3f/photo0jpg.jpg",
                  height: "205",
                },
              },
              is_blessed: false,
              uploaded_date: "2018-06-27T12:00:11-0400",
              caption: "",
              id: "327067967",
              helpful_votes: "3",
              published_date: "2018-06-27T12:00:11-0400",
              user: {
                user_id: null,
                member_id: "0",
                type: "user",
              },
            },
            default_options: [
              {
                key: "overview",
                name: "Paris Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
            ],
            geo_type: "narrow",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: false,
            has_curated_shopping_list: false,
            show_address: true,
            preferred_map_engine: "default",
            description: "",
            ancestors: [
              {
                subcategory: [
                  {
                    key: "state",
                    name: "State",
                  },
                ],
                name: "Tennessee",
                abbrv: "TN",
                location_id: "28963",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "United States",
                abbrv: null,
                location_id: "191",
              },
            ],
            parent_display_name: "Tennessee",
            guide_count: "0",
          },
          scope: "local",
        },
        {
          result_type: "geos",
          result_object: {
            location_id: "3458460",
            name: "Saint Ann Parish",
            latitude: "18.32715",
            longitude: "-77.22725",
            timezone: "America/Jamaica",
            location_string: "Saint Ann Parish, Jamaica",
            photo: {
              images: {
                small: {
                  width: "150",
                  url: "https://media-cdn.tripadvisor.com/media/photo-l/11/48/0f/a6/photo1jpg.jpg",
                  height: "150",
                },
                thumbnail: {
                  width: "50",
                  url: "https://media-cdn.tripadvisor.com/media/photo-t/11/48/0f/a6/photo1jpg.jpg",
                  height: "50",
                },
                original: {
                  width: "2048",
                  url: "https://media-cdn.tripadvisor.com/media/photo-o/11/48/0f/a6/photo1jpg.jpg",
                  height: "1536",
                },
                large: {
                  width: "550",
                  url: "https://media-cdn.tripadvisor.com/media/photo-s/11/48/0f/a6/photo1jpg.jpg",
                  height: "413",
                },
                medium: {
                  width: "250",
                  url: "https://media-cdn.tripadvisor.com/media/photo-f/11/48/0f/a6/photo1jpg.jpg",
                  height: "188",
                },
              },
              is_blessed: false,
              uploaded_date: "2017-11-15T13:08:37-0500",
              caption: "",
              id: "289935270",
              helpful_votes: "17",
              published_date: "2017-11-15T13:08:37-0500",
              user: {
                user_id: null,
                member_id: "0",
                type: "user",
              },
            },
            default_options: [
              {
                key: "overview",
                name: "Saint Ann Parish Overview",
              },
              {
                key: "restaurants",
                name: "Restaurants",
              },
              {
                key: "things_to_do",
                name: "Things to Do",
              },
              {
                key: "lodging",
                name: "Hotels",
              },
              {
                key: "vacation_rentals",
                name: "Vacation Rentals",
              },
              {
                key: "flights_to",
                name: "Flights",
              },
            ],
            geo_type: "hybrid",
            location_subtype: "none",
            has_restaurant_coverpage: true,
            has_attraction_coverpage: true,
            has_curated_shopping_list: false,
            show_address: false,
            preferred_map_engine: "default",
            description: "",
            ancestors: [
              {
                subcategory: [
                  {
                    key: "island",
                    name: "Island",
                  },
                ],
                name: "Jamaica",
                abbrv: null,
                location_id: "147309",
              },
              {
                subcategory: [
                  {
                    key: "country",
                    name: "Country",
                  },
                ],
                name: "Caribbean",
                abbrv: null,
                location_id: "147237",
              },
            ],
            parent_display_name: "Jamaica",
            guide_count: "0",
          },
          scope: "local",
        },
      ],
      partial_content: false,
    },
  });
});
app.use("/feed", feedRoutes);
app.use("/users", usersRoutes);
app.use("/manager", managerRoutes);
app.use("/driver", driverRoutes);
app.use("/customer", customerRoutes);
app.use("/image", express.static(path.join(__dirname, "user_images")));
app.use("/image", (req, res, next) => {
  res
    .status(200)
    .sendFile(path.join(__dirname, "user_images", "__@@__33&default.jpg"));
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
