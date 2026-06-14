import {
  downloadOptions,
  featureCards,
  flowSteps,
  gallery,
  interfaceScreens,
  navItems,
  pricing,
  productSummary,
  releaseVersion,
} from './content.js';

const app = document.querySelector('#app');

function html(strings, ...values) {
  return strings.reduce((output, string, index) => {
    const value = values[index] ?? '';
    return output + string + value;
  }, '');
}

function navTemplate() {
  return html`
    <nav class="nav" aria-label="主导航">
      <a class="brand" href="#top">
        <img src="./assets/app-icon.png" alt="BenWo icon" />
        <span>BenWo 本我</span>
      </a>
      <div class="nav-links">
        ${navItems.map((item) => `<a href="${item.href}">${item.label}</a>`).join('')}
      </div>
      <a class="nav-cta" href="#download">下载</a>
    </nav>
  `;
}

function heroTemplate() {
  return html`
    <section id="top" class="hero" aria-labelledby="hero-title">
      <div class="hero-stage"><div class="field"></div></div>
      <div class="kinetic-mark" aria-hidden="true">
        <span class="glass-shard shard-a"></span>
        <span class="glass-shard shard-b"></span>
        <span class="glass-shard shard-c"></span>
      </div>
      <div class="hero-content">
        <div>
          <div class="eyebrow">AI GOAL OPERATING SYSTEM / COMPLETE FLOW</div>
          <h1 id="hero-title">
            <span class="h1-inline">
              BenWo
              <img class="h1-icon" src="./assets/app-icon.png" alt="" />
            </span>
            <br />
            本我
          </h1>
          <p class="hero-sub">
            从认识自己，到拆目标、排日程、准时提醒、完成复盘。本我把长期改变压缩成今天能做的一步。
          </p>
          <div class="hero-actions">
            <a class="btn primary" href="#flow">看完整流程</a>
            <a class="btn" href="#features">功能矩阵</a>
          </div>
        </div>
        <aside class="hero-panel" aria-label="BenWo 今日任务预览">
          <img src="./assets/home-today-dark.jpg" alt="BenWo 今日任务深色界面" />
        </aside>
      </div>
      <div class="signal-row" aria-hidden="true">
        <span class="signal">PROFILE</span>
        <span class="signal">GOAL</span>
        <span class="signal">AI SPLIT</span>
        <span class="signal">TIME PICKER</span>
        <span class="signal">CALENDAR</span>
        <span class="signal">REVIEW</span>
        <span class="signal">PROFILE</span>
      </div>
    </section>
  `;
}

function summaryTemplate() {
  return html`
    <section class="summary">
      <div class="wrap summary-grid">
        <div class="section-title vertical">
          <p class="kicker">PRODUCT FLOW</p>
          <h2>本我，是一条完整行动闭环。</h2>
        </div>
        <ol class="summary-list">
          ${productSummary.map((item) => `<li>${item}</li>`).join('')}
        </ol>
      </div>
    </section>
  `;
}

