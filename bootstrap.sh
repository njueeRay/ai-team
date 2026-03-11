#!/usr/bin/env bash
# bootstrap.sh — ai-team 初始化脚本 (Linux/macOS)
# 将团队 agents/、skills/、docs/ 同步到项目
# 用法：在项目根目录执行  ./.team/bootstrap.sh

set -e

TEAM_DIR="${1:-.team}"
TARGET_DIR="${2:-.github}"
DOCS_DIR="${3:-docs}"

echo "🤖 ai-team bootstrap 开始..."
echo "   来源: $TEAM_DIR"
echo "   目标: $TARGET_DIR"

mkdir -p "$TARGET_DIR/agents"
mkdir -p "$TARGET_DIR/skills"
mkdir -p "$DOCS_DIR/governance"
mkdir -p "$DOCS_DIR/guides"

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

# 同步 docs/（团队级文档）
echo ""
echo "📚 同步团队文档 (docs/)..."
for f in team-playbook.md agent-workflow.md tooling-scaffold.md; do
    src="$TEAM_DIR/docs/governance/$f"
    [ -f "$src" ] && cp "$src" "$DOCS_DIR/governance/$f" && echo "   ✓ docs/governance/$f"
done
if [ -d "$TEAM_DIR/docs/guides" ]; then
    cp -r "$TEAM_DIR/docs/guides/." "$DOCS_DIR/guides/"
    echo "   ✓ docs/guides/"
fi

echo ""
echo "✅ bootstrap 完成！"
echo ""
echo "下一步："
echo "  1. 确认 .github/copilot-instructions.md 包含项目特定信息"
echo "  2. 项目私有文件（sprint-board.md）在 docs/governance/ 中单独创建"
