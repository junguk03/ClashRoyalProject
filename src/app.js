const express = require("express");
const cors = require("cors");

const playerRoutes = require("./routes/player.routes");
const battleRoutes = require("./routes/battle.routes");

const app = express();

app.use(cors());
app.use(express.json());

// API 라우트
app.get("/api/v1/health", (req, res) => res.json({ status: "ok" }));
app.use("/api/v1/players", playerRoutes);
app.use("/api/v1/battles", battleRoutes);

// Lambda에서는 정적 파일 서빙 불필요 (프론트엔드는 별도 호스팅)

module.exports = app;
