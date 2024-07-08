import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/favorite_screen.dart';
import '/screens/auth_screen.dart';
import '/screens/create_screen.dart';
import '/screens/recipe_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("ResepMu"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Daftar Resep"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RecipeScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favorite"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FavoriteScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text("Ciptakan Resep"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(CreateScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
              });
            },
          ),
        ],
      ),
    );
  }
}
