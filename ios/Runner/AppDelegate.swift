import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "com.tasogarei.test/camera", binaryMessenger: controller.binaryMessenger)

    let reader = KXABarcodeReader.sharedInstance()
    reader?.reset()
    reader?.rotation = 1
    reader?.types = 255
    print("version string: \(String(describing: reader?.version))")
    print("version number: \(String(describing: reader?.versionNumber))")

    methodChannel.setMethodCallHandler(
{

            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if call.method == "camera" {
// https://news.mynavi.jp/itsearch/article/devsoft/1218
// https://github.com/OpenFlutter/fluwx/issues/110
//if ([StringUtil isBlank:imagePath]) {
//        NSData *imageData = [FlutterStandardTypedData typedDataWithBytes:call.arguments[fluwxKeyImageData]].data;
//        [self shareMemoryImage:call result:result imageData:imageData];
//    }
        //planeAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
        //NSData *bytes = [NSData dataWithBytes:planeAddress length:length.unsignedIntegerValue];
        //planeBuffer[@"bytes"] = [FlutterStandardTypedData typedDataWithBytes:bytes];
              //https://gist.github.com/kazz12211/3c8b7aa4c05260298130ba89dde2b22a
                //https://dev.classmethod.jp/smartphone/ios-11-code-ml/

                // Flutter camera image to swift UIimage
                // https://stackoverflow.com/questions/57828792/flutter-camera-image-to-swift-uiimage
                //UIImageをCVPixelBufferに変換
                //https://developers.cyberagent.co.jp/blog/archives/8803/
                // UIImageをCVImageBufferRefに変換します
                // http://ja.voidcc.com/question/p-srmplxkn-be.html

                let arguments = call.arguments as? [String: Any]
                let buf = arguments?["bytes"] as! FlutterStandardTypedData
                let height = arguments?["height"] as? Int
                let width = arguments?["width"] as? Int
                let bytesPerRow = arguments?["bytesPerRow"] as? Int
                let height0 = arguments?["height0"] as? Int
                let width0 = arguments?["width0"] as? Int
                print("arguments. bytesPerRow: \(bytesPerRow), height0: \(height0), width0, \(width0)")
                print("arguments. height: \(height), width, \(width)")

                let rgbaUint8 = [UInt8](buf.data)
                let data = NSData(bytes: rgbaUint8, length: rgbaUint8.count)
                let uiimage = UIImage(data: data as Data)
//                uiimage.
//                var byte = [UInt8](buf.data)
//                var byteaaa = buf.data as NSData
//                var bbbb: UnsafeRawPointer = byteaaa.bytes
//                print("buf: ", buf)
//                print("buf.data: ", buf.data)
//                print("byteaaa: ",byteaaa)
//                print("bbbb: ",bbbb)

                // ビットマップコンテキスト作成
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let bitsPerCompornent = 8
                let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
//                let newContext = CGContext(data: bbbb, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerCompornent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)! as CGContext
//
//                // 画像作成
//                let imageRef = newContext.makeImage()!
//                let image = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.up)
                
//                ssss.testMethod2(buf)
                print("height:\(String(describing: height)), width:\(String(describing: width))")

//                Data() *imageData = buf.data;
//                let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(buf)!
//                let barcode = reader?.decode(buf as! CVImageBuffer)
                let barcode = "123"
                result(barcode)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    )


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    
  }
}
