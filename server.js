const express = require("express");
const axios = require("axios");
const dotenv = require("dotenv");
const cors = require("cors");

dotenv.config();
const app = express();
app.use(cors());

const API_KEY = process.env.CLASH_API_KEY;
const PORT = process.env.PORT || 3000;

const clashApi = axios.create({
  baseURL: "https://api.clashroyale.com/v1",
  headers: { Authorization: `Bearer ${API_KEY}` }
});

// 1) 서버 상태 체크
app.get("/api/v1/health", (req, res) => {
  res.json({
    success: true,
    data: { status: "ok", service: "clash-royale-api" }
  });
});

// 2) 플레이어 정보 조회
app.get("/api/v1/players/:tag", async (req, res) => {
  try {
    const tag = req.params.tag.replace("#", "");
    const response = await clashApi.get(`/players/%23${tag}`);

    res.json({
      success: true,
      data: response.data
    });
  } catch (err) {
    res.status(404).json({
      success: false,
      message: "플레이어를 찾을 수 없습니다"
    });
  }
});

// 3) 배틀 로그 조회
app.get("/api/v1/players/:tag/battlelog", async (req, res) => {
  try {
    const tag = req.params.tag.replace("#", "");
    const response = await clashApi.get(`/players/%23${tag}/battlelog`);

    res.json({
      success: true,
      data: response.data
    });
  } catch (err) {
    res.status(404).json({
      success: false,
      message: "배틀 로그를 불러올 수 없습니다"
    });
  }
});

// 서버 실행
app.listen(PORT, () => {
  console.log(`Server Running on http://localhost:${PORT}`);
});
