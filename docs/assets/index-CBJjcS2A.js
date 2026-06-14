(function(){const s=document.createElement("link").relList;if(s&&s.supports&&s.supports("modulepreload"))return;for(const i of document.querySelectorAll('link[rel="modulepreload"]'))o(i);new MutationObserver(i=>{for(const t of i)if(t.type==="childList")for(const n of t.addedNodes)n.tagName==="LINK"&&n.rel==="modulepreload"&&o(n)}).observe(document,{childList:!0,subtree:!0});function l(i){const t={};return i.integrity&&(t.integrity=i.integrity),i.referrerPolicy&&(t.referrerPolicy=i.referrerPolicy),i.crossOrigin==="use-credentials"?t.credentials="include":i.crossOrigin==="anonymous"?t.credentials="omit":t.credentials="same-origin",t}function o(i){if(i.ep)return;i.ep=!0;const t=l(i);fetch(i.href,t)}})();const d=[{label:"特色界面",href:"#interfaces"},{label:"设计哲学",href:"#philosophy"},{label:"全流程",href:"#flow"},{label:"功能",href:"#features"},{label:"日历复盘",href:"#calendar"},{label:"下载",href:"#download"}],c=["登录后通过四步 onboarding 建立用户画像，记录身份、状态、目标周期和偏好。","用户创建长期目标，补充标题、描述、分类、颜色和预期完成日期。","AI 根据目标、自然语言输入和用户画像，把模糊计划拆成可执行待办。","待办进入今日页和日历页，支持日期、精准完成时间、目标关联和预计分钟数。","带精准时间的待办会注册本地到点提醒，完成或取消完成时同步处理提醒。","日历提供日、周、月视图，支持查看任务、移动日期、显示已完成和完成历史。","设置页管理通知、到点提醒、用户画像、账号、AI 服务、用户协议和隐私政策。"],p=[{number:"01",title:"小待办拆分",label:"一句话 -> 多条 To-do -> 时间",image:"./assets/ai-split-dark.jpg",text:"这个界面让用户只输入一句今天想干的事，不要求先整理成清单。AI 拆分开关、数量选择、默认日期、精准完成时间和关联目标放在同一个动作流里，用户从“想到一件事”直接走到“生成多条可执行 To-do”。",details:["输入区承接模糊表达","AI 拆分开关明确工作模式","数量选择控制拆分颗粒度","日期和精准时间把任务落进日程"]},{number:"02",title:"大目标拆分",label:"大目标 -> 每天可行的小目标",image:"./assets/goal-detail-latest.png",text:"目标详情界面把长期目标、进度、关联任务和 AI 拆分入口放在一起。用户输入想达成的大目标后，AI 会结合目标内容、截止日期和用户画像，把它拆成每天可以执行的小目标，再进入今日和日历。",details:["目标先被定义清楚","进度让长期目标可见","AI 拆分入口靠近目标上下文","生成任务承接到日历和今日页"]},{number:"03",title:"用户画像",label:"先理解人，再安排事",image:"./assets/profile-user.jpg",text:"登录和 onboarding 阶段会了解用户的基础身份、职业状态、所在地区、生活节奏、挑战、MBTI、沟通偏好、最佳工作时间和压力反应。之后大目标拆分、提醒语气和计划强度都围绕这个人调整。",details:["先建立基础身份","记录生活状态和挑战","补充沟通与压力偏好","让计划和提醒不再千人一面"]}],m=[{id:"01",title:"认识你",kicker:"画像 / Onboarding",body:"先收集姓名、年龄、职业、地区、生活状态、挑战和期待改变周期，再把 MBTI、沟通偏好、最佳工作时间、压力反应等长期影响计划质量的信息沉淀下来。",image:"./assets/profile-user.jpg",fallback:"./assets/settings-reminders.png"},{id:"02",title:"设定长期目标",kicker:"目标 / Big Goal",body:"用户创建目标时输入标题、描述、分类、颜色和完成时间。目标不是孤立卡片，它会成为后续待办、日历、进度和完成庆祝的主线。",image:"./assets/goal-detail-latest.png",fallback:"./assets/goals-latest.png"},{id:"03",title:"AI 拆成可执行任务",kicker:"AI 拆分 / Natural Language",body:"首页可以输入一段混乱安排，目标详情可以拆长期目标。AI 会识别日期、时间和数量，输出待办内容、安排日期、精准时间和预计分钟数。",image:"./assets/ai-split-dark.jpg",fallback:"./assets/ai-split-options.png"},{id:"04",title:"安排今天和具体时间",kicker:"今日 / Reminder",body:"待办进入今日列表后，用户可以关联目标、修改时间、设定预计分钟数。带精准时间的任务会安排到点提醒，执行入口保持清晰。",image:"./assets/home-today-dark.jpg",fallback:"./assets/home-latest.png"},{id:"05",title:"在日历里调度整周",kicker:"日 / 周 / 月",body:"日历支持日、周、月三种视图。用户可以查看每一天任务量，把任务移动到其他日期，也可以快速打开已完成历史。",image:"./assets/calendar-week.jpg",fallback:"./assets/calendar-day.png"},{id:"06",title:"完成、复盘、继续推进",kicker:"完成历史 / Review",body:"完成后的任务进入历史记录。目标进度会随着关联任务推进，用户可以在日历里回看完成轨迹，下一轮计划继续围绕真实执行情况调整。",image:"./assets/completed-history-empty.jpg",fallback:"./assets/completed-history-latest.png"}],g=[{title:"目标管理",text:"创建长期目标，查看进度、目标详情、关联待办和 AI 拆分入口。",tag:"GOALS"},{title:"AI 待办拆分",text:"支持自然语言、目标拆解、AI 自动选择数量、日期时间识别和 JSON 结构化结果。",tag:"AI SPLIT"},{title:"精准时间",text:"待办可以设置具体几点几分，时间选择器和到点提醒一起服务执行。",tag:"TIME"},{title:"今日执行",text:"首页聚合今日目标和待办，突出 AI 任务、目标标签、预计分钟数和完成动作。",tag:"TODAY"},{title:"日历调度",text:"日、周、月视图覆盖短期执行和长期安排，任务可以跨日期移动。",tag:"CALENDAR"},{title:"设置与合规",text:"通知、画像、账号、AI 服务、用户协议、隐私政策都在设置页集中管理。",tag:"TRUST"}],v=[{src:"./assets/ai-split-dark.jpg",title:"AI 拆分",text:"把一段话拆成多个待办，并按日期、数量、时间自动安排。"},{src:"./assets/time-picker-dark.jpg",title:"精准完成时间",text:"选择上午/下午、小时和分钟，让提醒和执行真正落到钟点上。"},{src:"./assets/calendar-day-task.jpg",title:"日历日视图",text:"查看当天进行中的目标、待完成任务和已完成开关。"},{src:"./assets/settings-about.jpg",title:"设置与 AI 服务",text:"版本、作者、DeepSeek API、用户协议和隐私政策清晰可见。"}],h=[{name:"Free",price:"¥0",note:"开始认识自己",points:["本地目标和待办","基础日历","到点提醒","每月 20 次 AI"]},{name:"Pro",price:"¥128/年",note:"长期目标主力套餐",featured:!0,points:["跨设备云同步","每月 1000 次 AI","365 天目标计划","周报、月报和完成率统计"]},{name:"Plus",price:"¥58/年",note:"轻量自律用户",points:["基础云备份","每月 100 次 AI","30 天目标计划","适合学生和轻量用户"]}],r="v1.0.9",u=[{platform:"Windows",code:"WIN",title:"Windows 桌面版",subtitle:"x64 安装包",image:"./assets/download-windows.jpg",text:"适合 Windows 10 / 11 桌面使用，今日任务、目标、日历和设置页完整呈现。",links:[{label:"下载 Windows x64",href:"https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-Windows-x64.zip"}]},{platform:"Mac",code:"MAC",title:"Mac 桌面版",subtitle:"ARM64 / x64 双版本",image:"./assets/download-macos.jpg",text:"覆盖 Apple 芯片和 Intel 芯片设备，桌面窗口、日历视图和登录界面保持一致体验。",links:[{label:"下载 Mac ARM64",href:"https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-macOS-arm64.dmg"},{label:"下载 Mac x64",href:"https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-macOS-x86_64.dmg"}]},{platform:"Android",code:"APK",title:"Android 移动版",subtitle:"APK 安装包",image:"./assets/download-android.jpg",text:"面向安卓手机的深色任务系统，今日页、目标标签、精准时间和底部导航清晰可用。",links:[{label:"下载 Android APK",href:"https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-v1.0.9-latest.apk"}]},{platform:"iOS",code:"IPA",title:"iOS 移动版",subtitle:"IPA 安装包",image:"./assets/download-ios.jpg",text:"为 iPhone 准备的移动版本，登录、AI 拆分和每日待办在小屏上保持沉浸式体验。",modal:!0,links:[{label:"下载 iOS IPA",href:"https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-iOS.ipa"}]}],f=document.querySelector("#app");function e(a,...s){return a.reduce((l,o,i)=>{const t=s[i]??"";return l+o+t},"")}function b(){return e`
    <nav class="nav" aria-label="主导航">
      <a class="brand" href="#top">
        <img src="./assets/app-icon.png" alt="BenWo icon" />
        <span>BenWo 本我</span>
      </a>
      <div class="nav-links">
        ${d.map(a=>`<a href="${a.href}">${a.label}</a>`).join("")}
      </div>
      <a class="nav-cta" href="#download">下载</a>
    </nav>
  `}function w(){return e`
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
  `}function y(){return e`
    <section class="summary">
      <div class="wrap summary-grid">
        <div class="section-title vertical">
          <p class="kicker">PRODUCT FLOW</p>
          <h2>本我，是一条完整行动闭环。</h2>
        </div>
        <ol class="summary-list">
          ${c.map(a=>`<li>${a}</li>`).join("")}
        </ol>
      </div>
    </section>
  `}function A(){return e`
    <section id="interfaces" class="interfaces">
      <div class="wrap">
        <div class="section-title">
          <h2>三个特色功能，三个独立界面。</h2>
          <p>每个界面都只承担一个关键转化：把一句话变成 To-do，把大目标变成每日目标，把用户信息变成个性化计划。</p>
        </div>
        <div class="interface-stack">
          ${p.map((a,s)=>e`
                <article class="interface-panel ${s%2?"reverse":""}">
                  <div class="interface-copy">
                    <span class="step-id">${a.number}</span>
                    <p class="kicker">${a.label}</p>
                    <h3>${a.title}</h3>
                    <p>${a.text}</p>
                    <ul>
                      ${a.details.map(l=>`<li>${l}</li>`).join("")}
                    </ul>
                  </div>
                  <figure class="phone-frame interface-phone">
                    <img src="${a.image}" alt="${a.title}界面" />
                  </figure>
                </article>
              `).join("")}
        </div>
      </div>
    </section>
  `}function $(){return e`
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
  `}function k(){return e`
    <section id="flow" class="flow">
      <div class="wrap">
        <div class="section-title">
          <h2>全流程：从模糊愿望到完成历史。</h2>
          <p>每一步都对应用户从建立画像、拆解目标、安排今日到完成复盘的行动路径。</p>
        </div>
        <div class="flow-rail">
          ${m.map((a,s)=>e`
                <article class="flow-step ${s%2?"reverse":""}">
                  <div class="step-copy">
                    <span class="step-id">${a.id}</span>
                    <p class="kicker">${a.kicker}</p>
                    <h3>${a.title}</h3>
                    <p>${a.body}</p>
                  </div>
                  <figure class="phone-frame">
                    <img src="${a.image}" alt="${a.title}" data-fallback="${a.fallback}" />
                  </figure>
                </article>
              `).join("")}
        </div>
      </div>
    </section>
  `}function I(){return e`
    <section id="features" class="features">
      <div class="wrap">
        <div class="section-title">
          <h2>主要功能，不散装。</h2>
          <p>目标、AI、时间、提醒、日历和设置互相咬合，形成一个持续推进系统。</p>
        </div>
        <div class="feature-grid">
          ${g.map(a=>e`
                <article class="feature-card">
                  <span>${a.tag}</span>
                  <h3>${a.title}</h3>
                  <p>${a.text}</p>
                </article>
              `).join("")}
        </div>
      </div>
    </section>
  `}function O(){return e`
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
  `}function j(){return e`
    <section class="gallery-section">
      <div class="wrap">
        <div class="section-title">
          <h2>能用一个界面，就把设计哲学的全过程讲明白。</h2>
          <p>下面四个界面分别展示：如何把一段话拆成任务，如何把任务落到具体时间，如何在日历里执行和复盘，以及设置页如何交代账号、AI 服务、协议和隐私。</p>
        </div>
        <div class="gallery">
          ${v.map(a=>e`
                <article class="gallery-card">
                  <img src="${a.src}" alt="${a.title}" />
                  <h3>${a.title}</h3>
                  <p>${a.text}</p>
                </article>
              `).join("")}
        </div>
      </div>
    </section>
  `}function W(){return e`
    <section id="pricing" class="pricing">
      <div class="wrap">
        <div class="section-title">
          <h2>商业化围绕确定性。</h2>
          <p>免费体验核心价值，Pro 提供跨设备、长计划、高额度 AI 和复盘能力。</p>
        </div>
        <div class="price-grid">
          ${h.map(a=>e`
                <article class="price ${a.featured?"pro":""}">
                  <h3>${a.name}</h3>
                  <p class="plan-note">${a.note}</p>
                  <div class="amount">${a.price}</div>
                  <ul>${a.points.map(s=>`<li>${s}</li>`).join("")}</ul>
                </article>
              `).join("")}
        </div>
      </div>
    </section>
  `}function S(a){return a.modal?'<button class="download-btn primary" type="button" data-open-ios>打开 iOS 下载</button>':a.links.map((s,l)=>`<a class="download-btn ${l===0?"primary":""}" href="${s.href}" target="_blank" rel="noopener noreferrer">${s.label}</a>`).join("")}function T(){return e`
    <section id="download" class="download">
      <div class="download-glow" aria-hidden="true"></div>
      <div class="wrap">
        <div class="download-hero">
          <div class="section-title vertical">
            <p class="kicker">DOWNLOAD / ${r}</p>
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
          ${u.map(a=>e`
                <article class="download-card">
                  <div class="download-media">
                    <img src="${a.image}" alt="${a.title}" />
                    <span>${a.code}</span>
                  </div>
                  <div class="download-copy">
                    <p class="kicker">${a.platform}</p>
                    <h3>${a.title}</h3>
                    <strong>${a.subtitle}</strong>
                    <p>${a.text}</p>
                    <div class="download-actions">
                      ${S(a)}
                    </div>
                  </div>
                </article>
              `).join("")}
        </div>
      </div>
      <div class="ios-modal" data-ios-modal hidden>
        <div class="ios-modal-backdrop" data-close-ios></div>
        <section class="ios-modal-panel" role="dialog" aria-modal="true" aria-labelledby="ios-download-title">
          <button class="modal-close" type="button" data-close-ios aria-label="关闭 iOS 下载面板">×</button>
          <div>
            <p class="kicker">iOS / ${r}</p>
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
  `}function E(){return e`
    <section class="final">
      <div class="wrap">
        <h2>让每个长期目标，都有下一步。</h2>
        <p>本我围绕完整行动路径展开：认识用户、拆解目标、安排今日、进入日历、回到复盘。</p>
        <a class="btn primary" href="#download">立即下载</a>
      </div>
    </section>
  `}function x(){f.innerHTML=e`
    <div class="site-shell">
      ${b()}
      <main>
        ${w()}
        ${y()}
        ${A()}
        ${$()}
        ${k()}
        ${I()}
        ${O()}
        ${j()}
        ${T()}
        ${W()}
        ${E()}
      </main>
      <footer class="footer">
        <span>BENWO / AI GOAL OPERATING SYSTEM</span>
        <span>PROFILE -> GOAL -> AI -> CALENDAR -> REVIEW</span>
      </footer>
    </div>
  `,document.querySelectorAll("img[data-fallback]").forEach(s=>{s.addEventListener("error",()=>{s.src=s.dataset.fallback},{once:!0})});const a=document.querySelector("[data-ios-modal]");document.querySelectorAll("[data-open-ios]").forEach(s=>{s.addEventListener("click",()=>{a.hidden=!1,document.body.classList.add("modal-open")})}),document.querySelectorAll("[data-close-ios]").forEach(s=>{s.addEventListener("click",()=>{a.hidden=!0,document.body.classList.remove("modal-open")})}),document.addEventListener("keydown",s=>{s.key==="Escape"&&!a.hidden&&(a.hidden=!0,document.body.classList.remove("modal-open"))})}x();
