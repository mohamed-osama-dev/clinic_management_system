import 'package:clinic_management_system/app.dart';
import 'package:clinic_management_system/config/di/injection_container.dart';
import 'package:clinic_management_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupInjection();
  runApp(const ClinicEaseApp());
}