# promote.ps1 — 将项目中已成熟的团队成果回写到 ai-team
# 方向：.github/agents/ + .github/skills/ + docs/（团队级）→  .team/（ai-team submodule）→ 推送
#
# 在 OpenProfile（或任何使用了 .team submodule 的项目）根目录执行：
#   .\.team\promote.ps1
#
# 完成后需要回到项目根目录更新 submodule 指针：
#   git add .team && git commit -m "chore: update ai-team submodule to vX.Y"

param(
    [string]$SourceDir = ".github",
    [string]$DocsDir   = "docs",
    [string]$TeamDir   = ".team",
    [string]$CommitMsg = ""
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 ai-team promote 开始..." -ForegroundColor Cyan
Write-Host "   来源: $SourceDir  →  目标: $TeamDir"

# 确认 .team 是 git 仓库
if (-not (Test-Path "$TeamDir\.git")) {
    Write-Error ".team 不是 git 仓库，请先执行 git submodule update --init"
    exit 1
}

# 同步 agents（仅 .agent.md 文件）
Write-Host ""
Write-Host "📋 同步 Agent 定义..." -ForegroundColor Yellow
$agentFiles = Get-ChildItem "$SourceDir\agents\*.agent.md" -ErrorAction SilentlyContinue
foreach ($file in $agentFiles) {
    Copy-Item $file.FullName "$TeamDir\agents\" -Force
    Write-Host "   ✓ $($file.Name)"
}

# 同步 knowledge 目录
if (Test-Path "$SourceDir\agents\knowledge") {
    Copy-Item "$SourceDir\agents\knowledge\*" "$TeamDir\agents\knowledge\" -Recurse -Force
    Write-Host "   ✓ knowledge/ (知识库)"
}

# 同步 skills
Write-Host ""
Write-Host "🔧 同步 Skill 库..." -ForegroundColor Yellow
$skillDirs = Get-ChildItem "$SourceDir\skills" -Directory -ErrorAction SilentlyContinue
foreach ($dir in $skillDirs) {
    $target = Join-Path "$TeamDir\skills" $dir.Name
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    Copy-Item "$($dir.FullName)\*" $target -Recurse -Force
    Write-Host "   ✓ $($dir.Name)/"
}

# 同步 docs/（只回写团队级文档，不碰项目私有文件）
Write-Host ""
Write-Host "📚 同步团队文档 (docs/)..." -ForegroundColor Yellow
$teamDocFiles = @(
    @{ Src = "$DocsDir\governance\team-playbook.md";    Dst = "$TeamDir\docs\governance\team-playbook.md" },
    @{ Src = "$DocsDir\governance\agent-workflow.md";   Dst = "$TeamDir\docs\governance\agent-workflow.md" },
    @{ Src = "$DocsDir\governance\tooling-scaffold.md"; Dst = "$TeamDir\docs\governance\tooling-scaffold.md" }
)
foreach ($entry in $teamDocFiles) {
    if (Test-Path $entry.Src) {
        # 确保目标目录存在
        $dstDir = Split-Path $entry.Dst -Parent
        New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
        Copy-Item $entry.Src $entry.Dst -Force
        Write-Host "   ✓ $(Split-Path $entry.Src -Leaf)"
    }
}
# guides/ 整个目录
if (Test-Path "$DocsDir\guides") {
    New-Item -ItemType Directory -Path "$TeamDir\docs\guides" -Force | Out-Null
    Copy-Item "$DocsDir\guides\*" "$TeamDir\docs\guides\" -Force -ErrorAction SilentlyContinue
    Write-Host "   ✓ docs/guides/"
}

# 在 .team 目录内 commit 并 push
Write-Host ""
Write-Host "📦 提交到 ai-team 仓库..." -ForegroundColor Yellow
Push-Location $TeamDir

$hasChanges = (git status --porcelain) -ne $null
if (-not $hasChanges) {
    Write-Host "   没有变更，跳过提交。" -ForegroundColor Gray
    Pop-Location
} else {
    git add agents/ skills/ docs/

    if ($CommitMsg -eq "") {
        $date = Get-Date -Format "yyyy-MM-dd"
        $CommitMsg = "feat: promote team updates from OpenProfile ($date)"
    }

    git commit -m "$CommitMsg`n`nCo-authored-by: GitHub Copilot <copilot@github.com>"
    Write-Host "   ✓ commit 完成"

    git push origin main
    Write-Host "   ✓ push 完成 → https://github.com/njueeRay/ai-team"
    Pop-Location
}

Write-Host ""
Write-Host "✅ promote 完成！" -ForegroundColor Green
Write-Host ""
Write-Host "最后一步（在项目根目录）："
Write-Host '  git add .team && git commit -m "chore: update ai-team submodule"'
Write-Host "  git push origin main"
