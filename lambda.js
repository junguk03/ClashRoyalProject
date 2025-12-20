require("dotenv").config();
const serverless = require("serverless-http");
const app = require("./src/app");

// Lambda 핸들러
module.exports.handler = serverless(app);
