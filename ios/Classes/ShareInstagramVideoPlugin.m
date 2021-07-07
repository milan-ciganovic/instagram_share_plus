#import "ShareInstagramVideoPlugin.h"
#if __has_include(<instagram_share_plus/instagram_share_plus-Swift.h>)
#import <instagram_share_plus/instagram_share_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "instagram_share_plus-Swift.h"
#endif

@implementation ShareInstagramVideoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftShareInstagramVideoPlugin registerWithRegistrar:registrar];
}
@end
