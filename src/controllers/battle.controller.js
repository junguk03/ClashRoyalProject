const clash = require("../services/clash.service");
const summary = require("../services/summary.service");

exports.getBattleLog = async (req, res) => {
  try {
    const tag = req.params.tag.replace("#", "");
    const data = await clash.getBattleLog(tag);

    if (req.query.summary === "true") {
      return res.json(data.map(summary.buildBattleSummary));
    }

    res.json(data);
  } catch (err) {
    res.status(404).json({ success: false, message: "배틀 로그를 가져올 수 없습니다" });
  }
};
