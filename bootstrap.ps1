# bootstrap.ps1 — ai-team 初始化脚本 (Windows PowerShell)
# 将团队 agents/、skills/、docs/ 同步到项目
# 用法：在项目根目录执行  .\.team\bootstrap.ps1

param(
    [string]$TeamDir   = ".team",
    [string]$TargetDir = ".github",
    [string]$DocsDir   = "docs"
)

$ErrorActionPreference = "Stop"

Write-Host "🤖 ai-team bootstrap 开始..." -ForegroundColor Cyan
Write-Host "   来源: $TeamDir"
Write-Host "   目标: $TargetDir"

# 确保目标目录存在
New-Item -ItemType Directory -Path "$TargetDir\agents" -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir\skills" -Force | Out-Null
New-Item -ItemType Directory -Path "$DocsDir\governance" -Force | Out-Null
New-Item -ItemType Directory -Path "$DocsDir\guides" -Force | Out-Null

# 同步 agents（.agent.md 文件）
Write-Host ""
Write-Host "📋 同步 Agent 定义..." -ForegroundColor Yellow
$agentFiles = Get-ChildItem "$TeamDir\agents\*.agent.md" -ErrorAction SilentlyContinue
foreach ($file in $agentFiles) {
    Copy-Item $file.FullName "$TargetDir\agents\" -Force
    Write-Host "   ✓ $($file.Name)"
}

# 同步 knowledge 目录
if (Test-Path "$TeamDir\agents\knowledge") {
    Copy-Item "$TeamDir\agents\knowledge" "$TargetDir\agents\" -Recurse -Force
    Write-Host "   ✓ knowledge/ (知识库)"
}

# 同步 skills
Write-Host ""
Write-Host "🔧 同步 Skill 库..." -ForegroundColor Yellow
$skillDirs = Get-ChildItem "$TeamDir\skills" -Directory -ErrorAction SilentlyContinue
foreach ($dir in $skillDirs) {
    Copy-Item $dir.FullName "$TargetDir\skills\" -Recurse -Force
    Write-Host "   ✓ $($dir.Name)/"
}

# 同步 docs/（团队级文档，不覆盖项目私有文件）
Write-Host ""
Write-Host "📚 同步团队文档 (docs/)..." -ForegroundColor Yellow
$teamDocFiles = @(
    @{ Src = "$TeamDir\docs\governance\team-playbook.md";    Dst = "$DocsDir\governance\team-playbook.md" },
    @{ Src = "$TeamDir\docs\governance\agent-workflow.md";   Dst = "$DocsDir\governance\agent-workflow.md" },
    @{ Src = "$TeamDir\docs\governance\tooling-scaffold.md"; Dst = "$DocsDir\governance\tooling-scaffold.md" }
)
foreach ($entry in $teamDocFiles) {
    if (Test-Path $entry.Src) {
        Copy-Item $entry.Src $entry.Dst -Force
        Write-Host "   ✓ $($entry.Dst)"
    }
}
# guides/ 整个目录
if (Test-Path "$TeamDir\docs\guides") {
    Copy-Item "$TeamDir\docs\guides\*" "$DocsDir\guides\" -Force -ErrorAction SilentlyContinue
    Write-Host "   ✓ docs/guides/"
}

Write-Host ""
Write-Host "✅ bootstrap 完成！" -ForegroundColor Green
Write-Host ""
Write-Host "下一步："
Write-Host "  1. 确认 .github/copilot-instructions.md 包含项目特定信息"
Write-Host "  2. 项目私有文件（sprint-board.md / design-decisions.md）在 docs/governance/ 中单独创建"
