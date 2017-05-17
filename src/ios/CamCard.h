#import <Cordova/CDV.h>

@interface CamCard : CDVPlugin

@property (copy) NSString* callbackId;

- (void) scan:(CDVInvokedUrlCommand*)command;
- (void)install:(CDVInvokedUrlCommand*)command;

@end
