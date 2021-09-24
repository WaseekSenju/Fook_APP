import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import '/Controllers/Providers/collectionController.dart';
import '/Controllers/Providers/tokkensInCollection.dart';
import '/Controllers/Providers/userData.dart';
import '/Screens/NavigationScreens/home_screen.dart';
import '/Screens/interest_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'Controllers/Providers/getAllTokkens.dart';
import 'Screens/NavigationScreens/NewPostScreens/camera.dart';
import 'Screens/NavigationScreens/newPost_screen.dart';
import 'Screens/signIn_screen.dart';
import 'Screens/tabs_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'style.dart';

enum pageState {
  LoginPage,
  SignupPage,
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AllTokens>(
      create: (_) => AllTokens(),
    ),
    ChangeNotifierProvider<CollectionController>(
      create: (_) => CollectionController(),
    ),
    ChangeNotifierProvider<UserTokensController>(
      create: (_) => UserTokensController(),
    ),
    ChangeNotifierProvider<UserData>(
      create: (_) => UserData(),
    ),
  ];
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fook App',
        theme: ThemeData(
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.black,
            ),
            headline2: TextStyle(
              color: Colors.grey,
            ),
            bodyText1: TextStyle(
              color: Color(0xFFF1833D),
            ),
            bodyText2: TextStyle(color: Colors.white),
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
          primaryColor: createMaterialColor(Color(0xFFF1833D)),
          colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: createMaterialColor(Color(0xFFF1833D)))
              .copyWith(secondary: Colors.grey),
        ),
        routes: {
          '/': (builder) => SignInPage(),
          HomeScreen.routeName: (builder) => HomeScreen(),
          NewPost.routeName: (builder) => NewPost(),
          TabsScreen.routeName: (builder) => TabsScreen(),
          InterestsPage.routeName: (builder) => InterestsPage(),
        },
      ),
    );
  }
}
