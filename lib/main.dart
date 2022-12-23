import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_job_mobile/routes/route_generator.dart';
import 'package:it_job_mobile/shared/applicant_preferences.dart';
import 'package:it_job_mobile/utils/app_them.dart';
import 'package:it_job_mobile/providers/main_providers/main_providers.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

int initScreen = 0;

Future<void> backgroundHandler(RemoteMessage message) async {}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  await ApplicantPreferences.init();
  initScreen = ApplicantPreferences.getInitScreen(0);
  ApplicantPreferences.setInitScreen(1);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  //await FirebaseMessaging.instance.getInitialMessage();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: ((context, orientation, deviceType) {
        return MultiProvider(
          providers: MainProviders.providers,
          child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('vi', 'VN'),
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: initScreen == 0
                ? RoutePath.onboardingRoute
                : RoutePath.signInRoute,
            theme: getConfigTheme(),
            onGenerateRoute: RouteGenerator.getRoute,
          ),
        );
      }),
    );
  }
}
