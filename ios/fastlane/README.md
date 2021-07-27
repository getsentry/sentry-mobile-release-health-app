fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios bump_build_number
```
fastlane ios bump_build_number
```
Bump the build number in pubspec.yaml
### ios build_ios
```
fastlane ios build_ios
```
Build iOS
### ios build_ipa
```
fastlane ios build_ipa
```
Upload ipa for TestFlight
### ios upload_ipa
```
fastlane ios upload_ipa
```
Upload ipa to TestFlight
### ios build_ios_and_upload
```
fastlane ios build_ios_and_upload
```
Build for iOS and upload ipa to TestFlight/
### ios upload_dsym
```
fastlane ios upload_dsym
```
Upload current dsym to sentry.io
### ios upload_debug_info
```
fastlane ios upload_debug_info
```
Upload debug info to sentry.io

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
