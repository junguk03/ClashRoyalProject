Clash Royale API Project

클래시 로얄 플레이어 정보 및 전투 기록 조회 서비스


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


프로젝트 소개

Supercell Clash Royale API를 활용한 플레이어 통계 조회 서비스입니다.
Flutter 웹 프론트엔드와 Node.js Express 백엔드로 구성되어 있습니다.


기술 스택

Backend
  Node.js 20.x
  Express.js 5.2.1
  Axios 1.13.2
  dotenv

Frontend
  Flutter Web
  Dart
  GetX (상태 관리)


주요 기능

  플레이어 정보 조회 (트로피, 레벨, 승률)
  전투 기록 조회
  다가오는 상자 정보
  클랜 정보


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


시작하기


STEP 1  Supercell API 키 발급

https://developer.clashroyale.com 접속
  계정 생성 및 로그인
  My Account → Create New Key
  IP Address: 본인의 공인 IP 입력 (curl https://api.ipify.org 로 확인)
  API 키 복사 (재확인 불가하니 안전한 곳에 보관)


STEP 2  백엔드 설치 및 실행

git clone <repository-url>
cd ClashRoyalProject
npm install

루트 디렉토리에 .env 파일 생성:

SUPERCELL_API_KEY=your_api_key_here
PORT=3000

서버 실행:

node src/server.js


STEP 3  프론트엔드 설치 및 실행

cd frontend
flutter pub get

frontend 디렉토리에 .env 파일 생성:

API_BASE_URL=http://localhost:3000/api/v1

앱 실행:

flutter run -d chrome


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


API 엔드포인트


Health Check
GET /api/v1/health

응답: { "status": "ok" }


Player Info
GET /api/v1/players/:playerTag

예시: GET /api/v1/players/9CQ2U8QJ

응답:
{
  "success": true,
  "data": {
    "tag": "#9CQ2U8QJ",
    "name": "PlayerName",
    "trophies": 5000,
    ...
  }
}


Battle Log
GET /api/v1/players/:playerTag/battlelog

최근 25개의 전투 기록 반환


Upcoming Chests
GET /api/v1/players/:playerTag/upcomingchests

다가오는 상자 목록 반환


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


문제 해결


포트 이미 사용 중

lsof -i :3000
kill -9 <PID>


API 403 Forbidden 에러

Supercell API 키의 IP 주소가 현재 IP와 일치하는지 확인
개발자 포털에서 IP 재설정 필요


Flutter 타입 에러

ApiClient에서 백엔드 응답의 data 필드를 제대로 추출하는지 확인
모델의 타입이 실제 API 응답과 일치하는지 확인


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


주요 수정 사항

프로젝트 개발 중 해결한 주요 이슈들입니다.


Issue 1  IP Whitelist

문제: 0.0.0.0으로 설정해도 403 에러 발생
해결: 실제 공인 IP를 API 키에 등록 (CIDR 표기법 0.0.0.0/0 시도 가능)


Issue 2  API Response Parsing

문제: Flutter에서 _JsonMap is not a subtype of String 에러
해결:
  ApiClient에서 data 필드 추출 로직 추가
  PlayerBadge.iconUrls 타입을 String에서 dynamic으로 변경


Issue 3  Express Route Order

문제: /players/:playerTag/upcomingchests 호출 시 404 에러
해결: 구체적인 라우트를 일반 라우트보다 먼저 정의

올바른 순서:
router.get("/:playerTag/battlelog", ...)
router.get("/:playerTag/upcomingchests", ...)
router.get("/:playerTag", ...)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


프로젝트 구조

ClashRoyalProject/
  src/
    config/        API 설정
    controllers/   요청 처리
    routes/        라우트 정의
    services/      비즈니스 로직
    utils/         유틸리티
    app.js         Express 앱
    server.js      서버 진입점

  frontend/
    lib/
      app/
        api/       API 클라이언트
        feature/   화면별 기능
        routes/    라우팅
    build/web/     빌드 결과물

  .env             환경변수 (gitignore)
  package.json     의존성 관리


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


참고 자료

Clash Royale API: https://developer.clashroyale.com/api-docs
Express.js: https://expressjs.com
Flutter: https://flutter.dev
