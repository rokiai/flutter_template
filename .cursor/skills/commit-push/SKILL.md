---
name: commit-push
description: >-
  Create a git commit and push to both GitHub (origin) and Gitee (gitee) for
  flutter_template. Use when the user asks to commit, push, 提交, 推送, or sync
  remotes for this repo.
---

# Commit & Push (GitHub + Gitee)

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@github.com-rokiai:rokiai/flutter_template.git` |
| `gitee` | `git@gitee.com:rokiai/flutter_template.git` |

`origin` 必须用 SSH Host 别名 `github.com-rokiai`（见 `~/.ssh/config` 的 `id_ed25519`），不要用裸 `github.com`（会落到其他账号密钥导致 403）。

`main` tracks `origin/main`. Always push both remotes after a commit.

## When to run

Only when the user explicitly asks to commit and/or push. Do not commit unprompted.

## Workflow

1. **Inspect** (parallel):
   - `git status`
   - `git diff` and `git diff --staged`
   - `git log -5 --oneline` (match message style)
2. **Stage** relevant files only. Never stage `.env`, credentials, or secrets.
3. **Commit** as **rokiai** (never use global `wanggangfeng` / company email). Prefer env override so author is correct even if global config differs:

```bash
export GIT_AUTHOR_NAME=rokiai
export GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai
export GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
git commit -m "$(cat <<'EOF'
feat(scope): short summary

EOF
)"
```

Repo local config should be `user.name=rokiai` / `user.email=vnues.wgf@gmail.com`. Do not change global git config.

4. **Push both**:

```bash
git push origin HEAD:main
git push gitee HEAD:main
```

If branch is not `main`, push the current branch name to both remotes instead.

5. **Verify**: `git status -sb` and confirm both pushes succeeded.

## Rules

- Never `git config`, force-push, `--no-verify`, or amend unless user explicitly asks and amend conditions are met.
- Never push if there is nothing to commit/push; say so.
- If one remote fails, report which failed and keep the other success visible.
- After push, leave upstream as `origin/<branch>` (`git branch -u origin/main` if needed).
