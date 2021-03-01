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

# Build iOS and Upload to TestFlight

Provide environment variables needed for fastlane. For example by updating your `~/.bash_profile`

```
export FASTLANE_USER="user@sentry.io"
export FASTLANE_ITC_TEAM_ID="12345678" # The identifier of the iTunes Connect (AppStore Connect) team
export FASTLANE_PROVISIONING_PROFILE_NAME="Profile For Appstore" # The name of the provisioning profile
export SENTRY_AUTH_TOKEN="Sentry AuthToken" # Used iOS dsym upload
```

Change working directory to 'ios' and run 'fastlane build_ios_and_upload_ipa'.

The build number from the current TestFlight build will be read and incremented by one.

```
cd ios
fastlane build_ios_and_upload_ipa
```

After the build finished processing, you can fetch the latest dsyms and upload them to Sentry.

```
fastlane upload_dsym
```

# Build Android and Upload to Google Play Internal

Add keystore files `upload-keystore.jks`, `upload-keystore.properties` and JSON key file `upload-key.json` to android folder.

Change working directory to 'android' and run 'fastlane build_android_and_upload_aab'.

The current build number from `pubspec.yaml` will be used. So if you ran the iOS upload before, they match each other.

```
cd android
fastlane build_android_and_upload_aab
```

This will also read the current build number from TestFlight and increment it in `pubspec.yaml`