const express = require("express");
const router = express.Router();
const controller = require("../controllers/player.controller");

router.get("/:playerTag", controller.getPlayer);

module.exports = router;
