// 공통 성공 응답
exports.success = (res, data, status = 200) => {
  return res.status(status).json({
    success: true,
    data
  });
};

// 공통 에러 응답
exports.error = (res, message, status = 400) => {
  return res.status(status).json({
    success: false,
    message
  });
};

// 400 Bad Request
exports.badRequest = (res, message = "잘못된 요청입니다") => {
  return exports.error(res, message, 400);
};

// 401 Unauthorized
exports.unauthorized = (res, message = "인증이 필요합니다") => {
  return exports.error(res, message, 401);
};

// 403 Forbidden
exports.forbidden = (res, message = "접근 권한이 없습니다") => {
  return exports.error(res, message, 403);
};

// 404 Not Found
exports.notFound = (res, message = "리소스를 찾을 수 없습니다") => {
  return exports.error(res, message, 404);
};

// 500 Internal Server Error
exports.serverError = (res, message = "서버 내부 오류 발생") => {
  return exports.error(res, message, 500);
};
