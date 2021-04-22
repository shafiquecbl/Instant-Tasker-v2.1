package shafique.instant.tasker;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "shafique.instant_tasker/performPayment";
  
  private static final int PAYMENT_ACTIVITY_RESULT_CODE = 101;
  private MethodChannel.Result _result;
@Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
// Initialize the Platform Channel
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
      .setMethodCallHandler((call, result) -> {
        _result = result;
if (call.method.equals("performPayment")) {
          String postData = call.argument("postData");
Intent intent = new Intent(MainActivity.this, PaymentActivity.class);
          intent.putExtra("postData", postData);
          startActivityForResult(
            intent,
            PAYMENT_ACTIVITY_RESULT_CODE
          );
        }
      });
  }
@Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
if(requestCode == PAYMENT_ACTIVITY_RESULT_CODE){
      // Parse response data back as map     
      String response = "";
      if (data != null) {
        response = data.getStringExtra("response");
      }       
        
      _result.success(response);
    }
  }
}