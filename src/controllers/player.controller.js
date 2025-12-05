const {
  success,
  notFound,
  serverError,
  badRequest
} = require("../utils/response");

const clashService = require("../services/clash.service");
const summaryService = require("../services/summary.service");

exports.getPlayer = async (req, res) => {
  try {
    const { playerTag } = req.params;

    if (!playerTag) return badRequest(res, "플레이어 태그가 필요합니다");

    const data = await clashService.getPlayer(playerTag);
    if (!data) return notFound(res, "플레이어를 찾을 수 없습니다");

    // summary=true 옵션 처리
    if (req.query.summary === "true") {
      const summarized = summaryService.buildPlayerSummary(data);
      return success(res, summarized);
    }

    return success(res, data);

  } catch (err) {
    console.error(err);
    return serverError(res, "플레이어 정보 조회 중 오류 발생");
  }
};
