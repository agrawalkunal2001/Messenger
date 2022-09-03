import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/widgets/error.dart';
import 'package:messenger/common/widgets/loader.dart';
import 'package:messenger/features/auth/controller/auth_controller.dart';
import 'package:messenger/features/landing/screens/landing_screen.dart';
import 'package:messenger/firebase_options.dart';
import 'package:messenger/responsive/responsive_layout.dart';
import 'package:messenger/router.dart';
import 'package:messenger/screens/mobile_screen_layout.dart';
import 'package:messenger/screens/web_screen_layout.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
      child: MyApp())); // Provider scope consists of the state of application
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return MobileScreenLayout();
            },
            error: (error, trace) {
              return ErrorScreen(error: error.toString());
            },
            loading: () => const Loader(),
          ), // We could also use FutureBuilder, but we would have to write all error and loading conditions manually like if connection=connection state.loading etc.
    );
  }
}
