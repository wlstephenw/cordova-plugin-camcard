
module.exports = {
    scan: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "CamCard", "scan");
    },

    install: function (successCallback, errorCallback) {
         cordova.exec(successCallback, errorCallback, "CamCard", "install");
    }
};

