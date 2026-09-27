# 나 뭐라고 보낼까? — VIBE CODING BLUEPRINT
> AI-Coding-Agent-Friendly Implementation Spec (NOT human-optimized)
> Source: distilled from full conversation history with founder
> Purpose: drop into [minimax code] session for in-depth React Native mobile app build
> Last compiled: 2026-09-20

---

## 0. META — HOW TO USE THIS DOCUMENT

```
READING ORDER for AI agents:
  §1 PROJECT ESSENCE         ← must read, single page
  §2 NON-NEGOTIABLE RULES    ← must read, hard constraints
  §3 USER-VALIDATED DECISIONS← must read, all "why" context
  §4 ARCHITECTURE            ← must read, system design
  §5 DATA MODEL              ← must read, DB schema
  §6 API SURFACE             ← must read, endpoints
  §7 LLM PIPELINE            ← must read, multi-model routing
  §8 UI/UX PATTERNS          ← must read, copy from v5 prototype
  §9 IMPLEMENTATION PHASES   ← ordered build steps
  §10 VERIFICATION CRITERIA  ← acceptance tests per phase
  §11 COST BUDGET            ← hard cost targets
  §12 ANTI-PATTERNS          ← what NOT to do
  §13 CONVERSATION DECISIONS ← raw decision log with reasoning
  §14 FILE INVENTORY         ← existing files to read/extend
  §15 EXTERNAL CONTEXT       ← links to deployed prototypes

OPTIMIZATION:
- This document is dense and structured for AI parsing, not human reading.
- Every requirement is numbered for explicit traceability (REQ-X-N).
- Every decision has a "WHY" annotation.
- Code patterns from v5 prototype are directly portable — see §14.
```

---

## 1. PROJECT ESSENCE

```
NAME:        나 뭐라고 보낼까? (What should I send?)
TAGLINE:     AI가 답장의 톤까지 골라준다
DOMAIN:      Korean messenger AI assistant
FOUNDER:     Solo founder (Korean speaker, MBA-style strategic thinking)
LANGUAGE:    Korean (UI, copy, prompts) — English never in user-facing strings

CORE VALUE PROP:
  "복잡한 한국어 메신저 답장, 1초 안에 4개 후보 + Wow Point 1개"

DIFFERENTIATION (in priority order):
  D1. Wow Point — 답장 1개가 "이건 못 생각했다"는 통찰을 담음
  D2. 11개 관계 카테고리 — boss/senior/junior/professor/client/romantic/parent/sibling/friend/stranger/neighbor
  D3. 재귀 학습 — 사용자 편집 데이터로 매달 내답게 진화
  D4. 톤 코치 — 단순 답장기가 아닌 관계 의사소통 코치 (Layered approach)

BUSINESS MODEL:
  - Free tier:    30 generations/month, basic candidates only
  - Plus tier:    ₩4,900/month, unlimited + Wow Point + 분석 풀 표시
  - Pro tier:     ₩14,900/month, 받는 사람 톤 예측 + B2B 톤 가이드라인
  - B2B:         team pricing, custom

TARGET:
  M3  1k users / 500 MAU / free
  M6  10k users / 3k MAU / 50 Plus
  M9  50k users / 15k MAU / 500 Plus
  M12 200k users / 60k MAU / 3k Plus / ₩50M B2B ARR
```

---

## 2. NON-NEGOTIABLE RULES (Hard Constraints)

```
HARD-1: Korean language throughout ALL user-facing strings
        → NO English in UI, prompts (system prompts Korean only), copy
        → REASON: target market = Korean, cultural fluency = moat

HARD-2: BYOK (Bring Your Own Key) pattern
        → API key NEVER goes through our backend
        → Key stored ONLY in client (localStorage / AsyncStorage)
        → Direct OpenAI call from client (CORS enabled for browser, native has no CORS issue)
        → REASON: zero server cost, zero liability, zero data retention risk
        → ANTI-PATTERN: server-proxying OpenAI = costs us money + stores user keys

HARD-3: No server-side storage of user conversations
        → Conversation history stays client-side (localStorage / AsyncStorage)
        → Server only sees: aggregated metrics, anonymized patterns
        → REASON: privacy = competitive moat + regulatory safety

HARD-4: LLM cost ceiling: ₩20/session
        → Default: ₩11/session (mini 80% + 4o 20%)
        → Cache miss path must stay under ₩20
        → REASON: at 60k MAU, 5% conversion, break-even = 7,186 Plus subscribers
                   exceeding ₩20/session = unit economics break

HARD-5: Korean market first, English/Japanese LATER (M12+)
        → NO i18n abstraction in v1 (YAGNI)
        → All 11 categories Korean-specific
        → REASON: Korean cultural codes (존댓말, ㅋㅋ, ㅠㅠ) = barrier AND moat

HARD-6: No silent message sending
        → If messenger integration ever auto-sends, must have explicit user confirmation
        → REASON: trust + regulatory

HARD-7: Recursive learning is opt-in, transparent
        → User must be able to see what was learned (show diff)
        → User must be able to delete learning data
        → REASON: trust + GDPR-style compliance even in non-EU

HARD-8: v1 prototype (fake template substitution) is REJECTED
        → Must use real LLM, real reasoning, real variation
        → REASON: founder caught v1 was fake — never again
```

---

## 3. USER-VALIDATED DECISIONS (with WHY)

### D1. Multi-Model Routing (mini 80% + 4o 20%)
```
WHY: 
  - All-GPT-4o = ₩183/session, break-even = 36k paying users (impossible)
  - All-mini = Wow Point becomes generic, no differentiation
  - Mini + 4o (4o ONLY for Wow Point) = ₩11/session, break-even = 7,186 paying
  - 94% cost reduction while keeping the one thing that matters (Wow Point)

SPEC:
  - Layer 1 (intent analysis): GPT-4o-mini
  - Layer 2 (basic candidates × 3): GPT-4o-mini, parallel
  - Layer 3 (Wow Point × 1): GPT-4o
  - Layer 4 (quality scoring): GPT-4o-mini
  - Cache: 24h TTL on (scenario, last_msg_80chars)
  - Cache miss path = ₩11, cache hit = ₩0
```

