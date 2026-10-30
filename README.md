# Intl on Hermes

Small React Native Android app using all twelve FormatJS Rust-backed Intl APIs.
One screen shows results. Tests read the rendered text and compare a screenshot.
Packaging lives in [FormatJS](https://github.com/formatjs/formatjs/tree/main/native/hermes/package).

## Run

Requires Node 22+, Java 17, Android SDK 36, NDK 27.1.12297006, and an arm64
Android device or x86_64 emulator. Set `ANDROID_HOME` and `ANDROID_NDK_HOME`.

Download and extract `formatjs-hermes-intl-android.tar.gz` from an
[SDK release](https://github.com/formatjs/formatjs/releases?q=formatjs-hermes-intl).
Verify its checksums using the [SDK guide](https://github.com/formatjs/formatjs/tree/main/native/hermes/package).
Until the first SDK release, use the source build below.

```sh
export FORMATJS_HERMES_SDK=/absolute/path/to/extracted-sdk
npm ci
npm start
```

In another terminal, with the same `FORMATJS_HERMES_SDK`:

```sh
npm run android
```

CMake compiles the SDK adapter against React Native's JSI headers. The synchronous
TurboModule calls `formatjs::installIntl(runtime)` before the app renders. Rust
and default locale data are prebuilt; no Rust compiler needed for this path.

## Custom locales

Build an SDK containing only English and French, then run the same app:

```sh
git clone https://github.com/formatjs/formatjs.git /tmp/formatjs
cd /tmp/formatjs
git checkout fa0ccb02a8889f4a6c93abacd204ec2ad10f9a73
bazel build -c opt --extra_toolchains=@androidndk//:all --spawn_strategy=local \
  --//crates/intl_data:locales=en,fr //native/hermes/package:android_sdk
archive=$(bazel cquery -c opt --extra_toolchains=@androidndk//:all \
  --//crates/intl_data:locales=en,fr --output=files //native/hermes/package:android_sdk)
mkdir -p /tmp/formatjs-intl-sdk
tar -xzf "$archive" -C /tmp/formatjs-intl-sdk
export FORMATJS_HERMES_SDK=/tmp/formatjs-intl-sdk
cd /path/to/hermes-intl
npm run android
```

Bazel 9 builds both Android ABIs. Omit the locale flag for the default Chromium
desktop language set, or use `--//crates/intl_data:locales=\*` for all CLDR locales.
Change the list and rebuild the SDK to add a locale. Segmenter/Collator/Locale
static data is unchanged. The screen checks English output and French DisplayNames.

## Test

```sh
npm run typecheck
cd android
./gradlew connectedDebugAndroidTest
cd ..
adb pull /sdcard/Pictures/FormatJS/intl-screen.png /tmp/intl-screen.png
npm run vrt -- /tmp/intl-screen.png
```

CI runs the same screen and screenshot checks with default data and the custom
`en,fr` build on a pinned API 35 x86_64 Pixel 7 emulator. Screenshot baseline lives
in `vrt/intl-screen.png`; differences and device logs are uploaded on failure.
