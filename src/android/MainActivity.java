package com.oneteam.plugin;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.intsig.openapilib.OpenApi;
import com.intsig.openapilib.OpenApiParams;

public class MainActivity extends Activity {

//	OpenApi openApi = OpenApi.instance("com.example.openapiinvoker","WKA6EP5hKHaD91QF7eF5KdF9","test1");//对外demo
//	OpenApi openApi = OpenApi.instance("WKA6EP5hKHaD91QF7eF5KdF9","test1");
	//BL257HPAN59XUVJXgUDQ9rHV inner test Key, J6LNMUtMM8CPQ9PgHfRUf3d7 personal test Key
	//OpenApi openApi = OpenApi.instance("J6LNMUtMM8CPQ9PgHfRUf3d7");

	// package name: com.oneteam.deltacrm
	// user: michael.chen@cnoneteam.com
	// pass: m123890
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

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		testRecognizeCapture();
	}

	
	public void testRecognizeCapture() {
		if(openApi.isCamCardInstalled(this)){
			if ( openApi.isExistAppSupportOpenApi(this) ){
				openApi.recognizeCardByCapture(this, REQUEST_CODE_RECOGNIZE, params);
			}else{
				Toast.makeText(this, "No app support openapi", Toast.LENGTH_LONG).show();
				System.out.println("camcard download link:"+openApi.getDownloadLink());
			}
		}else{
			Toast.makeText(this, "No CamCard", Toast.LENGTH_LONG).show();
			System.out.println("camcard download link:"+openApi.getDownloadLink());
		}
	}

	public void testRecognizeImage(String path) {
		if ( openApi.isExistAppSupportOpenApi(this) ){
			openApi.recognizeCardByImage(this, path, REQUEST_CODE_RECOGNIZE, params);
		}	else {
			Toast.makeText(this, "No app support openapi", Toast.LENGTH_LONG).show();
			System.out.println("camcard download link:"+openApi.getDownloadLink());
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == RESULT_OK) {
			if (requestCode == REQUEST_CODE_RECOGNIZE) {
				showResult(data.getStringExtra(OpenApi.EXTRA_KEY_VCF),
						data.getStringExtra(OpenApi.EXTRA_KEY_IMAGE));
			}
		} else {
			int errorCode=data.getIntExtra(openApi.ERROR_CODE, 200);
			String errorMessage=data.getStringExtra(openApi.ERROR_MESSAGE);
			System.out.println("ddebug error " + errorCode+","+errorMessage);
			Toast.makeText(this, "Recognize canceled/failed. + ErrorCode " + errorCode + " ErrorMsg " + errorMessage,
					Toast.LENGTH_LONG).show();
		}
		super.onActivityResult(requestCode, resultCode, data);
	}

	private void showResult(String vcf, String path) {
		Intent intent = new Intent(this, ShowResultActivity.class);
		intent.putExtra("result_vcf", vcf);
		intent.putExtra("result_trimed_image", path);
		startActivity(intent);
	}
}