### D2. 11 Relationship Categories
```
WHY: Korean social hierarchy has specific speech-levels per relationship
     (반말/해체/합쇼체/해요체 etc.) — generic "formal/casual" is insufficient

CATEGORIES:
  - boss       (상사)     - 합쇼체 mandatory, deferential
  - senior     (선배)     - 존댓말 but softer than boss
  - colleague  (동료)     - 해요체 common, situational
  - junior     (후배)     - 반말 OK in some cases, mentoring tone
  - professor  (교수님)   - 합쇼체, academic deferential
  - school     (학교 친구) - 반말 or 해요체, intimate
  - romantic   (연인)     - 반말, sweet/strategic
  - parent     (부모님)   - 합쇼체 but warm, family
  - sibling    (형제자매) - 반말, casual
  - client     (클라이언트) - 합쇼체, professional
  - friend     (친구)     - 반말, casual

EACH CATEGORY HAS:
  - 2 sample scenarios in onboarding
  - Default tone profile (formality bias 0.0-1.0)
  - Allowed/forbidden honorifics
  - Default length bias
```

### D3. Wow Point = "사용자가 절대 생각 못한 각도"
```
WHY: This is the killer feature. Most AI reply tools give "predictable" replies.
     Wow Point differentiates by giving a reply that demonstrates genuine insight.

DEFINITION (from founder):
  "표면적 답장이 아니라 사용자가 절대 생각 못한 통찰을 담은 답장.
   단순 사과/거절/부탁이 아닌 전략적 깊이가 담긴 답장."

EXAMPLE:
  상사: "이거 언제까지 가능해?"
  Bad:  "내일 오전까지 하겠습니다" (predictable)
  Good: "오늘 밤 11시까지 초안, 내일 오전 중 피드백 반영해서 마무리하겠습니다.
         급하신 부분 먼저 알려주시면 그 부분부터 확실히 잡겠습니다." (strategic)

3-TIER STRUCTURE:
  - basic:      expected, safe reply
  - thoughtful: adds consideration, empathy
  - strategic:  Wow Point — insight that surprises user
```

### D4. Recursive Learning via Diff
```
WHY: User editing the suggestion = strongest possible signal of personal preference.
     Edit diff → update per-relationship profile → next time reflect style.

ALGORITHM:
  1. User taps suggestion card
  2. Modal shows original + editable text
  3. On save: LCS-based diff (tokenize Korean chars + spaces/punct)
  4. Extract added/removed phrases
  5. Update profile:
     - overall.formalityBias += computeFormalityShift(original, edited)
     - overall.lengthBias += computeLengthShift(original, edited)
     - perRelation[rel].formalityBias += shift (with decay 0.85)
     - perRelation[rel].preferredPhrases[word] += 1 (if added)
     - perRelation[rel].avoidedPhrases[word] += 1 (if removed)
  6. Apply decay: new = 0.85 * old + 0.15 * new (recency-weighted)

MIN SAMPLE for personalization:
  - 0 edits = no personalization
  - 1-2 edits = weak signal, don't override default tone
  - 3+ edits = apply (use phrases, formality bias)

PHRASE LENGTH FILTER:
  - Only track phrases 2-8 chars (단어/구 단위)
  - Skip single chars (too noisy)
```

### D5. BYOK Pattern (No Server)
```
WHY:
  - Server = monthly cost + devops + security audit + privacy risk
  - BYOK = user pays OpenAI directly, we pay $0
  - Korean users OK with BYOK (many power users already have ChatGPT Plus)
  - CORS works for browser, native has no CORS anyway

REQUIREMENTS:
  - Key UI: paste field with show/hide toggle, "BYOK" badge
  - Storage: localStorage (browser) / Keychain (iOS) / EncryptedSharedPreferences (Android)
  - Validation: must start with "sk-"
  - Reset flow: confirm dialog → clear storage
  - On app open: check key exists, prompt if missing
```

### D6. Brain Science = Subtle Layered (NOT full integration)
```
WHY: 
  - Pure Tool (just reply generator) = no differentiation, "AI 답장기" category
  - Full Brain Science (psychology on every reply) = high learning curve, users feel judged
  - Subtle Layered = basic is free tool, premium unlocks depth = best of both

LAYERS:
  L1 (free, every user):
    - 4 candidates per query
    - Brief intent analysis (subtext one-liner)
    - Avoid expressions shown
    
  L2 (Plus subscribers):
    - Full analysis panel (intent + emotion + subtext + whatTheyWant + strategy)
    - Sender/receiver tone mismatch warnings
    - Time-of-day tone hints
    - Learning data visualization ("당신이 자주 쓰는 표현")
    
  L3 (Pro / B2B):
    - Communication theory citations (Goffman face-work, Brown & Levinson politeness)
    - Receiver-side tone prediction ("이 메시지를 ○○가 어떻게 읽을까")
    - Team tone guideline compliance check
    - Relationship-by-relationship sending history analysis

METRICS:
  - L1 → L2 upgrade: ≥8% of paying
  - "왜 추천?" click rate: ≥30% (proxy for analysis engagement)
  - B2B L3: team tone consistency score ↑
```

### D7. Tech Stack (Decided)
```
FRONTEND (mobile):
  - React Native (iOS 17+ / Android 10+)
  - NativeWind (Tailwind for RN) — decided for styling
  - Navigation: React Navigation v6
  - State: Zustand or Redux Toolkit (TBD in Phase 0)
  - Storage: AsyncStorage + Keychain/EncryptedSharedPreferences for API key

BACKEND:
  - Node.js + Fastify + TypeScript
  - Python (FastAPI) ONLY for ML/fine-tuning later
  - REASON: Node for mobile-friendly I/O, Python only when ML is needed

DATA:
  - User profiles / usage: PostgreSQL (Supabase recommended)
  - Session / cache: Redis (Upstash)
  - Few-shot examples / vector search: Pinecone
  - Learning data (anonymized): PostgreSQL + S3

INFRA:
  - AWS Seoul region (Korean latency)
  - Sentry (app), Grafana (server)
  - Mixpanel/Amplitude (events)
  - CI/CD: GitHub Actions + EAS (RN) / Fastlane

LLM (primary):
  - OpenAI GPT-4o + GPT-4o-mini (decided)
  - Claude 3.5 Sonnet as backup/secondary

PAYMENTS:
  - iOS: StoreKit 2
  - Android: Google Play Billing Library
  - Korea: 토스페이 (web fallback)
```

