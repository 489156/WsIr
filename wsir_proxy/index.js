const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { GoogleGenAI } = require('@google/genai');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' })); // Support for vision payload

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

const KOREAN_RELATION_RULES = {
  inlaws: "🙇‍♀️ [시댁/처가 어른]: 오해의 소지를 원천 차단하는 극도의 정중함 필수. 쿠션어('아버님/어머님 혹시 바쁘지 않으시면~', '다름이 아니라~')를 적극 사용. 단답형 절대 금지, 다정하고 싹싹한 톤 유지.",
  freelance: "🎨 [프리랜서/외주 클라이언트]: 감정 노동을 배제한 철저한 비즈니스 톤. 무리한 요구나 범위 초과에 대해서는 정중하지만 단호하게 선을 긋고, 계약적/법적 방어선을 구축하는 합쇼체 위주 사용.",
  blind_date: "🥂 [소개팅/썸]: 너무 무겁지도, 너무 가볍지도 않은 텐션. 부담스럽지 않은 선에서 호감을 표현하고, 질문으로 티키타카를 유도. 과도한 이모티콘 자제, 센스 있는 해요체 사용.",
  boss: "👔 [직장 상사/팀장]: 결론부터 보고하는 두괄식 필수. 수동적이지 않게 대안이나 데드라인을 먼저 제시. 깍듯한 합쇼체 적용.",
  client: "💼 [클라이언트/거래처]: 철저한 비즈니스 격식. 완곡한 표현(완충어)과 함께 협력적 태도를 보여주되, 책임 소재가 불분명한 확답은 피할 것.",
  friend: "☕ [친한 친구]: 가식 없는 찐친 모드. 한국 2030 특유의 밈, 초성(ㅋㅋ, ㅎㅎ), 팩트폭력, 혹은 따뜻한 위로 등 맥락에 맞게 유연하게. 띄어쓰기 파괴나 줄임말 허용.",
  senior: "🎓 [직장/학교 선배]: 정중하고 부드러운 존댓말. 싹싹함과 예의바름.",
  colleague: "🤝 [직장 동료]: 상호 존중하는 해요체. 적당히 격식있고 편안한 톤.",
  junior: "🌱 [후배]: 배려와 심리적 안정감을 주는 선배의 톤.",
  professor: "🧑‍🏫 [교수님]: 최고 수준의 격식, 명확하고 예의바른 합쇼체."
};

const jsonSchema = {
  type: "OBJECT",
  properties: {
    analysis: {
      type: "OBJECT",
      properties: {
        intent: { type: "STRING" },
        emotion: { type: "STRING" },
        subtext: { type: "STRING" },
        whatTheyWant: { type: "STRING" },
        strategy: { type: "STRING" },
        redFlags: { type: "ARRAY", items: { type: "STRING" } }
      },
      required: ["intent", "emotion", "subtext", "whatTheyWant", "strategy", "redFlags"]
    },
    candidates: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          tier: { type: "STRING" },
          tone: { type: "STRING" },
          text: { type: "STRING" },
          rationale: { type: "STRING" },
          wowDetail: { type: "STRING" }
        },
        required: ["tier", "tone", "text", "rationale"]
      }
    }
  },
  required: ["analysis", "candidates"]
};

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'wsir_proxy', timestamp: new Date().toISOString() });
});

app.post('/api/v1/generate', async (req, res) => {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey || apiKey === 'YOUR_API_KEY_HERE') {
    return res.status(503).json({ 
      error: 'GEMINI_API_KEY is not configured on the proxy server. Please set a valid key in .env' 
    });
  }

  const { relation, lastMessage, context, history, imageBase64 } = req.body;
  
  if (!lastMessage && !imageBase64) {
    return res.status(400).json({ error: 'Either lastMessage or imageBase64 is required.' });
  }

  const relationRule = KOREAN_RELATION_RULES[relation] || '';
  
  const systemInstruction = `너는 고맥락 한국어 메신저 분석 및 답장 코-파일럿 "WsIr Engine"이다.
상대방 메시지와 대화 맥락, 관계 특성을 심층 분석하라.
[필수 규칙]:
1. 모든 답장은 한국 2030 메신저 구어체(카카오톡/슬랙) 현실감 100%를 반영할 것.
2. 관계(${relation || 'friend'})의 위계와 격식도를 완벽히 준수할 것.
${relationRule ? `3. [특화 관계 지침]: ${relationRule}` : ''}`;

  try {
    let contents = [];
    
    // User message format
    let userMessage = `[대화 관계]: ${relation || 'friend'}\n[대화 맥락/배경]:\n${context || '자유 대화'}\n`;
    
    if (history && Array.isArray(history) && history.length > 0) {
      const historyStr = history.map(c => `${c.side === 'me' ? '[나]' : '[상대방]'}: ${c.text}`).join('\n');
      userMessage += `\n[이전 대화 맥락]\n${historyStr}\n`;
    }
    
    if (lastMessage) {
      userMessage += `\n[상대방의 마지막 메시지]:\n"${lastMessage}"`;
    }
    userMessage += `\n\n위 대화를 분석하고 3가지 톤의 답장 후보(tier: basic, thoughtful, basic)와 1개의 ⚡ Wow Point 전략 답장(tier: wow)을 생성하라.`;
    
    if (imageBase64) {
      let cleanBase64 = imageBase64;
      let mimeType = "image/jpeg";
      
      // Handle data URI prefix e.g. data:image/png;base64,xxxx
      if (imageBase64.includes(';base64,')) {
        const parts = imageBase64.split(';base64,');
        mimeType = parts[0].replace(/^data:/, '') || 'image/jpeg';
        cleanBase64 = parts[1];
      }

      contents.push({
        role: "user",
        parts: [
          { text: userMessage },
          { inlineData: { data: cleanBase64, mimeType: mimeType } }
        ]
      });
    } else {
      contents.push({ role: "user", parts: [{ text: userMessage }] });
    }

    const response = await ai.models.generateContent({
      model: 'gemini-3.8-flash',
      contents: contents,
      config: {
        systemInstruction: systemInstruction,
        responseMimeType: "application/json",
        responseSchema: jsonSchema,
        temperature: 0.7,
      }
    });

    let rawText = response.text() || '{}';
    // Strip markdown code fences if present
    rawText = rawText.replace(/^```json\s*/i, '').replace(/\s*```$/, '').trim();
    
    const result = JSON.parse(rawText);
    res.json(result);

  } catch (error) {
    console.error('Error calling Gemini API:', error);
    res.status(500).json({ 
      error: 'Failed to generate response', 
      details: error.message || String(error) 
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`WsIr Proxy Server running on port ${PORT}`);
});
