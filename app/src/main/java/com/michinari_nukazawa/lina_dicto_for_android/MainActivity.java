package com.michinari_nukazawa.lina_dicto_for_android;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import androidx.webkit.WebViewAssetLoader;

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
            WebSettings webSettings = webView.getSettings();
            webSettings.setJavaScriptEnabled(true);

            // duplicate API 30:
            // webView.getSettings().setAllowFileAccessFromFileURLs(true);
            // webView.loadUrl("file:///android_asset/lina_dicto/index.html");
            //
            // loadable local files cross-origin
            // https://developer.android.com/reference/androidx/webkit/WebViewAssetLoader
            final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
                    .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
                    .build();
            webView.setWebViewClient(new WebViewClient() {
                @Override
                public WebResourceResponse shouldInterceptRequest(WebView view,
                                                                  WebResourceRequest request) {
                    return assetLoader.shouldInterceptRequest(request.getUrl());
                }
            });

            webView.loadUrl("https://appassets.androidplatform.net/assets/lina_dicto/index.html");

            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                webView.setWebContentsDebuggingEnabled(true);
            }
        }else{
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