### D8. Decision Framework for Unknowns
```
USE THIS when facing ambiguity in implementation:

Q1. Does this affect user-visible behavior?
  YES → prioritize, ask user if 2+ valid approaches
  NO  → use sensible default, document in code

Q2. Is this in the "soft rules" list (master plan §9.2)?
  YES → can defer or simplify
  NO  → must implement fully

Q3. Cost impact > ₩5/session?
  YES → use multi-model routing optimization
  NO  → implement straightforward

Q4. Affects Korean cultural accuracy?
  YES → test with native Korean speaker before shipping
  NO  → standard QA

Q5. Privacy implication?
  YES → BYOK stays client-side, never server
  NO  → standard server-side OK
```

---

## 4. ARCHITECTURE

### 4.1 System Layers
```
┌─────────────────────────────────────────────────────────┐
│ LAYER 5: UI/UX (React Native)                           │
│   - 11 category onboarding (4-8 questions per category)│
│   - Main input screen (paste last message + scenario)   │
│   - Suggestions panel (4 candidates, Wow Point flagged) │
│   - Edit modal (diff visualization)                     │
│   - Profile screen (learning visualization)             │
│   - Settings (BYOK, reset learning, plan info)          │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 4: Client State (Zustand)                         │
│   - apiKey (from secure storage)                        │
│   - currentScenario                                     │
│   - suggestions (current + history)                     │
│   - profile (overall + perRelation)                     │
│   - sessionCost (running total ₩)                       │
│   - cacheIndex (scenario:msg → timestamp)               │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 3: LLM Pipeline Orchestrator (TS, runs in app)    │
│   - Step 1: Check cache                                 │
│   - Step 2: Intent analysis (mini)                      │
│   - Step 3: Generate 3 base candidates (mini)           │
│   - Step 4: Generate Wow Point (4o)                     │
│   - Step 5: Quality score + sort (mini)                 │
│   - Step 6: Cache result, return                        │
│                                                          │
│   OR (cache hit): return immediately                    │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 2: BYOK API Client                                │
│   - Stores key in secure storage (Keychain/ESP)         │
│   - Direct HTTPS to api.openai.com/v1/chat/completions  │
│   - No CORS in native, browser has CORS allowed         │
│   - Usage tracking (tokens in/out, cost in ₩)           │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 1: OpenAI API (external)                          │
│   - gpt-4o-mini:  $0.15/1M in, $0.60/1M out             │
│   - gpt-4o:       $2.50/1M in, $10.00/1M out            │
└─────────────────────────────────────────────────────────┘
                          ↓
               (Server backend for sync only)
┌─────────────────────────────────────────────────────────┐
│ LAYER 0: Backend (Node.js + Fastify) — MINIMAL          │
│   - /sync-profile      (POST: client → server, opt-in)  │
│   - /track-event       (POST: anonymized analytics)     │
│   - /validate-receipt  (POST: Apple/Google IAP verify)  │
│   - /get-few-shot      (GET: curated scenarios)         │
│                                                          │
│   NEVER stores: user conversations, API keys            │
└─────────────────────────────────────────────────────────┘
```

### 4.2 Data Flow (Single Suggestion Request)
```
USER ACTION:
  1. Opens app
  2. Selects scenario ("연인 주말약속")
  3. Pastes/captures last message ("주말에 시간 돼?")
  4. Taps "Multi-Model 답변 요청"

PIPELINE:
  ┌─ CLIENT (RN) ───────────────────────────────────────┐
  │ 5. Orchestrator: cacheKey = hash(scenario, msg80)    │
  │ 6. Cache check → MISS                                │
  │ 7. Read apiKey from Keychain                         │
  │ 8. Call OpenAI gpt-4o-mini (Layer 1 intent)          │
  │ 9. Call OpenAI gpt-4o-mini (Layer 2 drafts)          │
  │ 10. Call OpenAI gpt-4o (Layer 3 wow point)           │
  │ 11. Call OpenAI gpt-4o-mini (Layer 4 quality)        │
  │ 12. Sort candidates                                  │
  │ 13. Cache result (24h TTL)                           │
  │ 14. Update sessionCost += tokens*price               │
  │ 15. Render 4 cards in UI                             │
  └──────────────────────────────────────────────────────┘
  ↓
USER ACTION:
  16. Taps Wow Point card → sees analysis panel
  17. Taps "수정" → modal opens with original + editable
  18. Edits → taps "저장하고 학습"
  ↓
  ┌─ CLIENT (RN) ───────────────────────────────────────┐
  │ 19. LCS diff (original, edited)                      │
  │ 20. computeFormalityShift + computeLengthShift       │
  │ 21. Update ProfileStore with weighted decay          │
  │ 22. Persist to AsyncStorage                          │
  │ 23. Optional: POST /sync-profile (cloud backup)      │
  └──────────────────────────────────────────────────────┘
```

### 4.3 Offline / Network Failure
```
- Cache hit: works offline
- Cache miss + no network: show "네트워크 필요" with retry
- LLM API error (rate limit, auth): show user-friendly error with reset-key CTA
- Partial pipeline failure: show 3 base candidates even if Wow Point fails
```

---

## 5. DATA MODEL

### 5.1 Client State (AsyncStorage keys)
```typescript
// Storage keys (use prefix to avoid collisions)
const STORAGE_KEYS = {
  apiKey:        'mwoaraeogetji-openai-key-v5',         // secure storage
  profile:       'mwoaraeogetji-profile-v5',
  cache:         'mwoaraeogetji-cache-v5',
  sessionStats:  'mwoaraeogetji-stats-v5',
  onboarding:    'mwoaraeogetji-onboarding-v5',
  scenarioHistory: 'mwoaraeogetji-history-v5',
}

// Profile structure
interface Profile {
  overall: {
    sampleSize: number       // total edits
    formalityBias: number    // -1 (casual) to 1 (formal)
    lengthBias: number       // -1 (shorter) to 1 (longer)
    emojiLevel: number       // 0 (none) to 1 (heavy)
  }
  perRelation: {
    [relation: string]: {
      sampleSize: number
      formalityBias: number
      preferredPhrases: { [phrase: string]: number }
      avoidedPhrases: { [phrase: string]: number }
    }
  }
}

// Cache entry
interface CacheEntry {
  data: PipelineResult
  ts: number       // timestamp for TTL
}

// Session stats
interface SessionStats {
  totalCalls: number
  totalCostKRW: number
  cacheHits: number
  cacheMisses: number
  firstUseTs: number
}
```