function interfaceDesignTemplate() {
  return html`
    <section id="interfaces" class="interfaces">
      <div class="wrap">
        <div class="section-title">
          <h2>三个特色功能，三个独立界面。</h2>
          <p>每个界面都只承担一个关键转化：把一句话变成 To-do，把大目标变成每日目标，把用户信息变成个性化计划。</p>
        </div>
        <div class="interface-stack">
          ${interfaceScreens
            .map(
              (screen, index) => html`
                <article class="interface-panel ${index % 2 ? 'reverse' : ''}">
                  <div class="interface-copy">
                    <span class="step-id">${screen.number}</span>
                    <p class="kicker">${screen.label}</p>
                    <h3>${screen.title}</h3>
                    <p>${screen.text}</p>
                    <ul>
                      ${screen.details.map((detail) => `<li>${detail}</li>`).join('')}
                    </ul>
                  </div>
                  <figure class="phone-frame interface-phone">
                    <img src="${screen.image}" alt="${screen.title}界面" />
                  </figure>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
    </section>
  `;
}

function philosophyTemplate() {
  return html`
    <section id="philosophy" class="philosophy">
      <div class="wrap">
        <div class="section-title">
          <h2>设计哲学：三件事互相作用。</h2>
          <p>本我不是把三个功能并排摆放，而是让用户画像影响拆分，让拆分结果进入日历，让完成反馈再回到下一轮计划。</p>
        </div>
        <div class="philosophy-map" aria-label="本我设计哲学关系图">
          <article class="map-node profile-node">
            <span>01</span>
            <h3>用户画像</h3>
            <p>理解身份、节奏、偏好、压力反应。</p>
          </article>
          <article class="map-node goal-node">
            <span>02</span>
            <h3>大目标拆分</h3>
            <p>把长期目标拆成每天可执行的小目标。</p>
          </article>
          <article class="map-node todo-node">
            <span>03</span>
            <h3>小待办拆分</h3>
            <p>把今天的一句话拆成带时间的 To-do。</p>
          </article>
          <article class="map-node calendar-node">
            <span>04</span>
            <h3>日历执行与复盘</h3>
            <p>进入今日、日历、提醒和完成历史。</p>
          </article>
          <div class="map-arrow arrow-a">画像校准计划</div>
          <div class="map-arrow arrow-b">目标进入每日</div>
          <div class="map-arrow arrow-c">待办落到时间</div>
          <div class="map-arrow arrow-d">完成反馈回来</div>
        </div>
      </div>
    </section>
  `;
}

function flowTemplate() {
  return html`
    <section id="flow" class="flow">
      <div class="wrap">
        <div class="section-title">
          <h2>全流程：从模糊愿望到完成历史。</h2>
          <p>每一步都对应用户从建立画像、拆解目标、安排今日到完成复盘的行动路径。</p>
        </div>
        <div class="flow-rail">
          ${flowSteps
            .map(
              (step, index) => html`
                <article class="flow-step ${index % 2 ? 'reverse' : ''}">
                  <div class="step-copy">
                    <span class="step-id">${step.id}</span>
                    <p class="kicker">${step.kicker}</p>
                    <h3>${step.title}</h3>
                    <p>${step.body}</p>
                  </div>
                  <figure class="phone-frame">
                    <img src="${step.image}" alt="${step.title}" data-fallback="${step.fallback}" />
                  </figure>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
    </section>
  `;
}

function featuresTemplate() {
  return html`
    <section id="features" class="features">
      <div class="wrap">
        <div class="section-title">
          <h2>主要功能，不散装。</h2>
          <p>目标、AI、时间、提醒、日历和设置互相咬合，形成一个持续推进系统。</p>
        </div>
        <div class="feature-grid">
          ${featureCards
            .map(
              (card) => html`
                <article class="feature-card">
                  <span>${card.tag}</span>
                  <h3>${card.title}</h3>
                  <p>${card.text}</p>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
    </section>
  `;
}

function calendarTemplate() {
  return html`
    <section id="calendar" class="showcase">
      <div class="wrap showcase-grid">
        <div class="device-collage">
          <figure class="phone tall one">
            <img src="./assets/calendar-week.jpg" alt="BenWo 周日历" />
          </figure>
          <figure class="phone tall two">
            <img src="./assets/completed-history-empty.jpg" alt="BenWo 已完成历史" />
          </figure>
        </div>
        <div class="system-list">
          <div class="section-title vertical">
            <p class="kicker">CALENDAR / REVIEW</p>
            <h2>日历不是展示页，是调度台。</h2>
            <p>用户可以在日、周、月之间切换，隐藏或显示已完成，查看完成历史，把任务拖到另一天继续推进。</p>
          </div>
          <div class="system-line"><strong>日</strong><div>聚焦今天的目标和待完成任务。</div><span>TODAY</span></div>
          <div class="system-line"><strong>周</strong><div>查看一周任务分布和目标数量。</div><span>WEEK</span></div>
          <div class="system-line"><strong>史</strong><div>完成后沉淀历史，形成复盘素材。</div><span>HISTORY</span></div>
        </div>
      </div>
    </section>
  `;
}

function galleryTemplate() {
  return html`
    <section class="gallery-section">
      <div class="wrap">
        <div class="section-title">
          <h2>能用一个界面，就把设计哲学的全过程讲明白。</h2>
          <p>下面四个界面分别展示：如何把一段话拆成任务，如何把任务落到具体时间，如何在日历里执行和复盘，以及设置页如何交代账号、AI 服务、协议和隐私。</p>
        </div>
        <div class="gallery">
          ${gallery
            .map(
              (item) => html`
                <article class="gallery-card">
                  <img src="${item.src}" alt="${item.title}" />
                  <h3>${item.title}</h3>
                  <p>${item.text}</p>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
    </section>
  `;
}

function pricingTemplate() {
  return html`
    <section id="pricing" class="pricing">
      <div class="wrap">
        <div class="section-title">
          <h2>商业化围绕确定性。</h2>
          <p>免费体验核心价值，Pro 提供跨设备、长计划、高额度 AI 和复盘能力。</p>
        </div>
        <div class="price-grid">
          ${pricing
            .map(
              (plan) => html`
                <article class="price ${plan.featured ? 'pro' : ''}">
                  <h3>${plan.name}</h3>
                  <p class="plan-note">${plan.note}</p>
                  <div class="amount">${plan.price}</div>
                  <ul>${plan.points.map((point) => `<li>${point}</li>`).join('')}</ul>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
    </section>
  `;
}

function downloadButtonTemplate(option) {
  if (option.modal) {
    return `<button class="download-btn primary" type="button" data-open-ios>打开 iOS 下载</button>`;
  }

  return option.links
    .map(
      (link, index) =>
        `<a class="download-btn ${index === 0 ? 'primary' : ''}" href="${link.href}" target="_blank" rel="noopener noreferrer">${link.label}</a>`,
    )
    .join('');
}

function downloadTemplate() {
  return html`
    <section id="download" class="download">
      <div class="download-glow" aria-hidden="true"></div>
      <div class="wrap">
        <div class="download-hero">
          <div class="section-title vertical">
            <p class="kicker">DOWNLOAD / ${releaseVersion}</p>
            <h2>已支持全平台</h2>
            <p>Windows、Mac、Android、iOS 四端同源体验。选择你的设备，直接获取对应版本。</p>
          </div>
          <div class="download-showcase" aria-label="BenWo 多平台截图">
            <img class="platform-shot mac-shot" src="./assets/download-macos.jpg" alt="BenWo Mac 版本界面" />
            <img class="platform-shot ios-shot" src="./assets/download-ios.jpg" alt="BenWo iOS 版本界面" />
            <img class="platform-shot android-shot" src="./assets/download-android.jpg" alt="BenWo Android 版本界面" />
            <img class="platform-shot win-login-shot" src="./assets/download-windows-login.jpg" alt="BenWo Windows 登录界面" />
          </div>
        </div>
        <div class="download-grid">
          ${downloadOptions
            .map(
              (option) => html`
                <article class="download-card">
                  <div class="download-media">
                    <img src="${option.image}" alt="${option.title}" />
                    <span>${option.code}</span>
                  </div>
                  <div class="download-copy">
                    <p class="kicker">${option.platform}</p>
                    <h3>${option.title}</h3>
                    <strong>${option.subtitle}</strong>
                    <p>${option.text}</p>
                    <div class="download-actions">
                      ${downloadButtonTemplate(option)}
                    </div>
                  </div>
                </article>
              `,
            )
            .join('')}
        </div>
      </div>
      <div class="ios-modal" data-ios-modal hidden>
        <div class="ios-modal-backdrop" data-close-ios></div>
        <section class="ios-modal-panel" role="dialog" aria-modal="true" aria-labelledby="ios-download-title">
          <button class="modal-close" type="button" data-close-ios aria-label="关闭 iOS 下载面板">×</button>
          <div>
            <p class="kicker">iOS / ${releaseVersion}</p>
            <h2 id="ios-download-title">iPhone 版本下载</h2>
            <p>获取 iOS 安装包，在你的 iPhone 上继续使用 BenWo 的目标、待办、日历和 AI 拆分能力。</p>
          </div>
          <img src="./assets/download-ios.jpg" alt="BenWo iOS 登录界面" />
          <div class="ios-modal-actions">
            <a class="download-btn primary" href="https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-iOS.ipa" target="_blank" rel="noopener noreferrer">下载 iOS IPA</a>
            <button class="download-btn" type="button" data-close-ios>返回选择</button>
          </div>
        </section>
      </div>
    </section>
  `;
}

function finalTemplate() {
  return html`
    <section class="final">
      <div class="wrap">
        <h2>让每个长期目标，都有下一步。</h2>
        <p>本我围绕完整行动路径展开：认识用户、拆解目标、安排今日、进入日历、回到复盘。</p>
        <a class="btn primary" href="#download">立即下载</a>
      </div>
    </section>
  `;
}

function render() {
  app.innerHTML = html`
    <div class="site-shell">
      ${navTemplate()}
      <main>
        ${heroTemplate()}
        ${summaryTemplate()}
        ${interfaceDesignTemplate()}
        ${philosophyTemplate()}
        ${flowTemplate()}
        ${featuresTemplate()}
        ${calendarTemplate()}
        ${galleryTemplate()}
        ${downloadTemplate()}
        ${pricingTemplate()}
        ${finalTemplate()}
      </main>
      <footer class="footer">
        <span>BENWO / AI GOAL OPERATING SYSTEM</span>
        <span>PROFILE -> GOAL -> AI -> CALENDAR -> REVIEW</span>
      </footer>
    </div>
  `;

  document.querySelectorAll('img[data-fallback]').forEach((image) => {
    image.addEventListener(
      'error',
      () => {
        image.src = image.dataset.fallback;
      },
      { once: true },
    );
  });

  const iosModal = document.querySelector('[data-ios-modal]');
  document.querySelectorAll('[data-open-ios]').forEach((button) => {
    button.addEventListener('click', () => {
      iosModal.hidden = false;
      document.body.classList.add('modal-open');
    });
  });

  document.querySelectorAll('[data-close-ios]').forEach((button) => {
    button.addEventListener('click', () => {
      iosModal.hidden = true;
      document.body.classList.remove('modal-open');
    });
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !iosModal.hidden) {
      iosModal.hidden = true;
      document.body.classList.remove('modal-open');
    }
  });
}

render();
