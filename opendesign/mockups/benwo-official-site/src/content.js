export const navItems = [
  { label: '特色界面', href: '#interfaces' },
  { label: '设计哲学', href: '#philosophy' },
  { label: '全流程', href: '#flow' },
  { label: '功能', href: '#features' },
  { label: '日历复盘', href: '#calendar' },
  { label: '下载', href: '#download' },
];

export const productSummary = [
  '登录后通过四步 onboarding 建立用户画像，记录身份、状态、目标周期和偏好。',
  '用户创建长期目标，补充标题、描述、分类、颜色和预期完成日期。',
  'AI 根据目标、自然语言输入和用户画像，把模糊计划拆成可执行待办。',
  '待办进入今日页和日历页，支持日期、精准完成时间、目标关联和预计分钟数。',
  '带精准时间的待办会注册本地到点提醒，完成或取消完成时同步处理提醒。',
  '日历提供日、周、月视图，支持查看任务、移动日期、显示已完成和完成历史。',
  '设置页管理通知、到点提醒、用户画像、账号、AI 服务、用户协议和隐私政策。',
];

export const interfaceScreens = [
  {
    number: '01',
    title: '小待办拆分',
    label: '一句话 -> 多条 To-do -> 时间',
    image: './assets/ai-split-dark.jpg',
    text: '这个界面让用户只输入一句今天想干的事，不要求先整理成清单。AI 拆分开关、数量选择、默认日期、精准完成时间和关联目标放在同一个动作流里，用户从“想到一件事”直接走到“生成多条可执行 To-do”。',
    details: ['输入区承接模糊表达', 'AI 拆分开关明确工作模式', '数量选择控制拆分颗粒度', '日期和精准时间把任务落进日程'],
  },
  {
    number: '02',
    title: '大目标拆分',
    label: '大目标 -> 每天可行的小目标',
    image: './assets/goal-detail-latest.png',
    text: '目标详情界面把长期目标、进度、关联任务和 AI 拆分入口放在一起。用户输入想达成的大目标后，AI 会结合目标内容、截止日期和用户画像，把它拆成每天可以执行的小目标，再进入今日和日历。',
    details: ['目标先被定义清楚', '进度让长期目标可见', 'AI 拆分入口靠近目标上下文', '生成任务承接到日历和今日页'],
  },
  {
    number: '03',
    title: '用户画像',
    label: '先理解人，再安排事',
    image: './assets/profile-user.jpg',
    text: '登录和 onboarding 阶段会了解用户的基础身份、职业状态、所在地区、生活节奏、挑战、MBTI、沟通偏好、最佳工作时间和压力反应。之后大目标拆分、提醒语气和计划强度都围绕这个人调整。',
    details: ['先建立基础身份', '记录生活状态和挑战', '补充沟通与压力偏好', '让计划和提醒不再千人一面'],
  },
];

export const flowSteps = [
  {
    id: '01',
    title: '认识你',
    kicker: '画像 / Onboarding',
    body: '先收集姓名、年龄、职业、地区、生活状态、挑战和期待改变周期，再把 MBTI、沟通偏好、最佳工作时间、压力反应等长期影响计划质量的信息沉淀下来。',
    image: './assets/profile-user.jpg',
    fallback: './assets/settings-reminders.png',
  },
  {
    id: '02',
    title: '设定长期目标',
    kicker: '目标 / Big Goal',
    body: '用户创建目标时输入标题、描述、分类、颜色和完成时间。目标不是孤立卡片，它会成为后续待办、日历、进度和完成庆祝的主线。',
    image: './assets/goal-detail-latest.png',
    fallback: './assets/goals-latest.png',
  },
  {
    id: '03',
    title: 'AI 拆成可执行任务',
    kicker: 'AI 拆分 / Natural Language',
    body: '首页可以输入一段混乱安排，目标详情可以拆长期目标。AI 会识别日期、时间和数量，输出待办内容、安排日期、精准时间和预计分钟数。',
    image: './assets/ai-split-dark.jpg',
    fallback: './assets/ai-split-options.png',
  },
  {
    id: '04',
    title: '安排今天和具体时间',
    kicker: '今日 / Reminder',
    body: '待办进入今日列表后，用户可以关联目标、修改时间、设定预计分钟数。带精准时间的任务会安排到点提醒，执行入口保持清晰。',
    image: './assets/home-today-dark.jpg',
    fallback: './assets/home-latest.png',
  },
  {
    id: '05',
    title: '在日历里调度整周',
    kicker: '日 / 周 / 月',
    body: '日历支持日、周、月三种视图。用户可以查看每一天任务量，把任务移动到其他日期，也可以快速打开已完成历史。',
    image: './assets/calendar-week.jpg',
    fallback: './assets/calendar-day.png',
  },
  {
    id: '06',
    title: '完成、复盘、继续推进',
    kicker: '完成历史 / Review',
    body: '完成后的任务进入历史记录。目标进度会随着关联任务推进，用户可以在日历里回看完成轨迹，下一轮计划继续围绕真实执行情况调整。',
    image: './assets/completed-history-empty.jpg',
    fallback: './assets/completed-history-latest.png',
  },
];

