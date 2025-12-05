const clash = require("../services/clash.service");
const summary = require("../services/summary.service");

exports.getPlayer = async (req, res) => {
  try {
    const tag = req.params.tag.replace("#", "");
    const data = await clash.getPlayer(tag);

    if (req.query.summary === "true") {
      return res.json(summary.buildPlayerSummary(data));
    }

    res.json(data);
  } catch (err) {
    res.status(404).json({ success: false, message: "플레이어를 찾을 수 없습니다" });
  }
};
