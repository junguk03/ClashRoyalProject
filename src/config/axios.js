const axios = require("axios");

const clashApi = axios.create({
  baseURL: "https://api.clashroyale.com/v1",
  timeout: 5000,
  headers: {
    Authorization: `Bearer ${process.env.SUPERCELL_API_KEY}`,
  },
});

module.exports = clashApi;