#import "FlutterStripePlugin.h"
#import <flutter_stripe_plugin/flutter_stripe_plugin-Swift.h>

@implementation FlutterStripePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterStripePlugin registerWithRegistrar:registrar];
}
@end
