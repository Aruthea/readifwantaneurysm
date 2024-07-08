import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipeapp/screens/import_screen.dart';
import '/providers/auth.dart';
import '/providers/recipes.dart';
import '/screens/auth_screen.dart';
import 'screens/create_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/result_screen.dart';
import '/screens/favorite_screen.dart';
import '/screens/recipe_detail_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  MaterialColor mycolor = const MaterialColor(
    0xffa17a74,
    <int, Color>{
      50: Color.fromARGB(255, 74, 65, 64),
      100: Color.fromARGB(255, 74, 65, 64),
      200: Color.fromARGB(255, 74, 65, 64),
      300: Color.fromARGB(255, 74, 65, 64),
      400: Color.fromARGB(255, 74, 65, 64),
      500: Color.fromARGB(255, 74, 65, 64),
      600: Color.fromARGB(255, 74, 65, 64),
      700: Color.fromARGB(255, 74, 65, 64),
      800: Color.fromARGB(255, 74, 65, 64),
      900: Color.fromARGB(255, 74, 65, 64),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Recipes?>(
          create: (_) {},
          update: (ctx, auth, previousRecipe) {
            return Recipes(
              auth.token,
              auth.userId,
              previousRecipe == null ? [] : previousRecipe.items,
            );
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Recipe App',
          theme: ThemeData(
            primarySwatch: mycolor,
            textTheme: GoogleFonts.merriweatherTextTheme(),
          ),
          routes: {
            CreateScreen.routeName: (ctx) => const CreateScreen(),
            EditScreen.routeName: (ctx) => const EditScreen(),
            ResultScreen.routeName: (ctx) => const ResultScreen(),
            EditorScreen.routeName: (ctx) => const EditorScreen(),
            ImportScreen.routeName: (ctx) => const ImportScreen(),
            RecipeScreen.routeName: (ctx) => const RecipeScreen(),
            RecipeDetailScreen.routeName: (ctx) => const RecipeDetailScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            FavoriteScreen.routeName: (ctx) => const FavoriteScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => const CreateScreen());
          },
          home: auth.authed ? const RecipeScreen() : const AuthScreen(),
        ),
      ),
    );
  }
}
