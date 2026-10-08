#!/bin/bash
# Local Sequoia build; no upload, notarization, or release-version mutation.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
build_dir="${TYPETIDE_BUILD_DIR:-$root/build-sequoia}"
signing=(CODE_SIGN_STYLE=Manual "DEVELOPMENT_TEAM=${DEVELOPMENT_TEAM:-}" "CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY:--}")
xcodebuild -project "$root/TypeTide.xcodeproj" -scheme TypeTide \
  -configuration Release -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath "$build_dir" -disableAutomaticPackageResolution \
  "${signing[@]}" build
printf 'Built app: %s\n' "$build_dir/Build/Products/Release/TypeTide.app"
