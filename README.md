<p align="center">
  <a href="https://sentry.io/?utm_source=github&utm_medium=logo" target="_blank">
    <picture>
      <source srcset="https://sentry-brand.storage.googleapis.com/sentry-logo-white.png" media="(prefers-color-scheme: dark)" />
      <source srcset="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)" />
      <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" alt="Sentry" width="280">
    </picture>
  </a>
</p>

# Release Health [![build](https://github.com/getsentry/sentry-mobile/workflows/build/badge.svg?branch=main)](https://github.com/getsentry/sentry-mobile/actions?query=branch%3Amain)

> Please be aware that this project is currently not actively maintained. PRs will not be merged.

A flutter application with the focus on [Release Health](https://docs.sentry.io/product/releases/health/setup/).

| Android | iOS |
|:-:|:-:|
| [<img src=".github/google-play-logo.png" height="50">](https://play.google.com/store/apps/details?id=io.sentry.mobile.app) | [<img src=".github/appstore-logo.png" height="50">](https://apps.apple.com/app/sentry-io/id1546709967) |

# Run source generators

`flutter pub run build_runner build`

# Getting started

1. Install Flutter

https://flutter.dev/docs/get-started/install

2. Run to see what you should do:

```
flutter doctor
```

3. Install dependencies

```
flutter pub get
```

4. Use your editor of choice (recommendation Android Studio with Flutter plugin)

https://flutter.dev/docs/get-started/editor

5. Generate Transient Files

Files used for JSON decoding are generated using [`build_runner`](https://dart.dev/tools/build_runner). When run with [`watch`](https://pub.dev/packages/build_runner#built-in-commands) option, rebuilds are done automatically when files change.

```
flutter pub run build_runner build
```

6. Run the App

You can start it from Android Studio in an Simulator, even iOS Simulator.

or run

```
flutter run 
```

# Build iOS and Upload to TestFlight

- Provide environment variables needed for fastlane. For example by updating your `~/.bash_profile` or `~/.zshrc`, depending on which shell you are using.
- Make sure you have your distribution certificate and the provisioning profile installed on your machine.
- Create an app specific password for your apple developer account: https://appleid.apple.com/account/manage

```
export FASTLANE_USER="user@sentry.io" # Your apple developer account
export FASTLANE_ITC_TEAM_ID="12345678" # The identifier of the iTunes Connect (AppStore Connect) team
export FASTLANE_PROVISIONING_PROFILE_NAME="Profile For Appstore" # The name of the provisioning profile
export SENTRY_AUTH_TOKEN="Sentry AuthToken" # Used for iOS dsym and debug info upload
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="app-specific-pass-word" # Created from your apple developer account
```

Restart terminal after entering.

- You need to install the fastlane plugin https://github.com/getsentry/sentry-fastlane-plugin.

- Change working directory to 'ios' and run 'fastlane build_ios_and_upload'.
	- The build number from the current TestFlight build will be read and incremented by one.
	- After successfully IPA upload, the lane will also upload local DSYM files and other debug info to Sentry.

```
cd ios
fastlane build_ios_and_upload
```

# Build Android and Upload to Google Play Internal

Add keystore files `upload-keystore.jks`, `upload-keystore.properties` and JSON key file `upload-key.json` to the android folder. These files are excluded from version control.

Change working directory to 'android' and run 'fastlane build_android_and_upload_aab'.

The current build number from `pubspec.yaml` will be used. So if you ran the iOS upload before, they will match each other.

```
cd android
fastlane build_android_and_upload_aab
```

This will also read the current build number from TestFlight and increment it in `pubspec.yaml`
