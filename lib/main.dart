import 'package:CharVault/firebase_options.dart';
import 'package:CharVault/helpers/shared_preferences_helper.dart';
import 'package:CharVault/pages/initial_page.dart';
import 'package:CharVault/pages/landing_page.dart';
import 'package:CharVault/pages/user_profile_page.dart';
import 'package:CharVault/providers/login_provider.dart';
import 'package:CharVault/providers/theme_provider.dart';
import 'package:CharVault/services/auth_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CharVault/constants/strings.constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => LoginProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('pt-BR')],
      debugShowCheckedModeBanner: false,
      title: 'Character Vault',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: StreamBuilder<User?>(
          stream: AuthService.userStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return snapshot.hasData
                    ? const UserProfilePage()
                    : const LandingPage();
              default:
                return const LandingPage();
            }
          }),
    );
  }
}
