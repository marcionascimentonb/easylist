import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fast_rsa/rsa.dart';

class Deal {}

class APIWalmart {
  static final _consumerId = 'e8215728-ca7b-4445-993f-00a954292539';
  static final _epochTime =
      DateTime.now().add(new Duration(days: 45)).millisecondsSinceEpoch;
  static final _keyVersion = '';
  static final _url =
      'https://developer.api.walmart.com/api-proxy/service/affil/product/v2/search?query=canola';

  /// Makes this a singleton class
  APIWalmart._privateConstructor();
  static final APIWalmart instance = APIWalmart._privateConstructor();

  static final Map<String, dynamic> _heardersMap = {
    'WM_CONSUMER.ID': _consumerId,
    'WM_CONSUMER.INTIMESTAMP': _epochTime.toString(),
    'WM_SEC.KEY_VERSION': _keyVersion
  };

  static List<int> _encodedHeadersMap = utf8.encode(
      _heardersMap["WM_CONSUMER.ID"] +
          '\n' +
          _heardersMap['WM_CONSUMER.INTIMESTAMP'] +
          '\n' +
          _heardersMap['WM_SEC.KEY_VERSION'] +
          '\n');

  /// Returns the signature with privatekey
  Future<Uint8List> get signature async {
    var privateKey =
        await rootBundle.loadString('assets/WM_IO_private_key.pem');
    // privateKey = privateKey
    //     .replaceAll("-----BEGIN PRIVATE KEY-----", "")
    //     .replaceAll("-----END PRIVATE KEY-----", "");
    return await RSA.signPKCS1v15Bytes(
        _encodedHeadersMap, RSAHash.sha256, privateKey);
  }

  //Future<List<Deal>> fetchDeals() async {
  Future<Map<String, dynamic>> fetchDeals() async {
    var _signatureEnc = base64UrlEncode(await instance.signature);

    Map<String, String> headers = {
      'WM_CONSUMER.ID': _consumerId,
      'WM_CONSUMER.INTIMESTAMP': _epochTime.toString(),
      'WM_SEC.AUTH_SIGNATURE': _signatureEnc,
      'WM_SEC.KEY_VERSION': _keyVersion,
      'WM_QOS.CORRELATION_ID': '1234hfvgtr',
      'WM_IFX.CLIENT_TYPE': 'INTERNAL',
      'WM_PREVIEW': 'false',
      'WM_SHOW_REASON_CODES': 'ALL',
      'Content-Type': 'application/json',
    };

    var response = await http.get(_url, headers: headers);
    var deals = List<Deal>();
    var responseDeals;
    if (response.statusCode == 200) {
      responseDeals = json.decode(response.body);

      // for (var deal in responseDeals) {
      //   deals.add(Deal.fromJson(deal));
      // }
    }
    return responseDeals;
  }
}
