import 'package:flutter/material.dart';
import 'package:untitled/main/main.dart';
import 'package:untitled/settings/app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors PROD',
    flavorName: 'production',
    apiBaseUrl: 'https://prod-api.example.com/',
    child: new MyApp(),
  );

  runApp(configuredApp);
}