### 5.2 Backend Schema (when needed, M3+)
```sql
-- Anonymized user profile sync
CREATE TABLE profiles (
  user_id UUID PRIMARY KEY,
  profile_json JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  device_count INT DEFAULT 1
);

-- Few-shot examples (curated, server-side)
CREATE TABLE few_shot_examples (
  id UUID PRIMARY KEY,
  category TEXT NOT NULL,         -- '상사 면책 정정', '이성 모드', etc.
  relation TEXT NOT NULL,
  scenario TEXT NOT NULL,
  example_input TEXT NOT NULL,
  example_output TEXT NOT NULL,
  rationale TEXT,
  embedding vector(1536),         -- for vector search
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Anonymized usage analytics
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id_hash TEXT NOT NULL,      -- hashed, not raw
  event_type TEXT NOT NULL,        -- 'generation', 'edit', 'copy', 'send'
  category TEXT,
  cost_krw INT,
  cached BOOLEAN,
  ts TIMESTAMPTZ DEFAULT NOW()
);

-- Subscription verification
CREATE TABLE subscriptions (
  user_id UUID PRIMARY KEY,
  platform TEXT NOT NULL,          -- 'ios' | 'android' | 'toss'
  receipt TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  verified_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 6. API SURFACE

### 6.1 External (Direct from client)
```
POST https://api.openai.com/v1/chat/completions
Headers:
  Authorization: Bearer {user_api_key}
  Content-Type: application/json
Body:
{
  model: "gpt-4o-mini" | "gpt-4o",
  messages: [
    { role: "system", content: "{system_prompt_korean}" },
    { role: "user", content: "{user_prompt}" }
  ],
  temperature: 0.7,
  max_tokens: 600,
  response_format: { type: "json_object" }
}
```

### 6.2 Backend Endpoints (when sync needed, M2+)
```
POST /v1/sync-profile
  Body: { profile: Profile }
  Returns: { synced_at: timestamp, version: number }
  Note: opt-in, user can disable

POST /v1/track-event
  Body: { event_type, category?, cost_krw?, cached?, ts }
  Returns: { ok: true }
  Note: anonymized, no PII

POST /v1/validate-receipt
  Body: { platform: 'ios'|'android'|'toss', receipt: string }
  Returns: { valid: boolean, expires_at: timestamp, tier: 'plus'|'pro' }

GET /v1/few-shot?category={category}
  Returns: FewShotExample[]
  Note: cached on client, refreshed weekly
```

---

## 7. LLM PIPELINE

### 7.1 Pipeline Steps (full spec)
```
STEP 1 — Cache Check
  key = hash(scenario_id + last_msg.substring(0, 80))
  ttl = 24h
  hit → return immediately (cost = 0)
  miss → proceed

STEP 2 — Intent Analysis (gpt-4o-mini)
  Input: scenario + last_msg + conversation context
  Output JSON:
  {
    intent: string,          // what they want to achieve
    emotion: string,         // what they actually feel
    subtext: string,         // what they're NOT saying
    whatTheyWant: string,    // what they want from user
    strategy: string,        // recommended tone/approach
    redFlags: string[]       // what to avoid
  }
  ~500 tokens, ~$0.0001

STEP 3 — Base Candidates (gpt-4o-mini)
  Input: scenario + last_msg + intent_analysis
  Output JSON:
  {
    candidates: [
      { tier: "basic",      tone: "격식", text: "...", rationale: "..." },
      { tier: "thoughtful", tone: "캐주얼", text: "...", rationale: "..." },
      { tier: "thoughtful", tone: "따뜻", text: "...", rationale: "..." }
    ]
  }
  ~600 tokens × 3 candidates, ~$0.0004

STEP 4 — Wow Point (gpt-4o)
  Input: scenario + last_msg + intent_analysis + base_candidates
  Output JSON:
  {
    wow_point: {
      tone: "전략",
      text: "...",           // 1-2줄, 압축
      rationale: "...",      // why this is Wow (1줄)
      wow_detail: "..."      // 2-3줄 효과 설명 (한국 문화 맥락)
    }
  }
  ~400 tokens, ~$0.0056

STEP 5 — Quality Scoring (gpt-4o-mini) — OPTIONAL
  Input: all 4 candidates
  Output: { scores: [1-10, 1-10, 1-10, 1-10] }
  Sort by score descending
  ~200 tokens, ~$0.00003

STEP 6 — Cache + Return
  cacheKey → store for 24h
  Return PipelineResult to UI
```

### 7.2 System Prompts (Korean only)

**INTENT_SYSTEM_PROMPT**:
```
너는 메신저 메시지 분석가다. 사용자가 보낸 [상대방의 최근 메시지 + 대화 맥락]를 읽고:
1. 의도 (intent): 상대가 진짜로 달성하려는 것
2. 감정 (emotion): 표정 이면의 감정
3. 서브텍스트 (subtext): 직접 말하지 않은 진짜 의도
4. 상대 욕구 (whatTheyWant): 상대가 사용자에게 원하는 것
5. 추천 전략 (strategy): 사용자가 취해야 할 톤/접근
6. 회피할 것 (redFlags): 피해야 할 표현/태도

반드시 JSON만 출력:
{
  "intent": "...",
  "emotion": "...",
  "subtext": "...",
  "whatTheyWant": "...",
  "strategy": "...",
  "redFlags": ["..."]
}
```

**DRAFTS_SYSTEM_PROMPT**:
```
너는 메신저 답장 생성기다. 다음 조건을 만족하는 한국어 답장 후보를 생성하라.

