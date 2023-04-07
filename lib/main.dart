import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_vg/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Schermo sempre in Verticale
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SnakeVG());
}

class SnakeVG extends StatelessWidget {
  const SnakeVG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'images/snake.png',
        ),
        nextScreen: MainPage(),
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.deepPurpleAccent,
        duration: 2000,
      ),
    );
  }
}
