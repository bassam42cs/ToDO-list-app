import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/config/application_theme_manager.dart';
import 'package:todo_app/core/services/loading_service.dart';
import 'package:todo_app/features/layout_view.dart';
import 'package:todo_app/features/login/pages/login_view.dart';
import 'package:todo_app/features/register/pages/register_view.dart';
import 'package:todo_app/features/settings_provider.dart';
import 'package:todo_app/features/splash/pages/splash_view.dart';

import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      theme: ApplicationThemeManager.lightThemeData,
      darkTheme: ApplicationThemeManager.darkThemeData,
      themeMode: vm.currentTheme,
      initialRoute: SplashView.routeName,
      navigatorKey: navigatorKey,
      routes: {
        SplashView.routeName: (context) => const SplashView(),
        LoginView.routeName: (context) => LoginView(),
        RegisterView.routeName: (context) => RegisterView(),
        LayoutView.routeName: (context) => const LayoutView(),
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: EasyLoading.init(builder: BotToastInit()),
    );
  }
}