[조건]
- 메신저 1~2줄 압축 (긴 답장은 부적합)
- 한국어 메신저 코드 활용 (ㅋㅋ, ㅠㅠ, 😊 등) — 단, 격식 관계에서는 절대 금지
- 절대 거짓/공격적/조롱/차별 표현 금지
- 호칭 정확히 사용
- JSON 배열로만 응답

각 후보는 서로 다른 톤:
1. 격식 (formal): 상사/클라이언트용
2. 캐주얼 (casual): 친구/썸/동료용
3. 따뜻 (warm): 가족/친한 친구용

[출력 형식]
{
  "candidates": [
    {"tier": "basic|thoughtful", "tone": "격식|캐주얼|따통", "text": "한국어 답장", "rationale": "왜 이렇게 썼는지 1줄"}
  ]
}
```

**WOW_SYSTEM_PROMPT**:
```
너은 메신저 커뮤니케이션 코치다. 사용자가 절대 생각하지 못한 각도의 "Wow Point" 답장을 만들어라.

[Wow Point의 정의]
- 표면적 답장이 아니라 **사용자가 절대 생각 못한 통찰**을 담은 답장
- 상대방의 진짜 욕구/감정을 짚어주면서 자연스럽게 답하는 것
- 단순 사과/거절/부탁이 아닌 **전략적 깊이**가 담긴 답장
- 1~2줄 압축

[예시]
상대: "주말에 시간 돼?"
나쁜 답: "응 돼!" (단순)
좋은 답: "응! 너 일주일 내내 바빴을 텐데 가서 쉬자. 장소는 내가 찾아볼게 — 네가 좋아하는 ○○ 쪽으로!" (관찰의 신호 + 적극성)

[출력 형식] (JSON만)
{
  "wow_point": {
    "tone": "전략",
    "text": "한국어 Wow Point 답장 (1~2줄)",
    "rationale": "왜 이게 Wow Point인지 1줄 (사용자가 절대 생각 못한 각도)",
    "wow_detail": "이 답장이 효과적인 이유 2-3줄 (한국 문화 맥락 포함)"
  }
}
```

### 7.3 Personalization Injection (per call)
```
When profile.perRelation[rel].sampleSize >= 3:
  Append to system prompt:
  ```
  [사용자 개인화 — 이 관계에서 학습됨]
  - 선호 톤: {격식체|캐주얼체|중간}
  - 자주 쓰는 표현: "{phrase1}", "{phrase2}", "{phrase3}"
  (위 스타일을 자연스럽게 반영)
  ```
```

### 7.4 Token Estimates (per pipeline run)
```
Layer 1 (mini):  ~700 in + ~300 out = $0.0001
Layer 2 (mini):  ~1200 in + ~600 out = $0.0005
Layer 3 (4o):    ~1200 in + ~400 out = $0.0070
Layer 4 (mini):  ~600 in + ~50 out = $0.0001 (optional)

TOTAL per session (cache miss): ~$0.0077 ≈ ₩10.4
TOTAL per session (cache hit):   $0
Target: ₩20/session (room for Layer 4 + future layers)
```

---

## 8. UI/UX PATTERNS (FROM v5 PROTOTYPE — COPY DIRECTLY)

### 8.1 Onboarding Flow
```
Step 1: Welcome screen (BYOK explainer + key input)
Step 2: Relationship picker (11 categories, multi-select)
Step 3: For each selected category:
  - 4-8 questions about formality/length/style
  - 2 sample scenarios per category
Step 4: Cold-start profile generated
Step 5: Home screen unlocked

DESIGN PATTERN: card-based, one question per screen, swipeable
ONBOARDING KEY: 'mwoaraeogetji-onboarding-v5'
```

### 8.2 Home Screen
```
- Top: 3-stat dashboard (총 호출 / 누적 ₩ / 캐시 적중%)
- Middle: scenario list (cards, 5 visible, scroll for more)
- Bottom: profile button
- No analytics SDK in M0-M1 (privacy)

COLOR SCHEME:
  Background:     #0b0d12 (dark)
  Text:           #e8ecf4
  Brand:          #ff7a59 → #ffb86b (gradient)
  Accent (cool):  #7c9eff → #5ce4d0
  Wow Point:      #fbbf24 (gold) → #f59e0b → #ea580c
  Success:        #4ade80
  Danger:         #ff6b6b

TYPOGRAPHY:
  Primary:        Pretendard (300/400/500/600/700/800/900)
  Mono (cost):    JetBrains Mono
```

### 8.3 Suggestion Cards
```
- Basic/thoughtful:        neutral background, brand-color tier badge
- Wow Point (strategic):   gold gradient background, "⚡ WOW POINT" floating badge top-right
- Copy button (top-right): 📋 icon
- Tap card body:           open edit modal
- Below text:              rationale (1줄), wow_detail (2-3줄 for Wow)

TIER VISUAL HIERARCHY (top-to-bottom):
  1. ⚡ Wow Point (gold, largest visual weight)
  2. 💙 배려 thoughtful (accent blue)
  3. ⚪ 기본 basic (neutral)
```

### 8.4 Edit Modal
```
- Title: "✏️ 메시지 수정"
- Description: "수정 후 저장하면 다음부터 이 스타일이 반영돼요"
- Textarea: editable text, min-height 100px
- Diff section: shows added (green) + removed (red) phrases
- Buttons: 취소 (secondary) | 저장하고 학습 (primary)

DIFF VISUALIZATION:
  + 추가: [phrase1] [phrase2] [phrase3]
  - 삭제: [phrase1] [phrase2] [phrase3]

PHRASE FILTER: 2-8 chars only
```

### 8.5 Profile / Learning Screen
```
- Hero avatar with sample count
- 3-stat row: 총 학습 / 오늘 / 누적 ₩
- Per-relationship cards:
  - Name + sample count
  - Formality bar (0-100%)
  - Preferred phrases (chips)
