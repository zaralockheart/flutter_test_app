import 'package:flutter/material.dart';
import 'package:untitled/main/main.dart';
import 'package:untitled/settings/app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors DEV',
    flavorName: 'development',
    apiBaseUrl: 'https://dev-api.example.com/',

    /// Change here if you want to change your first screen
    child: new MyApp(),
  );

  runApp(configuredApp);
}