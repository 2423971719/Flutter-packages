#import "DvotePlugin.h"
#import <dvote/dvote-Swift.h>

@implementation DvotePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDvotePlugin registerWithRegistrar:registrar];
}
@end
