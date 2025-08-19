import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes the AppsFlyer SDK and handles conversion data similar to C# example
Future<String?> initAppsFlyer(String devKey) async {
  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: devKey,
    showDebug: true, // toggle for verbose logging
  );

  final AppsflyerSdk appsFlyer = AppsflyerSdk(options);
  final deviceID = await appsFlyer.getAppsFlyerUID();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceId', deviceID ?? '');

  final Completer<String?> completer = Completer();

  await appsFlyer.initSdk(
    registerConversionDataCallback: true,
    registerOnAppOpenAttributionCallback: true,
  );

  appsFlyer.onInstallConversionData((res) {
    final payload = res['payload'] as Map<String, dynamic>?;
    final campaign = payload?['campaign'] as String?;
    completer.complete(campaign);
  });

  return completer.future;
}
