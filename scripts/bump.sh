#!/usr/bin/env bash
# Bump the secrets-helper formula to a given (or latest) release.
#
# Usage:
#   scripts/bump.sh            # bump to the latest GitHub release
#   scripts/bump.sh 0.2.2      # bump to a specific version
#
# It rewrites the url/version/sha256 lines in Formula/secrets-helper.rb by
# downloading the release tarball and computing its SHA-256. It does NOT commit;
# the GitHub Action (or you) handles the commit. Works on macOS and Linux.
set -euo pipefail

readonly REPO="frontmatters/secrets-helper"
readonly FORMULA="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/Formula/secrets-helper.rb"

version="${1:-}"
if [[ -z "$version" ]]; then
  # Pick the highest semver TAG, not releases/latest: this repo tags every
  # version (e.g. v0.2.1) but does not always publish a matching Release, so a
  # release-based lookup can silently downgrade the formula.
  echo "==> No version given; querying highest tag of $REPO"
  version="$(curl -fsSL "https://api.github.com/repos/$REPO/tags?per_page=100" \
    | grep '"name"' | sed -E 's/.*"name": *"v?([^"]+)".*/\1/' \
    | sort -V | tail -1)"
fi
version="${version#v}" # strip a leading v if present
[[ -n "$version" ]] || { echo "ERROR: could not determine version" >&2; exit 1; }

readonly url="https://github.com/$REPO/archive/refs/tags/v${version}.tar.gz"
echo "==> Version: $version"
echo "==> URL:     $url"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
if ! curl -fsSL "$url" -o "$tmp"; then
  echo "ERROR: tarball not found at $url (does the v$version tag exist?)" >&2
  exit 1
fi
sha="$(shasum -a 256 "$tmp" | awk '{print $1}')"
echo "==> sha256:  $sha"

# Rewrite the three release-pinned lines, anchored to start-of-line so nothing
# else in the formula (e.g. #{version} in the test block) is touched.
perl -0pi -e "s{^  url \"[^\"]+\"}{  url \"$url\"}m"       "$FORMULA"
perl -0pi -e "s{^  version \"[^\"]+\"}{  version \"$version\"}m" "$FORMULA"
perl -0pi -e "s{^  sha256 \"[^\"]+\"}{  sha256 \"$sha\"}m" "$FORMULA"

echo "==> Updated $FORMULA"
grep -E '^  (url|version|sha256) ' "$FORMULA"
