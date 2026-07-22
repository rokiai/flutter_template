---
name: commit-push
description: >-
  Create a git commit and push to both GitHub (origin) and Gitee (gitee) for
  flutter_template. Use when the user asks to commit, push, 提交, 推送, or sync
  remotes for this repo.
---

# Commit & Push (GitHub + Gitee)

## Author identity（硬性，最高优先级）

本仓库每一次 commit / tag 的 **author 与 committer 必须是**：

| 字段 | 唯一正确值 |
|------|------------|
| name | `rokiai` |
| email | `vnues.wgf@gmail.com` |

**禁止**出现（含全局 config 误用）：

- `wanggangfeng`、`linwu-hi`、`vnues`、公司邮箱（如 `@xunlei.com`）或任何其他 name/email

### 每次提交前必须做

1. 用环境变量覆盖（不要依赖全局 `git config`）：

```bash
export GIT_AUTHOR_NAME=rokiai
export GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai
export GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
```

2. 可选加固本仓库 local（勿改 global）：

```bash
git config --local user.name "rokiai"
git config --local user.email "vnues.wgf@gmail.com"
```

3. **提交后立刻校验**；不对就禁止 push：

```bash
git log -1 --format='%an <%ae>%n%cn <%ce>'
```

必须两行都是 `rokiai <vnues.wgf@gmail.com>`。若错误：

```bash
git reset --soft HEAD~1
# 重新 export 四个变量后再 commit
```

未通过校验 **不得** `git push`。

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@github.com-rokiai:rokiai/flutter_template.git` |
| `gitee` | `git@gitee.com:rokiai/flutter_template.git` |

`origin` 必须用 SSH Host 别名 `github.com-rokiai`（`~/.ssh/config` → `id_ed25519`），不要用裸 `github.com`（会落到其他账号密钥）。

`main` tracks `origin/main`. Always push both remotes after a commit.

## When to run

Only when the user explicitly asks to commit and/or push. Do not commit unprompted.

## Workflow

1. **Inspect** (parallel): `git status` / `git diff` / `git diff --staged` / `git log -5 --oneline`
2. **Stage** relevant files only. Never stage `.env` or secrets.
3. **Export rokiai 四变量**（见上文），再 commit：

```bash
git commit -m "$(cat <<'EOF'
feat(scope): short summary

EOF
)"
```

4. **校验作者**（见上文）。失败则 soft reset 重做，禁止 push。
5. **Push both**：

```bash
git push origin HEAD:main
git push gitee HEAD:main
```

非 `main` 则推当前分支名到两端。

6. **Verify**: `git status -sb`

## Rules

- 作者身份错误时：先修作者，再 push；需要时按用户明确要求 reset + force push。
- Never force-push / `--no-verify` / amend unless user explicitly asks and amend conditions are met.
- Never push if there is nothing to commit/push.
- If one remote fails, report which failed.
- Keep upstream as `origin/<branch>`.
