import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

const platform = const MethodChannel('shafique.instant_tasker/performPayment');
const integritySalt = '2z89403twb';

String hashingFunc(Map<String, String> data) {
  Map<String, String> temp2 = {};
  data.forEach((k, v) {
    if (v != "") v += "&";
    temp2[k] = v;
  });
  var sortedKeys = temp2.keys.toList(growable: false)
    ..sort((k1, k2) => k1.compareTo(k2));
  Map<String, String> sortedMap = Map.fromIterable(sortedKeys,
      key: (k) => k,
      value: (k) {
        return temp2[k];
      });

  var values = sortedMap.values;
  String toBePrinted = values.reduce((str, ele) => str += ele);
  toBePrinted = toBePrinted.substring(0, toBePrinted.length - 1);
  toBePrinted = integritySalt + '&' + toBePrinted;
  var key = utf8.encode(integritySalt);
  var bytes = utf8.encode(toBePrinted);
  var hash2 = Hmac(sha256, key);
  var digest = hash2.convert(bytes);
  var hash = digest.toString();
  data["pp_SecureHash"] = hash;
  String returnString = "";
  data.forEach((k, v) {
    returnString += k + '=' + v + '&';
  });
  returnString = returnString.substring(0, returnString.length - 1);

  return returnString;
}

Future<void> pay() async {
  // Transaction Start Time
  final currentDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  // Transaction Expiry Time
  final expDate = DateFormat('yyyyMMddHHmmss')
      .format(DateTime.now().add(Duration(minutes: 5)));
  final refNo = 'T' + currentDate.toString();

  // The json map that contains our key-value pairs
  var data = {
    "pp_Amount": "500",
    "pp_BillReference": "billRef",
    "pp_Description": "Description",
    "pp_Language": "EN",
    "pp_MerchantID": "MC17379",
    "pp_Password": "8452hhyxeu",
    "pp_ReturnURL":
        "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction",
    "pp_TxnCurrency": "PKR",
    "pp_TxnDateTime": currentDate,
    "pp_TxnExpiryDateTime": expDate,
    "pp_TxnRefNo": refNo,
    "pp_TxnType": "MWALLET",
    "pp_Version": "1.1",
    "ppmpf_1": "03048947601",
  };
  String postData = hashingFunc(data);
  String responseString;

  try {
    // Trigger native code through channel method
    // The first arguemnt is the name of method that is invoked
    // The second argument is the data passed to the method as input
    final result =
        await platform.invokeMethod('performPayment', {"postData": postData});

    // Await for response from above before moving on
    // The response contains the result of the transaction
    responseString = result.toString();
  } on PlatformException catch (e) {
    // On Channel Method Invocation Failure
    print("PLATFORM_EXCEPTION: ${e.message.toString()}");
  }

  // Parse the response now
  List<String> responseStringArray = responseString.split('&');
  Map<String, String> response = {};
  responseStringArray.forEach((e) {
    if (e.length > 0) {
      e.trim();
      final c = e.split('=');
      response[c[0]] = c[1];
    }
  });
// Use the transaction response as needed now
  print(response);
}