export const featureCards = [
  {
    title: '目标管理',
    text: '创建长期目标，查看进度、目标详情、关联待办和 AI 拆分入口。',
    tag: 'GOALS',
  },
  {
    title: 'AI 待办拆分',
    text: '支持自然语言、目标拆解、AI 自动选择数量、日期时间识别和 JSON 结构化结果。',
    tag: 'AI SPLIT',
  },
  {
    title: '精准时间',
    text: '待办可以设置具体几点几分，时间选择器和到点提醒一起服务执行。',
    tag: 'TIME',
  },
  {
    title: '今日执行',
    text: '首页聚合今日目标和待办，突出 AI 任务、目标标签、预计分钟数和完成动作。',
    tag: 'TODAY',
  },
  {
    title: '日历调度',
    text: '日、周、月视图覆盖短期执行和长期安排，任务可以跨日期移动。',
    tag: 'CALENDAR',
  },
  {
    title: '设置与合规',
    text: '通知、画像、账号、AI 服务、用户协议、隐私政策都在设置页集中管理。',
    tag: 'TRUST',
  },
];

export const gallery = [
  {
    src: './assets/ai-split-dark.jpg',
    title: 'AI 拆分',
    text: '把一段话拆成多个待办，并按日期、数量、时间自动安排。',
  },
  {
    src: './assets/time-picker-dark.jpg',
    title: '精准完成时间',
    text: '选择上午/下午、小时和分钟，让提醒和执行真正落到钟点上。',
  },
  {
    src: './assets/calendar-day-task.jpg',
    title: '日历日视图',
    text: '查看当天进行中的目标、待完成任务和已完成开关。',
  },
  {
    src: './assets/settings-about.jpg',
    title: '设置与 AI 服务',
    text: '版本、作者、DeepSeek API、用户协议和隐私政策清晰可见。',
  },
];

export const pricing = [
  {
    name: 'Free',
    price: '¥0',
    note: '开始认识自己',
    points: ['本地目标和待办', '基础日历', '到点提醒', '每月 20 次 AI'],
  },
  {
    name: 'Pro',
    price: '¥128/年',
    note: '长期目标主力套餐',
    featured: true,
    points: ['跨设备云同步', '每月 1000 次 AI', '365 天目标计划', '周报、月报和完成率统计'],
  },
  {
    name: 'Plus',
    price: '¥58/年',
    note: '轻量自律用户',
    points: ['基础云备份', '每月 100 次 AI', '30 天目标计划', '适合学生和轻量用户'],
  },
];

export const releaseVersion = 'v1.0.9';

export const downloadOptions = [
  {
    platform: 'Windows',
    code: 'WIN',
    title: 'Windows 桌面版',
    subtitle: 'x64 安装包',
    image: './assets/download-windows.jpg',
    text: '适合 Windows 10 / 11 桌面使用，今日任务、目标、日历和设置页完整呈现。',
    links: [
      {
        label: '下载 Windows x64',
        href: 'https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-Windows-x64.zip',
      },
    ],
  },
  {
    platform: 'Mac',
    code: 'MAC',
    title: 'Mac 桌面版',
    subtitle: 'ARM64 / x64 双版本',
    image: './assets/download-macos.jpg',
    text: '覆盖 Apple 芯片和 Intel 芯片设备，桌面窗口、日历视图和登录界面保持一致体验。',
    links: [
      {
        label: '下载 Mac ARM64',
        href: 'https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-macOS-arm64.dmg',
      },
      {
        label: '下载 Mac x64',
        href: 'https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-macOS-x86_64.dmg',
      },
    ],
  },
  {
    platform: 'Android',
    code: 'APK',
    title: 'Android 移动版',
    subtitle: 'APK 安装包',
    image: './assets/download-android.jpg',
    text: '面向安卓手机的深色任务系统，今日页、目标标签、精准时间和底部导航清晰可用。',
    links: [
      {
        label: '下载 Android APK',
        href: 'https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-v1.0.9-latest.apk',
      },
    ],
  },
  {
    platform: 'iOS',
    code: 'IPA',
    title: 'iOS 移动版',
    subtitle: 'IPA 安装包',
    image: './assets/download-ios.jpg',
    text: '为 iPhone 准备的移动版本，登录、AI 拆分和每日待办在小屏上保持沉浸式体验。',
    modal: true,
    links: [
      {
        label: '下载 iOS IPA',
        href: 'https://github.com/jcx396905-gif/benwo/releases/download/v1.0.9/BenWo-iOS.ipa',
      },
    ],
  },
];
