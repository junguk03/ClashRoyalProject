const express = require("express");
const router = express.Router();
const controller = require("../controllers/battle.controller");

router.get("/:tag", controller.getBattleLog);

module.exports = router;
