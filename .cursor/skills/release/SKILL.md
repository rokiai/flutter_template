---
name: release
description: >-
  Cut a Flutter template release: bump pubspec version, tag, and push to GitHub
  and Gitee. Use when the user asks to release, 发版, bump version, tag a
  version, or publish a release for flutter_template.
---

# Release (GitHub + Gitee)

## Author identity（硬性，最高优先级）

本仓库每一次 commit / annotated tag 的 **author 与 committer 必须是**：

| 字段 | 唯一正确值 |
|------|------------|
| name | `rokiai` |
| email | `vnues.wgf@gmail.com` |

**禁止** `wanggangfeng`、`linwu-hi`、`vnues`、`@xunlei.com` 或任何其他身份。

每次 commit / `git tag -a` 前必须：

```bash
export GIT_AUTHOR_NAME=rokiai
export GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai
export GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
```

提交后校验：

```bash
git log -1 --format='%an <%ae>%n%cn <%ce>'
```

必须均为 `rokiai <vnues.wgf@gmail.com>`。错误则 `git reset --soft HEAD~1` 重做；**未通过不得 push / 不得打 tag 推送**。

Tag 后可用：`git for-each-ref refs/tags/vX.Y.Z --format='%(taggername) %(taggeremail)'` 确认 tagger 也是 rokiai。

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@github.com-rokiai:rokiai/flutter_template.git` |
| `gitee` | `git@gitee.com:rokiai/flutter_template.git` |

`origin` 使用 `github.com-rokiai` SSH 别名（`id_ed25519`）。

## Version scheme

`pubspec.yaml`：`version: X.Y.Z+B`

| Bump | When | Example |
|------|------|---------|
| patch | fixes / small deps | `0.1.0+1` → `0.1.1+2` |
| minor | features | `0.1.1+2` → `0.2.0+3` |
| major | breaking | `0.2.0+3` → `1.0.0+4` |

每次发版递增 `+B`。默认 **patch**。Tag：`vX.Y.Z`。

## Workflow

```
Release:
- [ ] Clean tree / sync origin/main
- [ ] Decide bump
- [ ] Update pubspec.yaml version
- [ ] Smoke: flutter analyze / test（可按用户跳过）
- [ ] Export rokiai 四变量 → commit → 校验作者
- [ ] Export 后 annotated tag → 校验 tagger
- [ ] Push commit + tag → origin & gitee
- [ ] Optional GitHub Release
```

### 1. Preconditions

```bash
git status -sb
git fetch origin && git fetch gitee
git pull --ff-only
```

### 2. Bump

只改 `pubspec.yaml` 的 `version:`。

### 3. Smoke（推荐）

```bash
flutter pub get && flutter analyze --no-fatal-infos && flutter test
```

### 4. Commit

```bash
git add pubspec.yaml
export GIT_AUTHOR_NAME=rokiai GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
git commit -m "$(cat <<'EOF'
chore(release): vX.Y.Z

EOF
)"
git log -1 --format='%an <%ae>%n%cn <%ce>'   # 必须是 rokiai
```

### 5. Tag

```bash
export GIT_AUTHOR_NAME=rokiai GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
git tag -a "vX.Y.Z" -m "vX.Y.Z"
```

### 6. Push

```bash
git push origin HEAD:main && git push origin "vX.Y.Z"
git push gitee HEAD:main && git push gitee "vX.Y.Z"
```

### 7. GitHub Release（可选）

```bash
gh release create "vX.Y.Z" --title "vX.Y.Z" --notes "$(cat <<'EOF'
## Changes
- …
EOF
)"
```

Gitee 无 CLI 时提示：https://gitee.com/rokiai/flutter_template/releases

## Rules

- Only when user explicitly asks to release.
- 作者/tagger 错误时禁止 push；用户明确要求时可 reset + force push 修正。
- Never rewrite published tags without explicit request.
- Never commit `.env` / secrets.
- Keep `main` tracking `origin/main`.
