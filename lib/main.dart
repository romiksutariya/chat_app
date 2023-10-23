import 'package:chat_flutter_app/utils/theme.dart';
import 'package:chat_flutter_app/views/screens/Intro_page.dart';
import 'package:chat_flutter_app/views/screens/chat_page.dart';
import 'package:chat_flutter_app/views/screens/home_page.dart';
import 'package:chat_flutter_app/views/screens/setting_page.dart';
import 'package:chat_flutter_app/views/screens/splash_screen.dart';
import 'package:chat_flutter_app/views/screens/signUp_page.dart';
import 'package:chat_flutter_app/views/screens/verifyPhone_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/Intro_page',
          page: () => IntroPage(),
        ),
        GetPage(
          name: '/signUp_page',
          page: () => SignUpPage(),
        ),
        GetPage(
          name: '/home_page',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/chat_page',
          page: () => ChatPage(),
        ),
        GetPage(
          name: '/setting_page',
          page: () => SettingPage(),
        ),
        GetPage(
          name: '/verifyPhone_page',
          page: () => VerifyPhonePage(),
        ),
      ],
    ),
  );
}
