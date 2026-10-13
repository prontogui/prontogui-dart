#!/bin/sh
# Copyright 2024-2026 ProntoGUI, LLC
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Publish HEAD to the public repo as ONE snapshot commit (see
# app_core/specs/REPO-LAYOUT.md). Development history and its timestamps stay
# in the private -dev repo; the public repo only ever gets snapshots, dated at
# 00:00 UTC of the publish day - never a time of day.
#
#   tools/publish.sh [-t TAG] "message"
#
#   -t TAG   also push TAG (e.g. v2.0.0) on the snapshot, as a lightweight tag
#            (lightweight tags carry no date of their own)
#
# Requires a remote named "public" (the public repo). Paths in EXCLUDE are left
# out of the snapshot - .github, so CI and Dependabot run only in the -dev repo.
set -eu

EXCLUDE=".github"

tag=""
while getopts t: opt; do
  case $opt in
    t) tag=$OPTARG ;;
    *) echo "usage: tools/publish.sh [-t TAG] \"message\"" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))
msg=${1:?usage: tools/publish.sh [-t TAG] "message"}

git remote get-url public >/dev/null 2>&1 || {
  echo "no remote named 'public' - add it: git remote add public <public repo URL>" >&2
  exit 1
}
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "uncommitted changes - commit (to the -dev repo) first" >&2
  exit 1
fi

# The snapshot's files: HEAD minus EXCLUDE, built in a throwaway index.
index=$(mktemp)
trap 'rm -f "$index"' EXIT
GIT_INDEX_FILE=$index git read-tree HEAD
for path in $EXCLUDE; do
  GIT_INDEX_FILE=$index git rm -r -q --cached --ignore-unmatch -- "$path"
done
tree=$(GIT_INDEX_FILE=$index git write-tree)

git fetch -q public
day="$(date -u +%Y-%m-%d)T00:00:00Z"
if git rev-parse -q --verify refs/remotes/public/main >/dev/null; then
  if [ "$(git rev-parse 'refs/remotes/public/main^{tree}')" = "$tree" ]; then
    echo "public/main already matches HEAD - nothing to publish"
    commit=$(git rev-parse refs/remotes/public/main)
  else
    commit=$(GIT_AUTHOR_DATE="$day" GIT_COMMITTER_DATE="$day" \
      git commit-tree "$tree" -p refs/remotes/public/main -m "$msg")
    git push public "$commit:refs/heads/main"
    echo "published $commit ($day)"
  fi
else
  # First snapshot: no parent.
  commit=$(GIT_AUTHOR_DATE="$day" GIT_COMMITTER_DATE="$day" \
    git commit-tree "$tree" -m "$msg")
  git push public "$commit:refs/heads/main"
  echo "published first snapshot $commit ($day)"
fi

if [ -n "$tag" ]; then
  git push public "$commit:refs/tags/$tag"
  echo "tagged $tag"
fi
