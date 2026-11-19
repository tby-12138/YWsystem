# 运维管理系统 · 在线演示

单文件静态页面（`index.html`），无后端、无外部 CDN 依赖。页面可部署到 **GitHub Pages**，数据可以同步到你自己的 **GitHub 私有数据仓库**。

## 发布后的链接

`https://<你的GitHub用户名>.github.io/<仓库名>/`

例如仓库名是 `ops-console`，用户名是 `yourname`：

`https://yourname.github.io/ops-console/`

---

# 一、推荐结构

- **页面仓库**：公开仓库（如 `ops-console`），只放 `index.html`，用 GitHub Pages 免费托管。
- **数据仓库**：私有仓库（如 `ops-console-data`），只放一个 `data/ops-data.json`。
- **Token**：只保存在你浏览器的 localStorage，不写进页面、不写进 Git。

这样页面是公开的，但你的数据只在私有仓库里；别人打开页面只看到演示数据，除非他们也有你的 Token。

---

# 二、部署页面

## 方式一：网页上传（最快）

1. GitHub 右上角 **+ → New repository**。
2. 仓库名填 `ops-console`；可见性选 **Public**；不要勾选 Add a README file；点 **Create repository**。
3. 在空仓库页点 **Add file → Upload files**，上传 `index.html`。
   - `.nojekyll` 可选；如果系统隐藏文件看不到，可以不上传，不影响访问。
4. 点 **Commit changes**。
5. **Settings → Pages**：
   - **Source**：**Deploy from a branch**
   - **Branch**：**main**，目录：**/ (root)**
   - **Save**
6. 等 1–2 分钟，链接即 `https://<用户名>.github.io/ops-console/`。

> 免费账号的 Pages 需要 public 页面仓库；私有仓库的 Pages 通常需要 GitHub Pro / Team。数据仓库私有不影响页面仓库公开。

## 方式二：Git 推送

先在 GitHub 新建一个空的 public 页面仓库，然后在解压后的目录执行：

```bash
git init
git add .
git commit -m "Deploy ops console"
git branch -M main
git remote add origin https://github.com/<你的用户名>/ops-console.git
git push -u origin main
```

Windows 也可以：

```powershell
.\publish.ps1 -RepoUrl https://github.com/<你的用户名>/ops-console.git
```

推送后同样到 **Settings → Pages** 选择 `main` / `/ (root)`。

---

# 三、配置 Git 数据同步（私有数据仓库）

## 1. 新建私有数据仓库

GitHub → **New repository**：

- 仓库名：`ops-console-data`
- 可见性：**Private**
- 勾选 **Add a README file**（初始化 `main` 分支）
- Create repository

## 2. 创建 fine-grained Token

GitHub 右上角头像 → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**：

- Token name：`ops-console-sync`
- Expiration：按需（例如 90 天）
- **Repository access**：Only select repositories → `ops-console-data`
- **Permissions**：
  - **Contents**：**Read and write**
  - Metadata：Read-only（自动勾选）
- Generate token，复制 `github_pat_...`（只显示一次）

## 3. 在页面里配置

打开部署好的页面，点顶栏 **「云同步」**：

| 字段 | 填写 |
| --- | --- |
| GitHub 用户名 / 组织 | 你的用户名 |
| 私有数据仓库 | `ops-console-data` |
| 分支 | `main` |
| 数据文件路径 | `data/ops-data.json` |
| Fine-grained Token | 粘贴 `github_pat_...` |

依次点：

1. **测试连接** → 应提示「连接成功（私有仓库）」
2. **保存设置** → 配置保存在本机浏览器
3. **保存到 GitHub** → 第一次会创建 `data/ops-data.json` 并提交

## 4. 换设备 / 新浏览器

打开同一页面 → 云同步 → 填同样的 owner / repo / branch / path / token → **从 GitHub 加载**。

之后每次改完数据，点 **保存到 GitHub** 即可；每次保存都是一次 Git 提交，可在数据仓库的 Commits/History 里回滚。

---

# 四、重要说明

- **Token 安全**：Token 保存在浏览器 localStorage，不会写入页面或 Git。不要在公共电脑使用；用完可点「清除本机配置」。
- **不要填真实凭据**：页面源码、演示数据都是公开可见的；如果保存真实数据，务必使用私有数据仓库，并给 Token 最小权限。
- **手动同步**：当前是手动「保存/加载」，不会自动提交；避免频繁请求和冲突。
- **冲突处理**：如果云端文件已被其他窗口更新，保存会提示冲突，先「从 GitHub 加载」再保存。
- **数据大小**：图片以 base64 存在 JSON 里，数据超过约 5MB 时页面会提示；图片多时建议减少巡检照片，或改用 Python 后端 + SQLite。
- **localStorage**：页面始终保留本机缓存；云同步是额外的一层，不配置也能离线使用。
- **页面公开、数据私有**：页面仓库里的 `index.html` 不含 token；数据仓库是 private。

---

# 五、演示密码

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

- `index.html` — 页面本体（必须叫这个名字）
- `.nojekyll` — 可选，关闭 GitHub Pages 的 Jekyll 处理
- `publish.ps1` — Git 推送辅助脚本
- `README.md` — 本说明

# 七、本地预览

```bash
python -m http.server 8000
```

打开 `http://127.0.0.1:8000/`。
