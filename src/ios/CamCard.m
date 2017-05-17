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
    [CCOpenAPI sendRequest:recogCardReq];
    //    [recogCardReq release];
    
}

- (void)didReceiveResponseFromCamCardOpenAPI:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[CCOpenAPIRecogCardResponse class]] == YES) {
        CCOpenAPIRecogCardResponse *response = (CCOpenAPIRecogCardResponse *)notification.object;
        NSLog(@"[CC_OPEN_API] Status code from camcard open api:%d", response.responseCode);
        
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
