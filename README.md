# 运维管理系统 · 在线演示

单文件静态页面（`index.html`），无后端、无外部 CDN 依赖。数据既可以像博客一样放在页面仓库的 `data/ops-data.json`，也可以自动同步到私有 GitHub 数据仓库。

## 页面链接

`https://tby-12138.github.io/YWsystem/`

---

# 一、页面当前为什么是 0？

页面能打开、`index.html` 和 `data/ops-data.json` 都已上传，但页面显示 0，通常是：

- 浏览器里还留着旧的**云同步配置**，页面优先走云仓库，云仓库里没有数据；
- 或者 localStorage 里存了空数组，页面没有重新读 `data/ops-data.json`。

新版页面已经处理：

1. 有云同步配置 → 启动自动从私有仓库加载；
2. 云仓库为空/找不到 → **自动回退读取 `data/ops-data.json`**；
3. 没有云配置 → 直接读 `data/ops-data.json`。

如果升级后还是 0，点：

- 顶栏「云同步」→「清除本机配置」→ 刷新；或
- 基础配置 → 重置演示数据。

页面应恢复 57 条巡检、18 条运维记录等演示数据。

---

# 二、方式 A：博客式（数据文件在页面仓库）

数据文件：`data/ops-data.json`

## 目录结构

```text
YWsystem/
├── index.html
├── data/
│   └── ops-data.json
├── README.md
└── .nojekyll
```

## 更新数据

1. 页面里正常编辑；
2. 云同步 →「下载数据 JSON」；
3. 到 GitHub 的 `data/ops-data.json` 上传覆盖；
4. Commit → 等 Pages 发布 → 刷新页面。

这种方式不需要 Token，但 `data/ops-data.json` 在公开仓库里，**数据是公开的**。

---

# 三、方式 B：自动提交到 Git（推荐，像正常系统）

页面可以通过 GitHub API 自动读写一个 **private 数据仓库**：打开页面自动加载，改完约 1.5 秒自动提交，不需要手动上传 JSON。

## 1. 新建私有数据仓库

- 仓库名：`YWsystem-data`
- 可见性：**Private**
- 勾选 Add a README file（初始化 main 分支）

## 2. 建 Fine-grained Token

GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens：

- Repository access：Only select repositories → `YWsystem-data`
- Permissions：**Contents → Read and write**（Metadata 自动只读）
- 生成后复制 `github_pat_...`

## 3. 页面配置

打开页面 → 顶栏「云同步」：

| 字段 | 填写 |
| --- | --- |
| GitHub 用户名 | `tby-12138` |
| 私有数据仓库 | `YWsystem-data` |
| 分支 | `main` |
| 数据文件路径 | `data/ops-data.json` |
| Token | 粘贴 `github_pat_...` |
| 改完自动保存到 GitHub | 勾选 |

依次点：

1. **测试连接**
2. **保存设置**
3. **保存到 GitHub**（第一次创建数据文件）

之后：

- 打开页面 → 自动从私有仓库加载；
- 修改任何数据 → 约 1.5 秒后自动提交到 Git；
- 换设备 → 填同样配置 → 自动加载；
- 每次提交都能在数据仓库的 Commits 里看到、回滚。

## 自动模式的边界

- Token 存在浏览器 localStorage，**不会写进页面或 Git**；公共电脑用完点「清除本机配置」。
- 每次修改一个 Git 提交，图片多时 JSON 会变大，超过约 5MB 页面会提示。
- 两个人同时编辑同一份数据仍可能冲突；这是给个人使用设计的。
- 要真正多用户/实时数据库，请用 Python 后端 + SQLite，Git 只放代码和备份。

---

# 四、部署页面

## 网页上传

1. 公开仓库（如 `YWsystem`），上传 `index.html`、`data/ops-data.json`、`README.md`。
2. Settings → Pages：
   - Source：Deploy from a branch
   - Branch：main
   - Folder：/ (root)
   - Save
3. 等 1–2 分钟访问 `https://tby-12138.github.io/YWsystem/`。

## Git 推送

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

---

# 五、说明

- 纯前端单文件：HTML + CSS + JS 全部内联，无后端、无 CDN 依赖。
- localStorage 是本地缓存；Git 数据仓库/`data/ops-data.json` 是持久化来源。
- 图片以 base64 存在 JSON 里，数据大了提交会慢，建议控制巡检照片数量。
- xlsx 导入依赖现代浏览器的 `DecompressionStream`（Chrome / Edge / 新版 Firefox）。
- 「重置演示数据」只清空本机缓存，不会删除 Git 里的数据文件。

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

# 六、文件

- `index.html` — 页面本体
- `data/ops-data.json` — 初始演示数据，页面启动自动读取
- `.nojekyll` — 可选，关闭 Jekyll 处理
- `publish.ps1` — Git 推送辅助脚本
- `README.md` — 本说明

# 七、本地预览

```bash
python -m http.server 8000
```

打开 `http://127.0.0.1:8000/`。
