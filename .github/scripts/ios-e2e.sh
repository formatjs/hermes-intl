#!/usr/bin/env bash
set -euo pipefail

artifacts="${RUNNER_TEMP:-$PWD/ios/build}"
mkdir -p "$artifacts"
results=$(mktemp -d "$artifacts/ios-e2e.XXXXXX")
if [ -z "${IOS_SIMULATOR_ID:-}" ]; then
  IOS_SIMULATOR_ID=$(xcrun simctl list devices available -j | python3 -c 'import json,sys; devices=json.load(sys.stdin)["devices"]; print(next(d["udid"] for runtime,items in devices.items() if ".iOS-" in runtime for d in items if d["name"].startswith("iPhone")))')
fi
xcrun simctl boot "$IOS_SIMULATOR_ID" || xcrun simctl bootstatus "$IOS_SIMULATOR_ID" -b
xcrun simctl bootstatus "$IOS_SIMULATOR_ID" -b
xcodebuild test \
  -workspace ios/FormatjsHermes.xcworkspace \
  -scheme FormatjsHermes \
  -configuration Release \
  -destination "platform=iOS Simulator,id=$IOS_SIMULATOR_ID" \
  -derivedDataPath ios/build \
  -resultBundlePath "$results/ios-tests.xcresult" \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | tee "$results/xcodebuild.log"
