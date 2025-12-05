const express = require("express");
const cors = require("cors");

const playerRoutes = require("./routes/player.routes");
const battleRoutes = require("./routes/battle.routes");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/v1/health", (req, res) => res.json({ status: "ok" }));

app.use("/api/v1/players", playerRoutes);
app.use("/api/v1/battles", battleRoutes);

module.exports = app;
