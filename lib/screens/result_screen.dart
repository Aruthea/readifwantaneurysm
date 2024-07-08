import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/appbar.dart';
import 'editor_screen.dart';
import 'edit_screen.dart';
import 'recipe_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const routeName = '/result';

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: const AppBars(title: 'Resep Anda'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              Text(
                result,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditScreen.routeName, arguments: result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text('Ubah'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(RecipeScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text('Home'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditorScreen.routeName,
                          arguments: {'type': 'result', 'data': result});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
