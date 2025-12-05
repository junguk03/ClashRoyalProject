const express = require("express");
const router = express.Router();
const controller = require("../controllers/player.controller");

router.get("/:tag", controller.getPlayer);

module.exports = router;
