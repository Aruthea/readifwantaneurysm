import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/screens/import_screen.dart';
import '/providers/recipes.dart';
import 'editor_screen.dart';
import '/widgets/recipe_widgets.dart';
import '/widgets/appbar.dart';
import '/widgets/drawer.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  static const routeName = '/recipe';

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  var _isInit = true;
  var _isLoading = false;
  String _searchController = '';

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); WON'T WORK (only work if listen:false)

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Recipes>(context).fetchAndSetRecipes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: const AppBars(title: "Daftar Resep"),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffc71565),
        foregroundColor: Colors.white,
        mini: true,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc71565),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EditorScreen.routeName);
                        },
                        child: const Text('Tambah Resep'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc71565),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ImportScreen.routeName);
                        },
                        child: const Text('Impor Resep'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // Navigator.of(context).pushNamed(EditorScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Container(
            height: media.size.height * 0.07,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: SearchBar(
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
              leading: const Icon(Icons.search),
              hintText: 'Search Recipes',
              backgroundColor: const MaterialStatePropertyAll(Colors.white70),
              shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(30),
              )),
              onChanged: (value) {
                setState(() {
                  _searchController = value;
                });
              },
            ),
          ),
          Expanded(child: RecipeGrid(media: media, search: _searchController)),
        ],
      ),
    );
  }
}
