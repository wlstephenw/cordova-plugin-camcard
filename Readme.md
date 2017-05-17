
# Installation

cordova plugin add https://github.com/wlstephenw/cordova-plugin-camcard.git --variable OPEN_ID=[your open id] --variable APP_ID=[your app id] --save

# Usage

1. Install 名片全能王
2. 使用示例：

        var success = function(resp) {
            alert(resp.vcf + resp.image);
        }
        var failure = function(errorMsg) {
            alert(errorMsg);
        }
        CamCard.scan(success, failure);
