package shafique.instant.tasker;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import shafique.instant.tasker.R;
import android.graphics.Bitmap;
import android.widget.LinearLayout;
import android.view.ViewGroup;
public class PaymentActivity extends FlutterActivity {
  private static final String CHANNEL = "shafique.instant_tasker/performPayment";
private static final String paymentUrl = "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/";
  private static final String paymentReturnUrl = "https://sandbox.jazzcash.com.pk/CustomerPortal/TransactionManagement/http//localhost/case.php";
      
  WebView mWebView;
@Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_payment);
mWebView = findViewById(R.id.webview);
Intent intentData = getIntent();
    String postData = intentData.getStringExtra("postData");
WebSettings webSettings = mWebView.getSettings();
    webSettings.setJavaScriptEnabled(true);
mWebView.setWebViewClient(new MyWebViewClient());
    webSettings.setDomStorageEnabled(true);
    mWebView.addJavascriptInterface(
      new FormDataInterface(),
      "FORMOUT"
    );
mWebView.postUrl( "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/", postData.getBytes());
  }
private class MyWebViewClient extends WebViewClient {
    private final String jsCode ="" + "function parseForm(form){"+
            "var values='';"+
            "for(var i=0 ; i< form.elements.length; i++){"+
            "    values+=form.elements[i].name+'='+form.elements[i].value+'&'"+
            "}"+
            "var url=form.action;"+
            "console.log('parse form fired');"+
            "window.FORMOUT.processFormData(url,values);"+
            "   }"+
            "for(var i=0 ; i< document.forms.length ; i++){"+
            "   parseForm(document.forms[i]);"+
            "};";
@Override
  public void onPageStarted(WebView view, String url, Bitmap favicon) {
    if(url.equals(paymentReturnUrl)){
      System.out.println("Equal On Page Started: " + url);
      view.stopLoading();
      return;
    }
    super.onPageStarted(view, url, favicon);
  }
@Override
  public void onPageFinished(WebView view, String url) {
    if(url.equals(paymentReturnUrl)){
      return;
    }
    view.loadUrl("javascript:(function() { " + jsCode + "})()");
super.onPageFinished(view, url);
  }
}
private class FormDataInterface {
  @JavascriptInterface
  public void processFormData(String url, String formData) {
    Intent i = new Intent(PaymentActivity.this, MainActivity.class);
     
    if (url.equals(paymentReturnUrl)) {
      i.putExtra("response", formData);
setResult(RESULT_OK, i);
      finish();
return;
    }
  }
}
}