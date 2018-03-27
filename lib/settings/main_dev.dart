import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/settings/app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors DEV',
    flavorName: 'development',
    apiBaseUrl: 'https://dev-api.example.com/',
    child: new MyApp(),
  );

  runApp(configuredApp);
}