import UIKit
import Flutter
import flutter_local_notifications
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Setup for flutter_local_notifications
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(name: "com.example.toeic_desktop/widget", binaryMessenger: controller.binaryMessenger)

    nativeChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "updateWidgetColor" {
        if let args = call.arguments as? [String: Any],
           let message = args["colorHex"] as? String {
          print("Received from Flutter: \(message)")
          result("iOS received: \(message)")
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
        }
      }
        else if call.method == "schedulePeriodicWidgetUpdate" {
            if let args = call.arguments as? [String: Any],
               let flashcardData = args["flashCardShowInWidgetList"] as? [String: Any],
               let flashcardList = flashcardData["flashCardShowInWidgetList"] as? [[String: String]] {

                let userDefaults = UserDefaults(suiteName: "group.winterzxzz")
                let encoder = JSONEncoder()
                
                let flashcards = flashcardList.compactMap { dict -> FlashCard? in
                    guard let word = dict["word"], let definition = dict["definition"] else { return nil }
                    return FlashCard(word: word, definition: definition)
                }

                print("flashcards: \(flashcards)")
                
                if let encoded = try? encoder.encode(flashcards) {
                    userDefaults?.set(encoded, forKey: "flashcards")
                    userDefaults?.synchronize()
                }

                // load widget
                WidgetCenter.shared.reloadAllTimelines()
                result("Widget data updated successfully")
                
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
            }
        }
        else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
