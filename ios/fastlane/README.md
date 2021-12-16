fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios bump_build_number

```sh
[bundle exec] fastlane ios bump_build_number
```

Bump the build number in pubspec.yaml

### ios build_ios

```sh
[bundle exec] fastlane ios build_ios
```

Build iOS

### ios build_ipa

```sh
[bundle exec] fastlane ios build_ipa
```

Upload ipa for TestFlight

### ios upload_ipa

```sh
[bundle exec] fastlane ios upload_ipa
```

Upload ipa to TestFlight

### ios build_ios_and_upload

```sh
[bundle exec] fastlane ios build_ios_and_upload
```

Build for iOS and upload ipa to TestFlight/

### ios upload_dsym

```sh
[bundle exec] fastlane ios upload_dsym
```

Upload current dsym to sentry.io

### ios upload_debug_info

```sh
[bundle exec] fastlane ios upload_debug_info
```

Upload debug info to sentry.io

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
