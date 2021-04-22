import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const platform = const MethodChannel('com.instant_tasker/performPayment');

payment() async {
  String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
  String dexpiredate = DateFormat("yyyyMMddHHmmss")
      .format(DateTime.now().add(Duration(days: 1)));
  String tre = "T" + dateandtime;
  // ignore: non_constant_identifier_names
  String pp_Amount = "500";
  // ignore: non_constant_identifier_names
  String pp_BillReference = "billRef";
  // ignore: non_constant_identifier_names
  String pp_Description = "Description";
  // ignore: non_constant_identifier_names
  String pp_Language = "EN";
  // ignore: non_constant_identifier_names
  String pp_MerchantID = "MC17379";
  // ignore: non_constant_identifier_names
  String pp_Password = "8452hhyxeu";

// ignore: non_constant_identifier_names
  String pp_ReturnURL =
      "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
  // ignore: non_constant_identifier_names
  String pp_ver = "1.1";
  // ignore: non_constant_identifier_names
  String pp_TxnCurrency = "PKR";
  // ignore: non_constant_identifier_names
  String pp_TxnDateTime = dateandtime.toString();
  // ignore: non_constant_identifier_names
  String pp_TxnExpiryDateTime = dexpiredate.toString();
  // ignore: non_constant_identifier_names
  String pp_TxnRefNo = tre.toString();
  // ignore: non_constant_identifier_names
  String pp_TxnType = "MWALLET";
  String ppmpf_1 = "03048947601";
  // ignore: non_constant_identifier_names
  String IntegeritySalt = "2z89403twb";
  String and = '&';
  String superdata = IntegeritySalt +
      and +
      pp_Amount +
      and +
      pp_BillReference +
      and +
      pp_Description +
      and +
      pp_Language +
      and +
      pp_MerchantID +
      and +
      pp_Password +
      and +
      pp_ReturnURL +
      and +
      pp_TxnCurrency +
      and +
      pp_TxnDateTime +
      and +
      pp_TxnExpiryDateTime +
      and +
      pp_TxnRefNo +
      and +
      pp_TxnType +
      and +
      pp_ver +
      and +
      ppmpf_1;

  var key = utf8.encode(IntegeritySalt);
  var bytes = utf8.encode(superdata);
  var hmacSha256 = new Hmac(sha256, key);
  Digest sha256Result = hmacSha256.convert(bytes);
  var url =
      'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

  var response = await http.post(Uri.parse(url), body: {
    "pp_Version": pp_ver,
    "pp_TxnType": pp_TxnType,
    "pp_Language": pp_Language,
    "pp_MerchantID": pp_MerchantID,
    "pp_Password": pp_Password,
    "pp_TxnRefNo": tre,
    "pp_Amount": pp_Amount,
    "pp_TxnCurrency": pp_TxnCurrency,
    "pp_TxnDateTime": dateandtime,
    "pp_BillReference": pp_BillReference,
    "pp_Description": pp_Description,
    "pp_TxnExpiryDateTime": dexpiredate,
    "pp_ReturnURL": pp_ReturnURL,
    "pp_SecureHash": sha256Result.toString(),
    "ppmpf_1": "1",
  });

  print("response=>");
  print(response.body);
}
