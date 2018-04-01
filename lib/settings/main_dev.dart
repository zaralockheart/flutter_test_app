import 'package:flutter/material.dart';
import 'package:untitled/settings/app_config.dart';
import 'package:untitled/splash/splash.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors DEV',
    flavorName: 'development',
    apiBaseUrl: 'https://dev-api.example.com/',
    child: new Splash(),
  );

  runApp(configuredApp);
}