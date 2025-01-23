import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:main_project/firebase_options.dart';
import 'package:main_project/view/about_hotel/hotel_home_screen.dart';
import 'package:main_project/view/about_place/about_place.dart';
import 'package:main_project/view/home/home_bloc.dart';
import 'package:main_project/view/splash_screen/splash_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => HomeBloc(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white70),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        'details': (context) => const AboutPlacesScreen(),
        'hotels': (context) => HotelHomeScreen(),
      },
    );
  }
}
