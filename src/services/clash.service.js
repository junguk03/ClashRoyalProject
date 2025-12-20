const clashApi = require("../config/axios");

// 플레이어 정보 조회
exports.getPlayer = async (tag) => {
  const cleanTag = tag.replace("#", "");
  const res = await clashApi.get(`/players/%23${cleanTag}`);
  return res.data;
};

// 배틀로그 조회
exports.getBattleLog = async (tag) => {
  const cleanTag = tag.replace("#", "");
  const res = await clashApi.get(`/players/%23${cleanTag}/battlelog`);
  return res.data;
};

// 다가오는 상자 조회
exports.getUpcomingChests = async (tag) => {
  const cleanTag = tag.replace("#", "");
  const res = await clashApi.get(`/players/%23${cleanTag}/upcomingchests`);
  return res.data;
};
