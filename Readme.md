
# Installation

cordova plugin add https://github.com/wlstephenw/cordova-plugin-camcard.git --variable OPEN_ID=[your open id] --save

# Usage

1. Install 名片全能王
2. 使用示例：

        var success = function(resp) {
            alert(resp.vcf + resp.image);
        }
        var failure = function(error) {
            alert(error.errorCode + ":" + error.errorMsg);
            // empty error code means that camcard was not installed, if we are on iOS, then guid user to install from app store.
            if (error.errorCode == "" && device.platform == "iOS")
                CamCard.install();
        }
        CamCard.scan(success, failure);




#错误码

when the camcard is not installed properly, the error code return is empty-"";

## Android
Error Code
Error Code Description
Static variables of Error Code
100
device_id error
ERROR_DEVICEID
101
APP ID error; the Android package name is inconsistent with the one bound to your granted API Key.
ERROR_APPID
102
API Key Error; API Key is invalid
ERROR_APPKEY
 
103
API Key is expired
ERROR_TIME_EXCEEDED
104
Devices exceed the amount configured in the granted API Key
ERROR_DEVICE_EXCEEDED
105
Scans exceed the amount configured in the granted API Key
ERROR_CARD_EXCEEDED
106
 
 
User ID error
 
ERROR_SUBAPPKEY
200
Recognize Successfully
OK
300
 
 
User cancels the operation
 
CANCELED
301
Recognize failed
 
REGNIZE_FAILED
 
501
 
CamCard APP version is too low
VERSION_UNMATCH
511
Internet error; it requires
an online authentication when
use at the first time. Please make sure the public
internet is available
NETWORK_INVALID
516
 
MD5 signature error; the MD5 signature is inconsistent
with the one bound to your granted API Key.
 
SIGNATURE_INVALID
616
Authenticate failed.
Please make sure the public internet is available
AUTHINFO_INVALID

## IOS
0
识别成功
4001
CCOpenAPIRecogCardRequest 的 image 不是合法的 名片
4002
用户取消了拍照操作
4003
识别失败
4004
用户取消了编辑联系人操作
4005
用户未登陆 CamCard 账户
4006
当前设备不支持摄像头
5001
使用时间超过限制;API Key 已到期
5003
未授权应用处理图片次数超过上限
5004
名片识别张数超限;API Key 授权使用的名片识别 张数超过限制
5005
设备数量超限;API Key 授权使用的设备数超过限 制
5006
其他授权错误
