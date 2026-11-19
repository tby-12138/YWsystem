# 运维管理系统 · 在线演示

单文件静态页面（`index.html`），无后端、无外部 CDN 依赖。数据可以像博客一样，以 JSON 文件提交到仓库，页面打开时自动读取。

## 发布后的链接

`https://<你的GitHub用户名>.github.io/<仓库名>/`

你的页面仓库是 `YWsystem`，所以链接是：

`https://tby-12138.github.io/YWsystem/`

---

# 一、博客式数据（推荐）

数据文件：`data/ops-data.json`

页面启动时会自动请求同目录下的 `data/ops-data.json`，把它作为当前数据。这样数据就在 Git 仓库里，有提交历史，换设备/清缓存也不会丢。

## 目录结构

```text
YWsystem/
├── index.html
├── data/
│   └── ops-data.json
├── README.md
└── .nojekyll          （可选）
```

## 首次部署

1. 把 `index.html` 上传到页面仓库根目录。
2. 新建 `data` 目录，把 `data/ops-data.json` 上传进去。
3. 提交（Commit changes）。
4. Settings → Pages：
   - Source：Deploy from a branch
   - Branch：main
   - Folder：/ (root)
   - Save
5. 等 1–2 分钟，打开 `https://tby-12138.github.io/YWsystem/`。

页面会自动加载 `data/ops-data.json`，顶部会提示「已加载 data/ops-data.json」。

## 以后怎么更新数据

1. 打开页面，正常编辑巡检、记录、资产等数据。
2. 点顶栏 **「云同步」** → **「下载数据 JSON」**，得到 `ops-data.json`。
3. 到 GitHub 仓库：
   - 进入 `data/` 目录
   - Add file → Upload files，上传新的 `ops-data.json`（覆盖原文件）
   - Commit changes
4. 等 GitHub Pages 重新发布（约 1 分钟），刷新页面即可看到新数据。

也可以直接编辑 `data/ops-data.json` 后提交；格式就是页面下载的 JSON。

## 数据公开提醒

页面仓库是 **public**，`data/ops-data.json` 也会公开。里面的 IP、账号、密码、巡检记录所有人都能看到。

- 只放演示数据没问题。
- 如果要存真实 IP/密码，**不要用这个公开文件**，改用下面的「私有数据仓库」方案。

---

# 二、私有数据仓库 + Token（可选）

如果数据不能公开，可以把数据放到一个 **private** 仓库，页面通过 GitHub API 读写，不写进公开仓库。

1. 新建 private 仓库：`YWsystem-data`，勾选 Add a README。
2. 建 fine-grained Token：
   - Repository access：Only select repositories → `YWsystem-data`
   - Permissions：Contents → Read and write
3. 页面 → 云同步：
   - owner：`tby-12138`
   - repo：`YWsystem-data`
   - branch：`main`
   - path：`data/ops-data.json`
   - token：粘贴
4. 测试连接 → 保存设置 → 保存到 GitHub。

页面检测到本机有云同步配置时，会**跳过**公开的 `data/ops-data.json`，改用私有仓库。

Token 只保存在你浏览器 localStorage，不会写进页面或 Git；公共电脑用完点「清除本机配置」。

---

# 三、页面部署

## 方式一：网页上传

1. GitHub 新建 public 仓库（如 `YWsystem`），不要勾 Add a README。
2. Add file → Upload files：`index.html`、`README.md`、`data/ops-data.json`。
3. Commit。
4. Settings → Pages → Deploy from a branch → `main` / `/ (root)` → Save。

## 方式二：Git 推送

```bash
git init
git add .
git commit -m "Deploy ops console"
git branch -M main
git remote add origin https://github.com/tby-12138/YWsystem.git
git push -u origin main
```

Windows 也可以：

```powershell
.\publish.ps1 -RepoUrl https://github.com/tby-12138/YWsystem.git
```

推送后在 Settings → Pages 选择 `main` / `/ (root)`。

---

# 四、页面说明

- 纯前端单文件：HTML + CSS + JS 全部内联，无后端、无 CDN 依赖。
- 页面数据优先从 `data/ops-data.json` 读取；读取失败时使用浏览器 localStorage / 演示数据。
- 页面里的「重置演示数据」只清空本机缓存，不会删除仓库里的 `data/ops-data.json`。
- 图片以 base64 存在 JSON 里，数据大了提交会比较慢，建议控制巡检照片数量。
- xlsx 导入依赖现代浏览器的 `DecompressionStream`（Chrome / Edge / 新版 Firefox）。

## 演示解锁密码

IP 地址登记：

- MES系统：`mes@2026`
- 一卡通系统：`card@2026`
- OA办公系统：`oa@2026`

系统账号：

- MES系统：`mes@2026`
- 一卡通系统：`card@2026`
- 基础设施：`infra@2026`

---

# 五、文件

- `index.html` — 页面本体
- `data/ops-data.json` — 初始演示数据，页面启动自动读取
- `.nojekyll` — 可选，关闭 Jekyll 处理
- `publish.ps1` — Git 推送辅助脚本
- `README.md` — 本说明

# 六、本地预览

```bash
python -m http.server 8000
```

打开 `http://127.0.0.1:8000/`。
