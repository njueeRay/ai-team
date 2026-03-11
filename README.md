# ai-team

> **njueeRay 的可移植 AI Agent 团队** — 一次构建，随处部署。

这个仓库是 Ray 的 AI 协作团队的统一状态源。包含所有 Agent 角色定义、技能库、团队规范和知识记忆。
任何新项目只需通过 submodule 引入，即可获得完整的团队能力。

---

## 团队成员

| Agent | 文件 | 核心职责 |
|-------|------|---------|
| `brain` | `agents/brain.agent.md` | 战略协调中枢，用户唯一汇报窗口 |
| `pm` | `agents/pm.agent.md` | Sprint 规划、DoD 执行、版本管理 |
| `dev` | `agents/dev.agent.md` | 全栈实现（代码/文档/配置/CI） |
| `researcher` | `agents/researcher.agent.md` | 技术调研，输出浓缩结论 |
| `code-reviewer` | `agents/code-reviewer.agent.md` | 七维度质量门禁，输出结构化审查报告 |
| `profile-designer` | `agents/profile-designer.agent.md` | 视觉规划、组件选型（按需启用） |
| `brand` | `agents/brand.agent.md` | 品牌运营、Build in Public、内容发布策略 |

## 技能库（Skills）

| Skill | 目录 |
|-------|------|
| brain-coordinator | `skills/brain-coordinator/` |
| brand-publishing | `skills/brand-publishing/` |
| code-reviewer-quality | `skills/code-reviewer-quality/` |
| dev-fullstack | `skills/dev-fullstack/` |
| pm-sprint-planner | `skills/pm-sprint-planner/` |
| profile-designer-visual | `skills/profile-designer-visual/` |
| researcher-analysis | `skills/researcher-analysis/` |
| self-improvement | `skills/self-improvement/` |

---

## 三层工作流模型

```
OpenProfile .github/          ai-team (本仓库)        新项目 .github/
【活体实验室】                 【版本快照】             【独立演化】

  团队在真实项目中成长   →promote→  稳定后打版本  →bootstrap→  直接开工
  .github/agents/               agents/                .github/agents/
  .github/skills/               skills/                .github/skills/
```

**单向流动规则：**
- `OpenProfile → ai-team`：团队成熟一个里程碑后，手动 promote 回写
- `ai-team → 新项目`：新项目拉取 submodule + 运行 bootstrap 即可
- 新项目**不向** ai-team 回流（各自独立演化）

---

## 在新项目中使用（bootstrap 方向）

### 1. 添加 submodule

```bash
git submodule add https://github.com/njueeRay/ai-team .team
git submodule update --init
```

### 2. 同步团队到 .github/（Windows / PowerShell）

```powershell
.\.team\bootstrap.ps1
```

这会将 `agents/` 和 `skills/` 复制到 `.github/`，GitHub Copilot 即刻识别全部 Agent 和 Skill。

### 3. 补充项目层配置

编辑 `.github/copilot-instructions.md`，写入项目特定信息（目标、个人信息、设计决策等）。
团队通用部分已由 bootstrap 注入，无需重复。

### 4. 获取团队版本更新（可选）

```bash
git submodule update --remote .team   # 拉取 ai-team 最新版
.\.team\bootstrap.ps1                  # 重新同步到 .github/
```

---

## 从 OpenProfile 回写团队（promote 方向）

当团队在 OpenProfile 中成长成熟，需要固化到 ai-team 时：

```powershell
# 在 OpenProfile 根目录执行
.\.team\promote.ps1

# 完成后更新 submodule 指针
git add .team
git commit -m "chore: update ai-team submodule to vX.Y"
git push origin main
```

promote 脚本会自动：
1. 将 `.github/agents/` + `.github/skills/` 复制到 `.team/`
2. 在 ai-team 仓库内 commit + push
3. 提示你更新 OpenProfile 中的 submodule 指针

---

## 边界规则：什么进 ai-team，什么留在项目里

| 进 ai-team（跨项目通用） | 留在项目（项目私有） |
|---|---|
| `agents/*.agent.md` — 角色定义 | `.github/copilot-instructions.md` — 项目目标/个人信息 |
| `agents/knowledge/` — 学习记忆 | `docs/governance/sprint-board.md` — Sprint 状态 |
| `skills/*/SKILL.md` — 技能库 | `docs/governance/design-decisions.md` — 设计决策 |
| `docs/governance/team-playbook.md` — 方法论 | `.github/workflows/` — CI/CD |
| `docs/governance/agent-workflow.md` — 协作流程 | `docs/brand/`、`docs/meetings/` 等 |

---

## 仓库结构

```
ai-team/
  agents/                    ← Agent 角色定义（.agent.md）
    knowledge/               ← Agent 知识库（patterns + memory）
  skills/                    ← 技能目录（每个含 SKILL.md）
  docs/
    governance/
      team-playbook.md       ← 团队协作手册（Playbook v2.4+）
      agent-workflow.md      ← AI 协作工作流说明
      tooling-scaffold.md    ← 工具脚手架规范
    guides/
      component-guide.md     ← 组件使用指南
  bootstrap.ps1 / bootstrap.sh   ← 新项目初始化（.team → .github）
  promote.ps1 / promote.sh       ← 团队回写（.github → .team → push）
  README.md
```

---

## 设计理念

> 这支团队不是工具集合，也不是流程执行器。
> **我们是用户认知系统的外化形态。**
>
> — Team Playbook §0.1

**AI-native 健康标准：人类判断力有没有随 AI 能力的增强而同步成长？**

---

## License

MIT © njueeRay
