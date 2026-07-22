---
name: release
description: >-
  Cut a Flutter template release: bump pubspec version, tag, and push to GitHub
  and Gitee. Use when the user asks to release, 发版, bump version, tag a
  version, or publish a release for flutter_template.
---

# Release (GitHub + Gitee)

## Remotes

| Remote | URL |
|--------|-----|
| `origin` | `git@github.com-rokiai:rokiai/flutter_template.git` |
| `gitee` | `git@gitee.com:rokiai/flutter_template.git` |

`origin` 使用 SSH Host 别名 `github.com-rokiai`（`~/.ssh/config` → `id_ed25519`），避免默认 `github.com` 密钥落到错误账号。

## Version scheme

`pubspec.yaml` uses `version: X.Y.Z+B` (semver + build number).

| Bump | When | Example |
|------|------|---------|
| patch | fixes / small deps | `0.1.0+1` → `0.1.1+2` |
| minor | features | `0.1.1+2` → `0.2.0+3` |
| major | breaking | `0.2.0+3` → `1.0.0+4` |

Always increment **build number `+B`** on every release. Default bump is **patch** unless user specifies otherwise.

Tag format: `vX.Y.Z` (no build number in tag).

## Workflow

Copy and track:

```
Release:
- [ ] Clean working tree (or commit first via commit-push skill)
- [ ] Decide bump (patch/minor/major)
- [ ] Update pubspec.yaml version
- [ ] Optional smoke: flutter analyze / flutter test
- [ ] Commit release
- [ ] Create annotated tag
- [ ] Push commit + tag to origin and gitee
- [ ] Create GitHub Release (optional Gitee release note)
```

### 1. Preconditions

```bash
git status -sb
git fetch origin
git fetch gitee
```

Working tree must be clean except intentional release edits. Sync with `origin/main` first (`git pull --ff-only`).

### 2. Bump version

Edit `pubspec.yaml` `version:` only. Do not change `publish_to`.

### 3. Smoke (recommended)

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
```

Skip only if user says so.

### 4. Commit

Author must be **rokiai \<vnues.wgf@gmail.com\>** (same as CI / open-source history):

```bash
git add pubspec.yaml
export GIT_AUTHOR_NAME=rokiai
export GIT_AUTHOR_EMAIL=vnues.wgf@gmail.com
export GIT_COMMITTER_NAME=rokiai
export GIT_COMMITTER_EMAIL=vnues.wgf@gmail.com
git commit -m "$(cat <<'EOF'
chore(release): vX.Y.Z

EOF
)"
```

Include other intentional release files if present (e.g. CHANGELOG).

### 5. Tag

```bash
git tag -a "vX.Y.Z" -m "vX.Y.Z"
```

### 6. Push both remotes

```bash
git push origin HEAD:main
git push origin "vX.Y.Z"
git push gitee HEAD:main
git push gitee "vX.Y.Z"
```

### 7. GitHub Release

If `gh` is available:

```bash
gh release create "vX.Y.Z" --title "vX.Y.Z" --notes "$(cat <<'EOF'
## Changes
- …
EOF
)"
```

Notes: summarize commits since previous tag (`git log vPREV..HEAD --oneline`).

Gitee: if CLI unavailable, tell user the tag URL:
`https://gitee.com/rokiai/flutter_template/releases` to attach notes manually.

## Rules

- Only release when the user explicitly asks.
- Never force-push tags or rewrite published tags without explicit request.
- Never commit `.env` or secrets.
- If push to one remote fails, report clearly; do not delete the local tag.
- Keep `main` tracking `origin/main`.
