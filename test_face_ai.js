const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    headless: false,
    args: [
      '--use-fake-device-for-media-stream',
      '--use-fake-ui-for-media-stream',
      '--allow-insecure-localhost',
    ]
  });

  const context = await browser.newContext({ permissions: ['camera'] });
  const page = await context.newPage();
  const logs = [];
  const errors = [];

  page.on('console', msg => {
    if (msg.type() === 'error' || /face|model|camera|detect/i.test(msg.text())) {
      logs.push(`[${msg.type()}] ${msg.text()}`);
    }
  });
  page.on('pageerror', err => errors.push(err.message));

  // Login
  await page.goto('http://localhost:5173/login');
  await page.waitForLoadState('networkidle');

  const emailInput = page.locator('input[type="email"], input[placeholder*="mail" i], input[placeholder*="Email" i]').first();
  const emailVisible = await emailInput.isVisible().catch(() => false);
  if (emailVisible) {
    await emailInput.fill('admin@example.com');
    await page.locator('input[type="password"]').first().fill('123456');
    await page.locator('button[type="submit"]').click();
    await page.waitForTimeout(2000);
  }

  const user = await page.evaluate(() => localStorage.getItem('user'));
  console.log('Logged in:', user ? JSON.parse(user)?.email : 'NONE — cần login trước');

  // Vào bài học 1
  await page.goto('http://localhost:5173/lessons/1');
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(4000);

  const pageState = await page.evaluate(() => {
    const statusBadge = document.querySelector('.webcam-status');
    const muteEl = document.querySelector('.muted.compact-alert');
    const alertEl = document.querySelector('.alert.compact-alert');
    const allBtns = Array.from(document.querySelectorAll('.webcam-actions button')).map(b => ({
      text: b.textContent.trim(), disabled: b.disabled,
    }));
    return { webcamStatus: statusBadge?.textContent?.trim(), modelsMsg: muteEl?.textContent?.trim(), alert: alertEl?.textContent?.trim(), buttons: allBtns };
  });

  console.log('\n=== Trạng thái ban đầu (sau 4s) ===');
  console.log('Badge camera:', pageState.webcamStatus);
  console.log('Thông báo models:', pageState.modelsMsg);
  console.log('Alert:', pageState.alert);
  console.log('Buttons:', JSON.stringify(pageState.buttons));

  // Click Bật camera
  const cameraBtn = page.locator('.webcam-actions button', { hasText: /Bật camera/ }).first();
  const camVisible = await cameraBtn.isVisible().catch(() => false);
  const camDisabled = await cameraBtn.isDisabled().catch(() => true);
  console.log('\n=== Nút Bật camera ===');
  console.log('Visible:', camVisible, '| Disabled:', camDisabled);

  if (camVisible && !camDisabled) {
    await cameraBtn.click();
    await page.waitForTimeout(3000);

    const afterCam = await page.evaluate(() => {
      const video = document.querySelector('.webcam-preview video');
      return {
        webcamStatus: document.querySelector('.webcam-status')?.textContent?.trim(),
        alert: document.querySelector('.alert.compact-alert')?.textContent?.trim(),
        videoHasSrcObject: !!video?.srcObject,
        videoPaused: video?.paused,
        videoReadyState: video?.readyState,
      };
    });
    console.log('\n=== Sau khi bật camera (3s) ===');
    console.log(JSON.stringify(afterCam, null, 2));

    // Chờ AI detection chạy
    await page.waitForTimeout(6000);

    const afterDetect = await page.evaluate(() => ({
      focusStatus: document.querySelector('.webcam-status')?.textContent?.trim(),
      alert: document.querySelector('.alert.compact-alert')?.textContent?.trim(),
      scoreDisplay: document.querySelector('.focus-score-display')?.textContent?.trim(),
    }));
    console.log('\n=== Sau 6s (AI detection) ===');
    console.log(JSON.stringify(afterDetect, null, 2));
  }

  if (logs.length) { console.log('\n=== Console Logs ==='); logs.forEach(l => console.log(l)); }
  if (errors.length) { console.log('\n=== Page Errors ==='); errors.forEach(e => console.log(e)); }

  await page.waitForTimeout(2000);
  await browser.close();
})();
