#!/usr/bin/env bash
# promote.sh — 将项目 .github/ 中已成熟的团队成果回写到 ai-team
# 方向：项目 .github/agents/ + .github/skills/  →  .team/（ai-team submodule）→ 推送
#
# 在项目根目录执行：  ./.team/promote.sh
# 完成后更新 submodule 指针：
#   git add .team && git commit -m "chore: update ai-team submodule"

set -e

SOURCE_DIR="${1:-.github}"
TEAM_DIR="${2:-.team}"
COMMIT_MSG="${3:-}"

echo "🚀 ai-team promote 开始..."
echo "   来源: $SOURCE_DIR  →  目标: $TEAM_DIR"

if [ ! -d "$TEAM_DIR/.git" ]; then
    echo "❌ .team 不是 git 仓库，请先执行 git submodule update --init" >&2
    exit 1
fi

# 同步 agents
echo ""
echo "📋 同步 Agent 定义..."
for f in "$SOURCE_DIR"/agents/*.agent.md; do
    [ -f "$f" ] && cp "$f" "$TEAM_DIR/agents/" && echo "   ✓ $(basename $f)"
done

# 同步 knowledge
if [ -d "$SOURCE_DIR/agents/knowledge" ]; then
    cp -r "$SOURCE_DIR/agents/knowledge/." "$TEAM_DIR/agents/knowledge/"
    echo "   ✓ knowledge/ (知识库)"
fi

# 同步 skills
echo ""
echo "🔧 同步 Skill 库..."
for d in "$SOURCE_DIR"/skills/*/; do
    name=$(basename "$d")
    mkdir -p "$TEAM_DIR/skills/$name"
    cp -r "$d." "$TEAM_DIR/skills/$name/"
    echo "   ✓ $name/"
done

# commit + push
echo ""
echo "📦 提交到 ai-team 仓库..."
cd "$TEAM_DIR"

if git diff --quiet && git diff --staged --quiet; then
    echo "   没有变更，跳过提交。"
else
    git add agents/ skills/
    [ -z "$COMMIT_MSG" ] && COMMIT_MSG="feat: promote team updates from OpenProfile ($(date +%Y-%m-%d))"
    git commit -m "$COMMIT_MSG

Co-authored-by: GitHub Copilot <copilot@github.com>"
    echo "   ✓ commit 完成"
    git push origin main
    echo "   ✓ push 完成 → https://github.com/njueeRay/ai-team"
fi

cd - > /dev/null
echo ""
echo "✅ promote 完成！"
echo ""
echo "最后一步（在项目根目录）："
echo '  git add .team && git commit -m "chore: update ai-team submodule"'
echo "  git push origin main"
