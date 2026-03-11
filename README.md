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

## 在新项目中使用

### 1. 添加 submodule

```bash
git submodule add https://github.com/njueeRay/ai-team .team
git submodule update --init --recursive
```

### 2. 初始化团队到项目（Windows / PowerShell）

```powershell
.\.team\bootstrap.ps1
```

这会将 `agents/` 和 `skills/` 同步到 `.github/`，让 GitHub Copilot 能自动识别所有 Agent 和 Skill。

### 3. 补充项目层配置

编辑 `.github/copilot-instructions.md`，在文件顶部写入项目特定信息（目标、个人信息、设计决策等），
团队通用规范在 bootstrap 时已经注入。

### 4. 获取团队更新

```bash
git submodule update --remote .team
.\.team\bootstrap.ps1   # 重新同步
```

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
  bootstrap.ps1              ← Windows 一键初始化脚本
  bootstrap.sh               ← Linux/macOS 一键初始化脚本
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
