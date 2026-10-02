# 나 뭐라고 보낼까? (WsIr) 💬
> **"한국어 고맥락 메신저를 위한 초개인화 AI 커뮤니케이션 코-파일럿"**  
> 텍스트와 카카오톡 캡처 화면 이면의 심리와 서브텍스트를 해독하고, 상황과 위계에 딱 맞는 최적의 답장을 추천합니다.

[![Engine Status](https://img.shields.io/badge/Engine-v7.0%20Latest-4EE0CB?style=for-the-badge&logo=flutter&logoColor=white)]()
[![LLM Architecture](https://img.shields.io/badge/LLM-Google%20Gemini%203.8%20Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)
[![GitHub Repo](https://img.shields.io/badge/GitHub-WsIr%20Repository-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/489156/WsIr)
[![License](https://img.shields.io/badge/License-Proprietary-yellow?style=for-the-badge)]()

---

## 📌 Executive Summary (프로젝트 현황)

**'나 뭐라고 보낼까? (WsIr)'**는 카카오톡, 슬랙 등 일상과 직장에서 오가는 고맥락(High-context) 한국어 메신저 대화의 감정 소모와 답장 스트레스를 해결하기 위해 구축된 **AI 메신저 코파일럿 서비스**입니다.

현재 저장소에는 다음 3가지 핵심 모듈이 온전히 구비되어 즉시 실행 및 배포가 가능합니다:
1. **웹 프로토타입 (`index.html`)**: 설치 없이 브라우저에서 즉시 체험 가능한 독립형 고기능 SPA (Zero-Retention & BYOK 지원).
2. **모바일 크로스 플랫폼 앱 (`wsir_app/`)**: Flutter 기반으로 구축된 MVVM + Repository 아키텍처의 정규 모바일 앱 (iOS / Android).
3. **보안 프록시 서버 (`wsir_proxy/`)**: Google GenAI 공식 SDK 및 Gemini 3.8 Flash 기반으로 API Key를 안전하게 격리하고 프롬프트를 중앙 제어하는 Node.js 백엔드.

---

## ⚡ 핵심 기능 및 고맥락 대응 차별점 (Core Features)

```
┌────────────────────────────────────────────────────────────────────────┐
│                        WsIr 6대 핵심 기술적 차별점                       │
├─────────────────────┬──────────────────────────────────────────────────┤
│ ⚡ Wow Point         │ 상대방의 결핍을 선제 해소하는 허를 찌르는 전략 답장  │
├─────────────────────┼──────────────────────────────────────────────────┤
│ 👥 한국형 14대 관계  │ 시댁/처가, 외주/프리랜서, 소개팅/썸, 상사 등 위계 반영│
├─────────────────────┼──────────────────────────────────────────────────┤
│ 🎨 원클릭 톤 조절기   │ 더 정중하게 / 단호하게 / MZ 스타일 / 다정하게 실시간 재작성 │
├─────────────────────┼──────────────────────────────────────────────────┤
│ 💬 연속 대화 (Multi) │ '대화 이어가기' 버튼으로 티키타카 문맥 100% 누적 반영 │
├─────────────────────┼──────────────────────────────────────────────────┤
│ 📸 비전 스크린샷 판독 │ 말풍선 배치, 답장 시간차(텀), 카톡 '1' 유무 종합 분석  │
├─────────────────────┼──────────────────────────────────────────────────┤
│ 🔒 Zero-Retention   │ 인메모리 처리 후 즉시 폐기, 대화 원문 서버 비저장     │
└─────────────────────┴──────────────────────────────────────────────────┘
```

### 1) ⚡ Wow Point: "상대방의 숨은 결핍을 선제 해소하는 전략"
단순히 "네 알겠습니다" 식의 수동적인 답변을 넘어, 상대방의 진짜 심리(불안, 시간 압박, 인정 욕구)를 꿰뚫어 주도권을 쥐는 1개의 전략적 답장을 제공합니다.
* **상황**: *"이거 언제까지 가능해? 클라이언트에서 빨리 달라고 하네"*
* ❌ *일반 답장*: "내일 오전까지 하겠습니다."
* ⚡ *Wow Point*: **"오늘 밤 11시까지 핵심 초안 먼저 넘겨드리고, 내일 오전 클라이언트 출근 전 피드백 반영해 최종본 올리겠습니다. 가장 급한 항목부터 말씀해 주시면 우선순위 두고 먼저 잡겠습니다."**

### 2) 👥 한국형 14대 관계 프리셋 (Speech Levels & Nuance Rules)
상대방과의 관계에 따라 시스템 프롬프트에 `KOREAN_RELATION_RULES`가 동적으로 주입됩니다:
* 🙇‍♀️ **시댁 / 처가 어른 (`inlaws`)**: 오해 소지를 원천 차단하는 극도의 정중함과 쿠션어(`"아버님 바쁘지 않으시면~"`) 필수 적용.
* 🎨 **프리랜서 / 외주 클라이언트 (`freelance`)**: 감정 노동을 배제한 철저한 비즈니스 톤 및 계약적·법적 방어선 구축.
* 🥂 **소개팅 / 썸 (`blind_date`)**: 부담스럽지 않은 선의 호감 표현과 티키타카를 유도하는 세련된 해요체.
* 👔 **직장 상사 (`boss`)**: 결론부터 보고하는 두괄식 보고와 깍듯한 합쇼체.
* ☕ **친한 친구 (`friend`)**: 메신저 코드(ㅋㅋ, ㅠㅠ), 초성, 적절한 팩트폭력과 공감.
* *그 외 선배, 동료, 후배, 교수님, 연인, 부모님, 형제자매 등 총 14개 관계 완벽 지원.*

### 3) 🎨 원클릭 퀵 톤 조절기 (Quick Tone Modifiers)
추천된 답장이 마음에 들지만 약간의 뉘앙스를 바꾸고 싶을 때, 단 한 번의 클릭으로 즉시 어조를 재작성합니다:
* `[✨ 더 정중하게]` : 완충어 및 극존칭 추가
* `[🛡️ 더 단호하게]` : 완곡한 거절 및 경계선 명확화
* `[😎 MZ 스타일로]` : 힙하고 자연스러운 메신저 줄임말/구어체 적용
* `[💕 다정하게]` : 이모지와 따뜻한 공감 표현 극대화

### 4) 💬 연속 대화 지원 (Multi-turn Context)
단발성 추천을 넘어, 사용자가 마음에 드는 답장을 선택하면 **`[💬 대화 이어가기]`**를 통해 누적 대화 기록(Turn)으로 보존됩니다. 상대방의 다음 반응이 오면 이전 티키타카 문맥을 프롬프트에 자동 주입하여 끊김 없는 대화 흐름을 유지합니다.

### 5) 📸 비전 스크린샷 판독 (Vision Engine)
텍스트를 복사해 올 필요 없이 카카오톡 캡처 이미지를 업로드하면:
* 노란색/우측(나) vs 흰색/좌측(상대방) 말풍선 분리
* 메시지 간 전송 시간 간격(Latency: 5분 vs 8시간)에 따른 심리 분석
* 읽음 표시(카카오톡 숫자 1 유무) 기반 서브텍스트 해독

### 6) 🧠 LCS Diff 기반 온디바이스 재귀 학습 (Self-Improvement)
추천 답장을 사용자가 직접 편집할 경우 최장 공통 부분 수열(LCS) 알고리즘으로 수정 성향(+추가/-삭제 단어, 격식도 이동량)을 계산하여 브라우저 로컬 프로필에 학습시키며, 쓸수록 내 말투를 닮아가도록 진화합니다.

---

## 🏗️ 시스템 아키텍처 및 저장소 구성 (Architecture & Structure)

WsIr 저장소는 웹, 모바일, 백엔드가 모듈별로 명확히 분리된 구조를 갖추고 있습니다:

```text
WsIr/
├── index.html                   # [Web] 완전 독립형 웹 프로토타입 SPA (체험 및 BYOK)
├── wsir_app/                    # [Mobile] Flutter 기반 크로스 플랫폼 앱 (iOS / Android)
│   ├── lib/
│   │   ├── domain/models/       # Freezed 기반 불변 도메인 모델 (AnalysisResult)
│   │   ├── data/
│   │   │   ├── services/        # HTTP 프록시 통신 클라이언트 (GeminiProxyService)
│   │   │   └── repositories/    # 단일 진실 공급원 저장소 (ChatRepository)
│   │   ├── ui/features/chat/
│   │   │   └── view_models/     # 상태 관리 ViewModel (ChatViewModel - MVVM)
│   │   └── main.dart            # Flutter 앱 진입점 및 Material 3 UI / ImagePicker
│   └── pubspec.yaml             # Flutter 종속성 설정
├── wsir_proxy/                  # [Backend] Node.js Express 보안 프록시 서버
│   ├── index.js                 # Gemini 3.8 Flash SDK 호출, 스키마 검증, 프롬프트 중앙 관리
│   ├── .env.example             # 프록시 환경변수 템플릿 (API 키 격리)
│   └── package.json             # Express, @google/genai, cors 등 의존성
├── PROJECT_IDENTITY_AND_STRATEGY.md # 제품 정체성 및 시장 전략 문서
├── MASTER_PLAN v1 (1).1         # 비즈니스 및 엔지니어링 마스터 플랜
└── README.md                    # 본 프로젝트 종합 안내 문서
```

---

## 💸 유닛 이코노믹스 및 LLM 파이프라인

* **메인 모델**: **Google Gemini 3.8 Flash** (Google AI Studio 최신 권장 모델)
* **API Key 보안**: 클라이언트 앱 내부에 API 키를 포함하지 않고 `wsir_proxy` 서버에서 `.env`로 은닉 관리.
* **무료 티어 (Free Tier) 지원**: Google AI Studio 무료 티어(결제수단 미등록 키) 적용 시 **실제 청구 금액 ₩0 (완전 무료)**로 구동.
* **초저지연 응답**: Thinking 추론 파라미터 최적화로 평균 1.5~2.5초 내에 4개 후보 및 심층 분석 JSON 반환.

---

## 🚀 로컬 실행 가이드 (Quick Start)

### 1. 웹 프로토타입 실행 (`index.html`)
별도의 서버 구동 없이 웹 브라우저에서 바로 열 수 있습니다.
* `WsIr/index.html` 파일을 더블 클릭하여 크롬/사파리 등의 브라우저에서 실행.
* [체험 모드]로 시뮬레이션 데이터를 즉시 확인하거나, 우측 상단 톱니바퀴에서 Gemini API Key를 입력하여 실시간 동작 가능.

### 2. 백엔드 프록시 서버 실행 (`wsir_proxy/`)
```bash
cd wsir_proxy
npm install
# .env 파일 생성 후 발급받은 Gemini API 키 입력:
# GEMINI_API_KEY=your_gemini_api_key_here
npm start
# http://localhost:3000 에서 서버 구동 (/health 로 상태 확인 가능)
```

### 3. 모바일 앱 실행 (`wsir_app/`)
```bash
cd wsir_app
flutter pub get
flutter run
# 에뮬레이터 또는 연결된 기기에서 MVVM 기반 WsIr 모바일 앱 실행
```

---

## 🛡️ 개인정보 보호 정책 (Zero-Retention Privacy)

본 서비스는 사용자의 사적인 대화와 캡처 화면을 최우선으로 보호합니다:
* **비저장 원칙**: 업로드된 이미지 및 대화 원문은 LLM 추론을 위한 인메모리(In-Memory) 버퍼에서만 처리되며, 분석 즉시 메모리에서 영구 폐기됩니다.
* **데이터 학습 금지**: 사용자 대화 로그를 AI 모델 학습용으로 저장하거나 제3자에게 제공하지 않습니다.

---

* **저작권**: © 2026 "나 뭐라고 보낼까? (WsIr)" All Rights Reserved.
