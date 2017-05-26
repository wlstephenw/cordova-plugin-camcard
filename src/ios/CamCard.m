#import "CamCard.h"
#import <CamCardOpenAPIFramework/OpenAPI.h>

#define AppKey @"BVUX8H5BXy8SK0Xy0843CDA9"
#define UserID @"YourUserID"

@implementation CamCard

- (void)pluginInitialize
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveResponseFromCamCardOpenAPI:) name:CamCardOpenAPIDidReceiveResponseNotification object:nil];
}



- (void)scan:(CDVInvokedUrlCommand*)command
{
    

    self.callbackId = command.callbackId;
    
    CCOpenAPIRecogCardRequest *recogCardReq = [[CCOpenAPIRecogCardRequest alloc] init];
    recogCardReq.appKey = AppKey;
    recogCardReq.userID = UserID;
    NSString *errMsg = nil;
    if([CCOpenAPI isCCAppInstalled])
    {
        if ([CCOpenAPI isCCAppSupportAPI])
        {
            if(![CCOpenAPI sendRequest:recogCardReq])
            {
                errMsg = @"error invoke the camcard application";
            }
        }
        else
        {
            errMsg = @"No app support openapi";
        }
    }
    else
    {
        errMsg = @"No CamCard";
    }
    if (errMsg)
    {
        NSDictionary* ret = @{
                              @"errorCode": @"",
                              @"errorMsg": errMsg
                              };
        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_ERROR
                                   messageAsDictionary:ret];
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
        NSLog(@"[CC_OPEN_API] Status code from camcard open api:%ld", (long)response.responseCode);
        
        NSDictionary* ret = nil;
        CDVCommandStatus status = nil;
        
        if (response.responseCode == 0)
        {
            ret = @{
                    @"vcf": response.vcfString,
                    @"image": @""
                    };
            status = CDVCommandStatus_OK;
        }
        else
        {
            ret = @{
                    @"errorCode": [NSString stringWithFormat:@"%ld", (long)response.responseCode],
                    @"errorMsg": @""
                    };
            status = CDVCommandStatus_ERROR;
        }

        
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:status
                                   messageAsDictionary:ret];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
        
        
    }
}

- (void)handleOpenURL:(NSNotification*)notification
{
    NSLog(@"call handleOpenURL");
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]]) {
        [CCOpenAPI handleOpenURL:url sourceApplication:@""];
    }
}



@end
