console.log("SUPERCELL_API_KEY loaded:", !!process.env.SUPERCELL_API_KEY, process.env.SUPERCELL_API_KEY?.slice(0,6) + "..." + process.env.SUPERCELL_API_KEY?.slice(-6));

const axios = require("axios");

const clashApi = axios.create({
  baseURL: "https://api.clashroyale.com/v1",
  timeout: 5000,
  headers: {
    Authorization: `Bearer ${process.env.SUPERCELL_API_KEY}`,
  },
});

module.exports = clashApi;