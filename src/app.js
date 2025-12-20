const express = require("express");
const cors = require("cors");
const path = require("path");

const playerRoutes = require("./routes/player.routes");
const battleRoutes = require("./routes/battle.routes");

const app = express();

app.use(cors());
app.use(express.json());

// API 라우트
app.get("/api/v1/health", (req, res) => res.json({ status: "ok" }));
app.use("/api/v1/players", playerRoutes);
app.use("/api/v1/battles", battleRoutes);

// 프론트엔드 정적 파일 서빙
app.use(express.static(path.join(__dirname, "../frontend/build/web")));

// 모든 나머지 요청은 index.html로
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "../frontend/build/web/index.html"));
});

module.exports = app;
