cordova.define("com.oneteam.camcard.CamCard", function(require, exports, module) {
/*global cordova, module*/

module.exports = {
    scan: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "CamCard", "scan");
    }
};

});
