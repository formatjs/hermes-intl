# Hermes Intl React Native example

Android arm64/x86_64 app. Installs all twelve Rust-backed Intl polyfills into React
Native's Hermes runtime through a synchronous C++ TurboModule in `OnLoad.cpp`. Screen shows
one result per API. Android instrumentation test reads the rendered text and
captures a screenshot.

The Android SDK build is in [FormatJS PR #7726](https://github.com/formatjs/formatjs/pull/7726).
CI pins its source commit until that PR lands.

Requires Node 22+, Java 17, Android SDK 36, NDK 27.1.12297006, an Android
arm64 device or x86_64 emulator, and Bazel 9. Set `ANDROID_HOME` and
`ANDROID_NDK_HOME` to installed SDK and NDK directories.

Build SDK from [FormatJS](https://github.com/formatjs/formatjs), then run this app:

```sh
git clone https://github.com/formatjs/formatjs.git /tmp/formatjs-hermes-source
cd /tmp/formatjs-hermes-source
git checkout 89459cc997dbb1f84df5bf6707e66a9c130adf80
bazel build --extra_toolchains=@androidndk//:all --spawn_strategy=local //native/hermes/package:android_sdk
mkdir -p /tmp/formatjs-hermes-android-sdk
tar -xzf bazel-bin/native/hermes/package/formatjs_intl_hermes_android-0.1.0.tar.gz -C /tmp/formatjs-hermes-android-sdk
export FORMATJS_HERMES_SDK=/tmp/formatjs-hermes-android-sdk
cd /path/to/hermes-intl
npm ci
npm start
```

In another terminal with same `FORMATJS_HERMES_SDK`:

```sh
npm run android
cd android
./gradlew connectedDebugAndroidTest
```

`IntlScreenTest` checks Hermes, native installation, and every Intl API on
rendered screen. It saves app-content `intl-screen.png` through Android
MediaStore so Gradle can uninstall the test APK before capture retrieval.
Pull and compare it against reviewed baseline:

```sh
adb pull /sdcard/Pictures/FormatJS/intl-screen.png /tmp/intl-screen.png
npm run vrt -- /tmp/intl-screen.png
```

CI builds SDK from FormatJS and runs same test on pinned API 35 x86_64 Pixel 7 emulator, uploads actual and
diff images, then compares pixels with `vrt/intl-screen.png`. Existing editor
VRT handles browser screenshots; this baseline belongs to Android emulator.

The Android SDK archive uses the same C++ adapter sources as desktop SDK,
but provides Android arm64 and x86_64 Rust archives. CMake compiles adapter against
React Native's JSI headers. No desktop Hermes library enters APK.
