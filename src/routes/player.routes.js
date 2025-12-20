const express = require("express");
const router = express.Router();
const controller = require("../controllers/player.controller");

router.get("/:playerTag", controller.getPlayer);
router.get("/:playerTag/battlelog", controller.getBattleLog);
router.get("/:playerTag/upcomingchests", controller.getUpcomingChests);

module.exports = router;
