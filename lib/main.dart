import 'package:flutter/material.dart';
import 'package:futurehook_crm/futurehook_crm_app.dart';
import 'core/sevice_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await serviceLocatorInit();
  runApp(
    const FuturehookCRMApp(),
  );
}
