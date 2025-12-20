const express = require("express");
const router = express.Router();
const controller = require("../controllers/player.controller");

// 구체적인 라우트를 먼저 정의 (중요!)
router.get("/:playerTag/battlelog", controller.getBattleLog);
router.get("/:playerTag/upcomingchests", controller.getUpcomingChests);
router.get("/:playerTag", controller.getPlayer);

module.exports = router;
