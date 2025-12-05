const clashApi = require("../config/axios");

exports.getPlayer = async (tag) => {
  const res = await clashApi.get(`/players/%23${tag}`);
  return res.data;
};

exports.getBattleLog = async (tag) => {
  const res = await clashApi.get(`/players/%23${tag}/battlelog`);
  return res.data;
};