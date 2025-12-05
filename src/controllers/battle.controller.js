const clash = require("../services/clash.service");
const summary = require("../services/summary.service");

exports.getBattleLog = async (req, res) => {
  try {
    const { tag } = req.params;

    const data = await clash.getBattleLog(tag);

    if (req.query.summary === "true") {
      return res.json(data.map(summary.buildBattleSummary));
    }

    return res.json(data);

  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: "배틀 로그를 가져올 수 없습니다",
    });
  }
};