- Reset buttons (red warning style)
```

### 8.6 Mock Messenger (v5 simulation)
```
- iPhone-style frame (white background)
- Status bar (fake)
- Header (avatar + name + status)
- Conversation: bubbles with timestamp
- "Highlighted" bubble = the message user needs to reply to
- Color-coded: other person (white), me (yellow #ffeb33)
- Below phone: 3 stat blocks + "Multi-Model 답변 요청" CTA
```

### 8.7 Loading States
```
- During pipeline: 4-step progress indicator
  ⏳ 캐시 확인 중... (localStorage)
  ✓ 캐시 미스 → LLM 호출
  ✓ 의도 분석 중... (gpt-4o-mini)
  ✓ 기본 답장 3개 생성 중... (gpt-4o-mini)
  ⏳ ⚡ Wow Point 생성 중... (gpt-4o)
- Each step shows model used (in mono font)
- Animation: pulsing dot for active step, ✓ for done
```

---

## 9. IMPLEMENTATION PHASES (ORDERED)

### Phase 0 — Foundation (M0-M1, 4 weeks)
```
GOAL: Real working engine + native app shell

P0.1  Project bootstrap
  - npx react-native init Mwoaraeogetji
  - NativeWind config
  - Navigation setup (React Navigation v6)
  - TypeScript strict mode
  - Directory structure:
    src/
      api/        (OpenAI client)
      llm/        (pipeline orchestrator + prompts)
      profile/    (ProfileStore + diff)
      cache/      (cache layer)
      storage/    (secure key + async storage)
      ui/         (screens + components)
      state/      (zustand stores)
      utils/      (diff, tokenize, formatters)

P0.2  BYOK + secure storage
  - Keychain (iOS) / EncryptedSharedPreferences (Android)
  - API key input UI with show/hide
  - Validation: starts with "sk-"
  - Reset flow with confirm

P0.3  LLM pipeline (5 layers)
  - Multi-model routing (mini 80% + 4o 20%)
  - Cache layer (24h TTL, AsyncStorage)
  - Session cost tracking
  - System prompts (Korean only)

P0.4  Profile + recursive learning
  - ProfileStore (overall + perRelation)
  - Diff algorithm (LCS, tokenize Korean)
  - 11 relationship categories
  - Formality/length bias calculation
  - Decay 0.85 weighting

P0.5  UI screens (copy from v5)
  - Setup screen (BYOK entry)
  - Home screen (scenario list + stats)
  - Scenario screen (mock messenger + generation)
  - Profile screen (learning viz)
  - Edit modal (diff display)

P0.6  5 base scenarios
  - 연인 주말약속
  - 상사 보고서마감
  - 친구 서운함
  - 엄마 안부
  - 클라이언트 미묘한불만

P0.7  Verification
  - See §10 P0 acceptance tests
```

### Phase 1 — Closed Beta (M2-M3, 8 weeks)
```
GOAL: 100 friend/family testers → real usage data

P1.1  Onboarding (cold-start, 11 categories)
P1.2  Server-side profile sync (opt-in)
P1.3  Few-shot dataset (30 curated scenarios)
P1.4  Quality scoring (Layer 4 enabled)
P1.5  Error handling + fallback
P1.6  TestFlight / Internal testing
P1.7  Analytics (Mixpanel/Amplitude, anonymized)
P1.8  Beta tester recruitment + interviews
```

### Phase 2 — Public MVP (M4-M6, 12 weeks)
```
GOAL: 10k users, 50 Plus subscribers, first ₩1M revenue

P2.1  App Store / Play Store submission
P2.2  Auth (Apple/Google/Kakao)
P2.3  IAP subscription (StoreKit 2 + Play Billing)
P2.4  Plus tier UI (full analysis panel)
P2.5  Push notifications
P2.6  카톡 Share Intent integration
P2.7  200 scenario template library
P2.8  Few-shot expansion to 100
```

### Phase 3 — Messenger Integration (M7-M9, 12 weeks)
```
GOAL: "톡 안에서" 답장 — Android first, iOS keyboard

P3.1  Android Accessibility Service
P3.2  Android Notification Listener
P3.3  Android Floating Widget
P3.4  iOS Keyboard Extension
P3.5  iOS Live Activities
P3.6  Permission UX (gradual)
P3.7  B2B Team beta (10 teams)
```

### Phase 4 — Intelligence (M10-M12, 12 weeks)
```
GOAL: Receiver-side prediction + voice-to-message + group chat

P4.1  Receiver tone prediction
P4.2  Voice → message (Whisper)
P4.3  Group chat analysis
P4.4  Fine-tuning PoC (10k examples)
P4.5  Japan expansion pilot (LINE)
P4.6  Pro tier + B2B ARR
```

---

## 10. VERIFICATION CRITERIA

### P0 Acceptance Tests
```
T1.  User can paste API key, app validates and stores securely
T2.  User selects scenario, sees mock conversation
T3.  Tapping "Multi-Model 답변 요청" runs 4-layer pipeline
T4.  Each step is visible (cache check, mini intent, mini drafts, 4o wow)
T5.  4 candidates shown, Wow Point visually distinguished
T6.  Cache miss shows cost; cache hit shows 0 cost
T7.  User edits candidate → diff shown → profile updated
T8.  After 3+ edits to same relation, personalization visible in next generation
T9.  Network failure shows user-friendly error
T10. Session cost accurately tracked in ₩
T11. Korean-only UI strings (no English leakage)
T12. Profile reset works (data wiped, costs reset)
```

### P1 Acceptance Tests
```
T13. 11-category onboarding completes in <3 min
T14. Onboarding-generated profile applied in first generation
T15. Profile sync to server (opt-in) works
T16. Few-shot retrieval improves candidate quality (LLM-as-judge ≥7.5/10)
T17. D1 retention ≥50% (beta cohort)
T18. Candidate adoption rate ≥60% (copy/send)
T19. LLM cost per session ≤₩20
```

### Quality Gates (every phase)
```
QG1.  No English in user-facing strings (grep validation)
QG2.  API key never logged or persisted to non-secure storage
QG3.  Conversation content never sent to our backend
QG4.  Cache TTL respected (24h)
QG5.  Pipeline cost within ₩20/session (cache miss)
QG6.  All Korean text passes UTF-8 validation
QG7.  No silent message sending (even in messenger integration)
```

---

## 11. COST BUDGET

### Per-User Economics
```
FREE TIER (30 generations/month cap):
  - 30 × ₩11 = ₩330/month LLM cost
  - User pays: $0
  - Our cost: ₩330/user/month
  - Need: conversion to Plus ≥ 5% to break even on free users

PLUS TIER (unlimited, ₩4,900/month):
  - Avg 100 generations/month assumed (heavy use)
  - 100 × ₩11 = ₩1,100/month LLM cost
  - With 60% cache hit rate: 40 × ₩11 = ₩440/month LLM cost
  - User pays: ₩4,900
  - Our cost: ₩440/user/month
  - Gross margin: 91% per Plus user

PRO TIER (unlimited + receiver prediction, ₩14,900/month):
  - 150 generations/month assumed
  - 150 × ₩15 (with extra layer) = ₩2,250/month
  - With 70% cache hit rate: 45 × ₩15 = ₩675/month
  - User pays: ₩14,900
  - Gross margin: 95% per Pro user

BREAK-EVEN AT ₩11/SESSION COST:
  - 7,186 Plus subscribers × ₩4,900 = ₩35.2M revenue
  - 7,186 × ₩440 = ₩3.16M cost
  - Net: ₩32M / month (covers team of 5 at ₩6M each)
  - Conversion 5%: 144k MAU needed
  - Conversion 10%: 72k MAU needed

LTV/CAC TARGET:
  - LTV (Plus): ₩4,900 × 6 months avg = ₩29,400
  - CAC: ≤ ₩15,000
  - LTV/CAC ratio: ≥ 2.0
```

### Cache Strategy
```
HIT RATE TARGETS:
  - 1st month: 20% (users exploring)
  - 3rd month: 40% (recurring scenarios)
  - 6th month: 60% (heavy users, recurring patterns)
  - 12th month: 70%

CACHE KEY:
  - hash(scenario_id + last_msg.substring(0, 80))
  - TTL: 24h
  - Storage: AsyncStorage (mobile), localStorage (web demo)
  - Limit: 100 entries (LRU eviction)
```

---

## 12. ANTI-PATTERNS

```
❌ AP-1: Using fake/template-substitution as "AI"
     → v1 was caught by founder, never again
     → Real LLM call on every cache miss, no exceptions

❌ AP-2: Server-proxying OpenAI API
     → Adds cost + liability + privacy risk
     → BYOK = user pays, we don't

❌ AP-3: Storing user conversations server-side
     → Privacy violation + moat destruction
     → Conversations stay client-side

❌ AP-4: Auto-sending messages without confirmation
     → Trust destruction + regulatory risk
     → User must explicitly copy/send every message

❌ AP-5: Using GPT-4o for all 4 layers
     → ₩183/session = unit economics impossible
     → Use 4o only for Wow Point

❌ AP-6: Generic "formal/casual" tone toggle
     → Korean has 6+ speech levels per relationship
     → Use 11 relationship categories, not binary tone

❌ AP-7: Ignoring Korean cultural codes
     → No ㅋㅋ/ㅠㅠ/존댓말 = feels like translation, not Korean
     → Use them where appropriate

❌ AP-8: Full brain science integration upfront
     → Users feel judged, learning curve too high
     → Subtle Layered: basic free, depth optional

❌ AP-9: Forcing onboarding before value
     → User wants to try before committing
     → Onboarding after first generation, or opt-in deep

❌ AP-10: Mixing English in prompts
     → System prompts Korean only, English only for code comments
     → Korean cultural fluency = moat
```

---

## 13. CONVERSATION DECISIONS LOG (RAW)

```
TURN 1 (planning):
  - "GPT-4o-mini로 80%, GPT-4o로 20%" — multi-model routing decided
  - "Wow Point = AI가 멋대로 써준 답장" — definition of differentiation
  - "브레인 사이언스 vs 의사소통 코치" — debate initiated, deferred

TURN 2 (cost analysis):
  - "v4는 100% GPT-4o, ₩183/세션"
  - "v5 multi-model: ₩11/세션"
  - "Break-even: 7,186 Plus 구독자 (5% 전환)"
  - Decision: use multi-model routing

TURN 3 (brain science positioning):
  - 3 options analyzed: Pure Tool vs Full Brain Science vs Subtle Layered
  - "Pure Tool = 차별점 약함, Full = 진입장벽 ↑"
  - Decision: Subtle Layered (L1/L2/L3)
  - L1: free basic, L2: Plus 분석, L3: Pro/B2B 이론 인용

TURN 4 (v5 prototype):
  - 5 scenarios: 연인주말약속, 상사보고서마감, 친구서운함, 엄마안부, 클라이언트미묘한불만
  - 11 categories finalized
  - Recursive learning structure (decay 0.85, LCS diff)

TURN 5 (master plan update):
  - v1.0 → v1.1 update triggered
  - New sections: multi-model routing §4.3, brain science §12
  - Phase 0 deliverables updated for multi-model

TURN 6 (vibe coding handoff):
  - Founder wants AI-friendly spec, not human-readable
  - Wants comprehensive context capture for next session
  - Explicit: "use the blueprint in a new [minimax code] session"

DECISIONS WITH NO DEBATE:
  - Tech stack: RN + Node + OpenAI
  - BYOK pattern
  - Korean only
  - 11 relationship categories
  - Recursive learning via diff
  - 5-phase roadmap (12 months)
  - 4o only for Wow Point

OPEN QUESTIONS (deferred, do not block P0):
  - State management library (Zustand vs RTK) — pick in P0.1
  - IAP specifics (toss vs storekit) — pick in P2.3
  - Analytics vendor (Mixpanel vs Amplitude) — pick in P1.7
  - Auth provider (Supabase vs Firebase) — pick in P2.2
```

---

## 14. FILE INVENTORY

### Existing Files to Reference
```
/workspace/mwoaraeogetji/index.html          ← service plan (UI patterns)
/workspace/mwoaraeogetji-research/index.html ← market analysis
/workspace/mwoaraeogetji-engine/index.html   ← engine design doc
/workspace/mwoaraeogetji-overlay/index.html  ← messenger overlay architecture
/workspace/mwoaraeogetji-master/MASTER_PLAN.md ← master plan v1.1 (reference)
/workspace/mwoaraeogetji-engine-v5/index.html ← ★ PRIMARY REFERENCE for UI/UX/logic
/workspace/mwoaraeogetji-engine-v4/index.html ← real GPT-4o prototype (logic patterns)
/workspace/mwoaraeogetji-conversation/index.html ← Wow Point mock (5 scenarios UX)
/workspace/mwoaraeogetji-onboarding/index.html ← 11-category cold-start
/workspace/mwoaraeogetji-overlay-demo/index.html ← messenger UX
```

### v5 Code Patterns to Reuse
```
- ProfileStore class (overall + perRelation structure)
- Diff algorithm (tokenize + LCS)
- callOpenAI function (with cost tracking)
- Cache class (LRU + TTL)
- System prompts (Korean only, JSON output)
- Scenario data structure
- UI screens (Setup, Home, Scenario, Profile, Edit Modal)
- Color scheme + typography (Pretendard, dark theme)
```

### v5 Code Patterns to AVOID
```
- localStorage for API key (use Keychain/EncryptedSharedPreferences)
- Browser-only assumptions (need RN equivalents)
- Single-file architecture (need modular structure)
- Mock messenger for production (replace with real input)
```

### New Files to Create in Phase 0
```
src/
  api/openai.ts            ← BYOK client + cost tracking
  llm/pipeline.ts          ← 4-layer orchestrator
  llm/prompts/
    intent.ts              ← Korean intent analysis prompt
    drafts.ts              ← Korean candidate generation prompt
    wow.ts                 ← Korean Wow Point prompt
    quality.ts             ← Korean quality scoring prompt
  profile/ProfileStore.ts  ← recursive learning
  profile/diff.ts          ← LCS + tokenize + bias calculations
  cache/Cache.ts           ← 24h TTL + LRU
  storage/secure.ts        ← Keychain wrapper
  storage/async.ts         ← AsyncStorage wrapper
  state/store.ts           ← zustand
  ui/screens/
    SetupScreen.tsx        ← BYOK entry
    HomeScreen.tsx         ← scenario list + stats
    ScenarioScreen.tsx     ← mock messenger + generation
    ProfileScreen.tsx      ← learning visualization
    EditModal.tsx          ← diff-based editing
  ui/components/
    SuggestionCard.tsx
    CostTracker.tsx
    ProgressSteps.tsx
    AnalysisPanel.tsx
  data/scenarios.ts        ← 5 starter scenarios
  data/relations.ts        ← 11 categories metadata
  types/index.ts           ← TypeScript interfaces
  utils/format.ts          ← won formatter, time, etc.
__tests__/
  pipeline.test.ts
  diff.test.ts
  profile.test.ts
app.json                   ← RN app config
package.json               ← deps
tsconfig.json              ← strict mode
```

---

## 15. EXTERNAL CONTEXT

### Deployed Prototypes (for reference)
```
Engine v5:        https://tpwkujhv18eih.space.minimax.io  ← LATEST, primary reference
Engine v4:        https://0rvktw2bsax68.space.minimax.io  ← Real GPT-4o, single model
Conversation:     https://2lmy2eye8bdx1.space.minimax.io  ← Wow Point mock
Onboarding:       https://vnuj0ikkfvmm4.space.minimax.io  ← 11-category cold-start
Overlay demo:     https://u12suzyjnt8of.space.minimax.io  ← messenger UX
Engine v3:        https://egicf61fmi6ue.space.minimax.io  ← recursive learning
Engine v2:        https://yyqghbwm6q4ub.space.minimax.io  ← rule-based
Master plan:      /workspace/mwoaraeogetji-master/MASTER_PLAN.md
Service plan:     https://mqjvhurg83edd.space.minimax.io
Research:         https://i2apxb81ynvyd.space.minimax.io
```

### External APIs
```
OpenAI:
  Endpoint: https://api.openai.com/v1/chat/completions
  Auth: Bearer {key}
  Models: gpt-4o, gpt-4o-mini
  Pricing (per 1M tokens):
    gpt-4o:       $2.50 input / $10.00 output
    gpt-4o-mini:  $0.15 input / $0.60  output

CORS: openai.com allows browser-origin requests (works for web demo)
Native (RN): no CORS, just HTTPS

USD/KRW assumption: 1 USD ≈ 1,350 KRW (Jan 2026)
```

### Key Documentation References
```
React Native:        https://reactnative.dev/docs/getting-started
NativeWind:          https://www.nativewind.dev/
React Navigation v6: https://reactnavigation.org/docs/getting-started
React Native Keychain: https://github.com/oblador/react-native-keychain
EncryptedSharedPreferences (Android): https://developer.android.com/topic/security/data
Zustand:             https://github.com/pmndrs/zustand
AsyncStorage:        https://react-native-async-storage.github.io/async-storage/
Fastify:             https://fastify.dev/
Supabase:            https://supabase.com/docs
OpenAI Node SDK:     https://github.com/openai/openai-node
```

---

## 16. QUICK-START CHECKLIST FOR NEW SESSION

```
If you're an AI agent starting fresh in [minimax code] session:

□ 1. Read §1 (essence), §2 (rules), §3 (decisions) — 10 min
□ 2. Skim §4-7 (architecture, data, API, pipeline) — 20 min  
□ 3. Open v5 prototype URL, study UI/UX — 30 min
□ 4. Read v5 source code (`/workspace/mwoaraeogetji-engine-v5/index.html`) — 45 min
□ 5. Plan Phase 0.1-P0.7 implementation — 1 hour
□ 6. Bootstrap RN project
□ 7. Implement BYOK + secure storage
□ 8. Implement 4-layer LLM pipeline
□ 9. Implement profile + diff
□ 10. Copy UI from v5 to RN components
□ 11. Wire 5 base scenarios
□ 12. Run §10 P0 acceptance tests

BEFORE SHIPPING P0:
□ Korean-only validation (grep)
□ BYOK key security audit
□ Pipeline cost ceiling (₩20/session)
□ Cache TTL verified
□ No silent network calls leaking user content
```

---

END OF BLUEPRINT

TOTAL DECISIONS: 8 critical + 8 anti-patterns + 11 categories + 5 phases + 12 verification criteria + 14 file references

NEXT ACTION: Founder to open new [minimax code] session with this blueprint + master plan + v5 prototype URL
