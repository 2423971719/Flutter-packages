import 'dart:async';

import 'package:flutter/services.dart';

class ImeiPlugin {
  static const MethodChannel _channel = const MethodChannel('imei_plugin');

  // get imei android device @return String
  static Future<String> getImei({
    bool shouldShowRequestPermissionRationale = false
  }) async {
    final String imei = await _channel.invokeMethod('getImei', { "ssrpr": shouldShowRequestPermissionRationale });
    return imei;
  }
  static Future<String> getSha1({
    bool shouldShowRequestPermissionRationale = false
  }) async {
    final String sha1 = await _channel.invokeMethod('getSha1', { "ssrpr": shouldShowRequestPermissionRationale });
    return sha1;
  }
  static Future<String> getMd5({
    bool shouldShowRequestPermissionRationale = false
  }) async {
    final String md5 = await _channel.invokeMethod('getMd5', { "ssrpr": shouldShowRequestPermissionRationale });
    return md5;
  }
}
