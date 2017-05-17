#import "CamCard.h"
#import <CamCardOpenAPIFramework/OpenAPI.h>

#define AppKey @"YourAppKey"
#define UserID @"YourUserID"

@implementation CamCard

- (void)pluginInitialize
{
}

- (void)handleOpenURL:(NSNotification*)notification
{
    NSLog(@"call handleOpenURL");
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]]) {
        [CCOpenAPI handleOpenURL:url sourceApplication:@""];
    }
}

- (void)scan:(CDVInvokedUrlCommand*)command
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveResponseFromCamCardOpenAPI:) name:CamCardOpenAPIDidReceiveResponseNotification object:nil];
    self.callbackId = command.callbackId;
    
    CCOpenAPIRecogCardRequest *recogCardReq = [[CCOpenAPIRecogCardRequest alloc] init];
    recogCardReq.appKey = AppKey;
    recogCardReq.userID = UserID;
    BOOL ret = [CCOpenAPI sendRequest:recogCardReq];
    if (!ret)
    {
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_ERROR
                                   messageAsString:@"Error invoking the camcard application"];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
    
}

- (void)install:(CDVInvokedUrlCommand*)command
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[CCOpenAPI CCAppInstallUrl]]];
}

- (void)didReceiveResponseFromCamCardOpenAPI:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[CCOpenAPIRecogCardResponse class]] == YES) {
        CCOpenAPIRecogCardResponse *response = (CCOpenAPIRecogCardResponse *)notification.object;
        NSLog(@"[CC_OPEN_API] Status code from camcard open api:%d", (long)response.responseCode);
        
        NSDictionary* ret = @{
                              @"vcf": response.vcfString,
                              @"image": @""
                              };
        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsDictionary:ret];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
        
        
    }
}



@end
