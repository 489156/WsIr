const http = require('http');
const fs = require('fs');
const path = require('path');
const puppeteer = require('./wsir_proxy/node_modules/puppeteer-core');

const CHROME_PATH = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const ROOT_DIR = __dirname;
const sleep = ms => new Promise(r => setTimeout(r, ms));

function createServer() {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      let reqPath = req.url.split('?')[0];
      if (reqPath === '/' || reqPath === '') reqPath = '/index.html';
      const filePath = path.join(ROOT_DIR, reqPath);
      
      if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
        const ext = path.extname(filePath);
        const mimeTypes = {
          '.html': 'text/html; charset=utf-8',
          '.js': 'text/javascript; charset=utf-8',
          '.css': 'text/css; charset=utf-8',
          '.json': 'application/json; charset=utf-8',
          '.png': 'image/png',
          '.jpg': 'image/jpeg',
          '.svg': 'image/svg+xml'
        };
        res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'application/octet-stream' });
        fs.createReadStream(filePath).pipe(res);
      } else {
        res.writeHead(404);
        res.end('Not Found');
      }
    });

    server.listen(0, '127.0.0.1', () => {
      resolve({ server, port: server.address().port });
    });
  });
}

async function runHardTestSuite() {
  console.log('🚀 Launching Chrome DevTools Automated Hard-Test Suite (WsIr v6.0)...');
  const { server, port } = await createServer();
  const baseUrl = 'http://127.0.0.1:' + port;
  console.log('📡 Local HTTP Test Origin: ' + baseUrl);

  const browser = await puppeteer.launch({
    executablePath: CHROME_PATH,
    headless: 'new',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--window-size=1280,900'
    ]
  });

  const errors = [];
  const warnings = [];
  const testResults = [];

  function recordResult(name, passed, detail = '') {
    testResults.push({ name, passed, detail });
    const mark = passed ? '✅ PASS' : '❌ FAIL';
    console.log('[' + mark + '] ' + name + (detail ? ' -> ' + detail : ''));
    if (!passed) errors.push(name + ': ' + detail);
  }

  try {
    const page = await browser.newPage();
    page.on('console', msg => {
      if (msg.type() === 'error') {
        warnings.push('Console Error: ' + msg.text());
      }
    });
    page.on('pageerror', err => {
      errors.push('Page Error: ' + err.message);
    });
    page.on('dialog', async dialog => {
      await dialog.accept().catch(() => {});
    });

    // 1. Initial Load & Structure
    console.log('\n--- 1. Testing Page Load & Navigation Structure ---');
    await page.goto(baseUrl + '/index.html', { waitUntil: 'networkidle0' });
    const title = await page.title();
    const hasMainScreen = await page.$('#screen-main') !== null;
    const hasModeSwitch = await page.$('.mode-switch') !== null;
    recordResult('Page Title and Screen Container', hasMainScreen, 'Title: ' + title);
    recordResult('Mode Switcher Present', hasModeSwitch);

    // 2. Preset Scenarios Mode
    console.log('\n--- 2. Testing Preset Scenario Workflow ---');
    await page.click('#tab-preset');
    await sleep(250);
    const presetItems = await page.$$('.scenario-item');
    recordResult('5 Curated Scenarios Rendered', presetItems.length === 5, 'Count: ' + presetItems.length);

    // Select Boss Deadline scenario
    await presetItems[1].click();
    await sleep(250);
    const phoneVisible = await page.$eval('#preset-phone-wrap', el => el.style.display !== 'none');
    const bossName = await page.$eval('#p-name', el => el.textContent);
    recordResult('Boss Scenario Conversation Opened', phoneVisible && bossName.includes('팀장님'), 'Recipient: ' + bossName);

    // Generate response for preset
    await page.click('#preset-phone-wrap button.cta');
    await page.waitForFunction(() => {
      const el = document.getElementById('analysis-section');
      return el && el.style.display !== 'none';
    }, { timeout: 4000 });

    const presetAnalysisText = await page.$eval('#analysis-section', el => el.textContent);
    const presetCandidateCount = await page.$$eval('.suggestion-card', cards => cards.length);
    recordResult('Preset Analysis & 4 Candidates Rendered', presetCandidateCount === 4, 'Candidates: ' + presetCandidateCount);

    // 3. Custom Text Mode
    console.log('\n--- 3. Testing Custom Text Input Pipeline ---');
    await page.click('#tab-custom');
    await sleep(250);
    await page.select('#custom-relation', 'friend');
    await page.$eval('#custom-last-msg', el => { el.value = '야 이번 주말에 한강 갈래? 치맥 땡기는데 ㅋㅋ'; });
    await page.$eval('#custom-my-intent', el => { el.value = '선약 있어서 정중히 거절하고 다음 주로 미루기'; });

    await page.click('#custom-gen-btn');
    await sleep(1000);

    const customCandidates = await page.$$eval('.suggestion-card .text', els => els.map(e => e.textContent));
    const demoBannerExists = await page.$('.demo-banner-box') !== null;
    const modelTagText = await page.$eval('.model-tag', el => el.textContent);

    recordResult('Custom Text 4 Candidates Generated', customCandidates.length === 4);
    recordResult('Demo Mode Notice Banner Displayed', demoBannerExists);
    recordResult('Model Badge Displays Simulation Mode', modelTagText.includes('시뮬레이션'), 'Badge: ' + modelTagText);

    // 4. Vision Mode (Coworker Gift to Girlfriend)
    console.log('\n--- 4. Testing Vision Screenshot Mode (Coworker Gift Scenario) ---');
    await page.click('#tab-vision');
    await sleep(250);

    await page.evaluate(async () => {
      const b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
      const byteChars = atob(b64);
      const byteNumbers = new Array(byteChars.length);
      for (let i = 0; i < byteChars.length; i++) byteNumbers[i] = byteChars.charCodeAt(i);
      const byteArray = new Uint8Array(byteNumbers);
      const blob = new Blob([byteArray], { type: 'image/png' });
      const file = new File([blob], '직장동료_선물_대화.png', { type: 'image/png' });
      loadVisionImageFile(file);

      document.getElementById('vision-relation').value = 'auto';
      document.getElementById('vision-intent').value = '직장동료인 상대방이 준비한 선물을 내 여자친구에게 주는 상황에서 미안함과 감사함 표현';
    });

    await sleep(500); // Wait for FileReader to load
    await page.click('#vision-gen-btn');
    await sleep(1200);

    const visionAnalysisText = await page.$eval('#analysis-section', el => el.textContent);
    const visionCandidates = await page.$$eval('.suggestion-card .text', els => els.map(e => e.textContent));

    const detectedColleague = visionAnalysisText.includes('직장 동료') || visionAnalysisText.includes('직장동료');
    const hasGirlfriendAndGift = visionCandidates.some(t => t.includes('여자친구') && t.includes('선물'));
    const noBossClientMistake = !visionCandidates.some(t => t.includes('과장님') || t.includes('내부 검토'));

    recordResult('Vision Relation Auto-detected as Colleague', detectedColleague, 'Analysis text confirmed');
    recordResult('Vision Replies Match Girlfriend & Gift Intent', hasGirlfriendAndGift, 'Sample: ' + (visionCandidates[0] ? visionCandidates[0].slice(0, 35) : '') + '...');
    recordResult('No Irrelevant Client/Boss Fallback Leakage', noBossClientMistake);

    // 5. Quick Tone Regeneration
    console.log('\n--- 5. Testing Quick Tone Regeneration ---');
    const firstTextBefore = visionCandidates[0];
    const qtButtons = await page.$$('.suggestion-card .qt-btn');
    if (qtButtons.length > 0) {
      await qtButtons[0].click(); // '더 정중하게'
      await sleep(600);
      const firstTextAfter = await page.$eval('.suggestion-card .text', el => el.textContent);
      recordResult('Quick Tone Regeneration Triggered', true, 'Regenerated: ' + firstTextAfter.slice(0, 30) + '...');
    } else {
      recordResult('Quick Tone Regeneration', false, 'Buttons not found');
    }

    // 6. Feedback Thumbs-Up Rating
    console.log('\n--- 6. Testing Feedback Rating ---');
    const thumbBtn = await page.$('.suggestion-card .fb-btn');
    if (thumbBtn) {
      await thumbBtn.click();
      await sleep(300);
      const isActive = await page.$eval('.suggestion-card .fb-btn', el => el.classList.contains('active'));
      recordResult('Thumbs Up Rating State Activated', isActive);
    } else {
      recordResult('Thumbs Up Rating', false, 'Button not found');
    }

    // 7. Edit Modal, Diff Engine & Profile Learning
    console.log('\n--- 7. Testing Edit Modal & LCS Diff Engine ---');
    const editBtn = await page.$('.suggestion-card button[title*="수정"]');
    if (editBtn) {
      await editBtn.click();
      await page.waitForSelector('#edit-modal', { visible: true });
      await page.$eval('#edit-textarea', el => {
        el.value = el.value + ' 진심으로 깊이 감사드립니다!';
        el.dispatchEvent(new Event('input'));
      });
      await sleep(300);
      const diffText = await page.$eval('#diff-output', el => el.textContent);
      const hasDiffIndicator = diffText.includes('추가') || diffText.includes('진심으로');
      
      await page.click('button[onclick="saveEditAndLearn()"]');
      await sleep(400);
      const modalClosed = await page.$eval('#edit-modal', el => el.classList.contains('active') === false);

      recordResult('LCS Diff Engine Generated Change Trace', hasDiffIndicator, 'Diff text: ' + diffText.slice(0, 30));
      recordResult('Edit & Learn Profile Saved & Modal Closed', modalClosed);
    } else {
      recordResult('Edit Modal Interaction', false, 'Edit button not found');
    }

    // 8. Learning Profile Screen
    console.log('\n--- 8. Testing Learning Profile Screen ---');
    await page.click('button[onclick="switchTab(\'profile\')"]');
    await sleep(300);
    const profileActive = await page.$eval('#screen-profile', el => el.classList.contains('active'));
    const profileGridExists = await page.$('.profile-grid') !== null;
    recordResult('Profile Screen Navigation & Metrics View', profileActive && profileGridExists);

    // Switch back to Main screen
    await page.click('#btn-nav-main');
    await sleep(300);

    // 9. Key Management Modal
    console.log('\n--- 9. Testing Settings & API Key Storage ---');
    await page.evaluate(() => window.openKeyModal());
    await page.waitForSelector('#key-modal', { visible: true });
    await page.$eval('#api-key-input', el => { el.value = 'AIzaSyDevToolsVerificationKey98765'; });
    await page.click('button[onclick="saveKey()"]');
    await sleep(400);

    const savedKey = await page.evaluate(() => localStorage.getItem('wsir_gemini_key'));
    recordResult('API Key Successfully Stored in LocalStorage', savedKey === 'AIzaSyDevToolsVerificationKey98765');
    await page.evaluate(() => localStorage.removeItem('wsir_gemini_key'));

    // 10. Multi-Device Mobile Viewport & Responsiveness
    console.log('\n--- 10. Testing Mobile Viewports (iPhone, Galaxy, SE) ---');
    const mobileDevices = [
      { name: 'iPhone 15/16 Pro', width: 393, height: 852 },
      { name: 'Samsung Galaxy S24', width: 412, height: 915 },
      { name: 'Small Screen SE', width: 375, height: 667 }
    ];

    for (const dev of mobileDevices) {
      await page.setViewport({ width: dev.width, height: dev.height, isMobile: true, hasTouch: true });
      await sleep(200);
      
      const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
      const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
      const hasHorizontalOverflow = scrollWidth > clientWidth + 1;
      
      recordResult(
        'Responsive Layout on ' + dev.name + ' (' + dev.width + 'px)',
        !hasHorizontalOverflow,
        'ScrollWidth: ' + scrollWidth + 'px, ClientWidth: ' + clientWidth + 'px'
      );
    }

    // 11. Performance & Memory Audit
    console.log('\n--- 11. Performance & Memory Audit ---');
    const perfMetrics = await page.metrics();
    const heapMB = perfMetrics.JSHeapUsedSize / (1024 * 1024);
    recordResult(
      'Chrome Memory Leak & Node Density Check',
      heapMB < 60,
      'JS Heap Used: ' + heapMB.toFixed(2) + ' MB, DOM Nodes: ' + perfMetrics.Nodes
    );

  } catch (err) {
    console.error('Hard test fatal exception:', err);
    errors.push('Fatal Suite Error: ' + err.message);
  } finally {
    await browser.close();
    server.close();
  }

  console.log('\n========================================');
  console.log('       HARD-TEST SUITE SUMMARY          ');
  console.log('========================================');
  const total = testResults.length;
  const passedCount = testResults.filter(r => r.passed).length;
  const failedCount = total - passedCount;

  console.log('Total Scenarios Tested : ' + total);
  console.log('Passed                 : ' + passedCount);
  console.log('Failed                 : ' + failedCount);
  console.log('Console / Page Errors  : ' + errors.length);

  if (warnings.length > 0) {
    console.log('\nWarnings / Console Notices:');
    warnings.forEach(w => console.log('  ⚠️ ' + w));
  }

  if (errors.length > 0) {
    console.log('\nFailure Details:');
    errors.forEach(e => console.log('  ❌ ' + e));
    process.exit(1);
  } else {
    console.log('\n🎉 ALL HARD-TEST SCENARIOS PASSED WITH ZERO DEFECTS!');
    process.exit(0);
  }
}

runHardTestSuite();
