import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        if let controller = window?.rootViewController as? FlutterViewController {
            let batteryChannel = FlutterMethodChannel(
                name: "sentry-mobile.sentry.io/nativeCrash",
                binaryMessenger: controller.binaryMessenger
            )
            batteryChannel.setMethodCallHandler {
                [weak self] call, result in
                if call.method == "crashSwift" {
                    self?.crashSwift()
                } else if call.method == "crashObjectiveC" {
                    NativeCrashObjectiveC.crashingFunction()
                }
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func crashSwift() {
        let string: String? = nil
        print(string!.size) // Force-unwrapping a nil optional crashes the app.
    }
}
