import Flutter
import UIKit
//import Photos

import PhotosUI


public class SwiftShareInstagramVideoPlugin:  UIViewController, FlutterPlugin,PHPickerViewControllerDelegate   {
    
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "instagram_share_plus", binaryMessenger: registrar.messenger())
        
        let instance = SwiftShareInstagramVideoPlugin()
        
        
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //        let url = call.arguments as! String
        guard call.method == "shareVideoToInstagram"
        else {
            result(FlutterMethodNotImplemented)
            return
            
        }
        DispatchQueue.main.async {
            
            return self.shareVideoToInstagram(result: result)
        }
    }
    
    @IBAction private func shareVideoToInstagram(result: FlutterResult) {
        if #available(iOS 14, *) {
            self.presentPicker(self)
        } else {
            return result(String("error"))
        }
        return result(String("success"))
    }
    
    
    
    @available(iOS 14, *)
    @IBAction func presentPicker(_ sender: Any) {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true)
    }
    
    @available(iOS 14, *)
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        
        let localId = fetchResult.firstObject!.localIdentifier
        
        let url = URL(string: "instagram://library?LocalIdentifier=\(localId)")
        guard UIApplication.shared.canOpenURL(url!) else {
            return
        }
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
}
