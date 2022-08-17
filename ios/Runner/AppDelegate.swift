import UIKit
import Flutter

// Swift のドキュメント
// 公式 → https://docs.swift.org/swift-book/
// 日本語まとめ → https://qiita.com/shtnkgm/items/eba9076aa3c243a16241

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            // Flutter 側で定義したものと同じ MethodChannel
            let batteryChannel = FlutterMethodChannel(name: "com.example.app/battery",
                                                      binaryMessenger: controller.binaryMessenger)
            batteryChannel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                // getBatteryLevel 以外が呼ばれた場合はエラーを返す
                // - guard は swift の制御文のひとつ
                // - https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID525
                guard call.method == "getBatteryLevel" else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                // バッテリー残量取得メソッドを実行
                // - self は「自分自身（クラスのインスタンス）」を表す
                // - https://docs.swift.org/swift-book/LanguageGuide/Methods.html#ID241
                self?.receiveBatteryLevel(result: result)
            })
            
            GeneratedPluginRegistrant.register(with: self)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    
    // バッテリー残量を取得するメソッド
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "バッテリー残量が取得できません",
                                details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
}


