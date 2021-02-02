<p align="center">
  <a href="https://sentry.io" target="_blank" align="center">
    <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" width="280">
  </a>
  <br />
</p>

# Sentry Mobile

[![build](https://github.com/getsentry/sentry-mobile/workflows/build/badge.svg?branch=main)](https://github.com/getsentry/sentry-mobile/actions?query=branch%3Amain)

This is a hackweek project and not a Sentry product.  
There are no plans of publishing this app to the App Store/Google Play Store.

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

5. Run the App

You can start it from Android Studio in an Simulator, even iOS Simulator.

or run

```
flutter run 
```

6. Build iOS and upload to testflight

Provide environment variables needed for fastlane. For example by updating your `~/.bash_profile`

```
export FASTLANE_USER="user@sentry.io"
export FASTLANE_ITC_TEAM_ID="12345678" # The identifier of the iTunes Connect (AppStore Connect) team
export FASTLANE_PROVISIONING_PROFILE_NAME="Profile For Appstore" # The name of the provisioning profile
```

Change working directory to 'ios' and run 'fastlane build_ios_and_upload_ipa'

```
cd ios
fastlane build_ios_and_upload_ipa
```

This will also read the current build number from TestFlight and increment it in `pubspec.yaml`