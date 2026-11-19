param(
  [Parameter(Mandatory = $true)]
  [string]$RepoUrl
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Test-Path .git)) {
  git init | Out-Null
}

git add .

$changes = git status --porcelain
if ($changes) {
  git commit -m "Deploy 运维管理系统 demo" | Out-Null
}

git branch -M main

$remotes = git remote
if ($remotes -contains 'origin') {
  git remote remove origin
}
git remote add origin $RepoUrl
git push -u origin main

Write-Host ""
Write-Host "推送完成。接下来到 GitHub 仓库 Settings -> Pages：" -ForegroundColor Green
Write-Host "  Source: Deploy from a branch" -ForegroundColor Green
Write-Host "  Branch: main  /  (root)" -ForegroundColor Green
Write-Host "保存后等 1-2 分钟即可通过 Pages 链接访问。" -ForegroundColor Green
