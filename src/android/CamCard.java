package com.oneteam.plugin;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.intsig.openapilib.OpenApi;
import com.intsig.openapilib.OpenApiParams;

public class CamCard extends CordovaPlugin {

    private String tag = "camcard";
    OpenApi openApi = OpenApi.instance("t4b9UKr52K7A7YHa3N4L6ydd");
    OpenApiParams params = new OpenApiParams() {
        {
            this.setRecognizeLanguage("");
            this.setReturnCropImage(true);
            this.setTrimeEnhanceOption(true);
            this.setSaveCard(false);
        }
    };
    private static final int REQUEST_CODE_RECOGNIZE = 0x1001;
    Activity activity =  null;
    private CallbackContext callbackContext;

    @Override
    public void pluginInitialize() {
        activity = this.cordova.getActivity();

    }

    /**
     *
     * @param action          The action to execute.
     * @param data
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return
     * @throws JSONException
     */
    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;

        if (action.equals("scan")) {
            this.scan();
            return true;
        }
            
        return false;

    }


    /**
     *
     */
    public void scan(){
        this.cordova.setActivityResultCallback(this);
        this.cordova.getThreadPool().execute(new Runnable(){

            public void run(){
                CamCard.this.testRecognizeCapture();
            }

        });


    }

    public void testRecognizeCapture() {
        String errorMsg = null;
        if(openApi.isCamCardInstalled(activity)){
            if ( openApi.isExistAppSupportOpenApi(activity) ){
                openApi.recognizeCardByCapture(activity, REQUEST_CODE_RECOGNIZE, params);
            }else{
                errorMsg = "No app support openapi";
                Log.e(tag, "camcard download link:"+openApi.getDownloadLink());
            }
        }else{
            errorMsg = "No CamCard";
            Log.e(tag, "camcard download link:"+openApi.getDownloadLink());
        }
        if (null != errorMsg){
            this.callbackContext.error(errorMsg);
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_RECOGNIZE) {
                String extra_key_vcf = data.getStringExtra(OpenApi.EXTRA_KEY_VCF);
                String extra_key_image = data.getStringExtra(OpenApi.EXTRA_KEY_IMAGE);
                JSONObject obj = new JSONObject();
                try {
                    obj.put("vcf", extra_key_vcf);
                    obj.put("image", extra_key_image);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                this.callbackContext.success(obj);
            }
        } else if (null != data){
            int errorCode=data.getIntExtra(openApi.ERROR_CODE, 200);
            String errorMessage=data.getStringExtra(openApi.ERROR_MESSAGE);
            Log.e(tag, "ddebug error " + errorCode+","+errorMessage);
            errorMessage = "Recognize canceled/failed. + ErrorCode " + errorCode + " ErrorMsg " + errorMessage;
            this.callbackContext.error(errorMessage);
        }
    }


    /**
     * This plugin launches an external Activity when the camera is opened, so we
     * need to implement the save/restore API in case the Activity gets killed
     * by the OS while it's in the background.
     */
    public void onRestoreStateForActivityResult(Bundle state, CallbackContext callbackContext) {
        this.callbackContext = callbackContext;
    }


}
