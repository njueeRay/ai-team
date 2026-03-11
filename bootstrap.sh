#!/usr/bin/env bash
# bootstrap.sh — ai-team 初始化脚本 (Linux/macOS)
# 将团队 agents/ 和 skills/ 同步到项目的 .github/ 目录
# 用法：在项目根目录执行  ./.team/bootstrap.sh

set -e

TEAM_DIR="${1:-.team}"
TARGET_DIR="${2:-.github}"

echo "🤖 ai-team bootstrap 开始..."
echo "   来源: $TEAM_DIR"
echo "   目标: $TARGET_DIR"

mkdir -p "$TARGET_DIR/agents"
mkdir -p "$TARGET_DIR/skills"

# 同步 agents
echo ""
echo "📋 同步 Agent 定义..."
for f in "$TEAM_DIR"/agents/*.agent.md; do
    [ -f "$f" ] && cp "$f" "$TARGET_DIR/agents/" && echo "   ✓ $(basename $f)"
done

# 同步 knowledge
if [ -d "$TEAM_DIR/agents/knowledge" ]; then
    cp -r "$TEAM_DIR/agents/knowledge" "$TARGET_DIR/agents/"
    echo "   ✓ knowledge/ (知识库)"
fi

# 同步 skills
echo ""
echo "🔧 同步 Skill 库..."
for d in "$TEAM_DIR"/skills/*/; do
    [ -d "$d" ] && cp -r "$d" "$TARGET_DIR/skills/" && echo "   ✓ $(basename $d)/"
done

echo ""
echo "✅ bootstrap 完成！"
echo ""
echo "下一步："
echo "  1. 确认 .github/copilot-instructions.md 包含项目特定信息"
echo "  2. git add .github/ && git commit -m 'chore: bootstrap ai-team'"
