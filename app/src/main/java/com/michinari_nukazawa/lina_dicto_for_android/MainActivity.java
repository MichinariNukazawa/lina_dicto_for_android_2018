package com.michinari_nukazawa.lina_dicto_for_android;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "LinadMainAct";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        if (savedInstanceState == null) {
            Log.d(TAG, "onCreate init");

            setContentView(R.layout.activity_main);
            WebView webView = (WebView) findViewById(R.id.webView1);

            webView.setBackgroundColor(Color.TRANSPARENT);
            webView.loadUrl("file:///android_asset/lina_dicto/index.html");


            WebSettings webSettings = webView.getSettings();
            webSettings.setJavaScriptEnabled(true);
            webView.getSettings().setAllowFileAccessFromFileURLs(true);

            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                webView.setWebContentsDebuggingEnabled(true);
            }

        }else{
            Log.d(TAG, "onCreate restore");

            WebView webView = (WebView) findViewById(R.id.webView1);
            webView.restoreState(savedInstanceState);
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState )
    {
        Log.d(TAG, "onSaveInstanceState");

        super.onSaveInstanceState(outState);
        WebView webView = (WebView)findViewById(R.id.webView1);
        webView.saveState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState)
    {
        Log.d(TAG, "onRestoreInstanceState");

        super.onRestoreInstanceState(savedInstanceState);
        WebView webView = (WebView)findViewById(R.id.webView1);
        webView.restoreState(savedInstanceState);
    }
}
