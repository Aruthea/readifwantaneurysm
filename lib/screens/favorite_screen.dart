import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/widgets/appbar.dart';
import 'package:recipeapp/widgets/drawer.dart';
import 'package:recipeapp/widgets/recipe_widgets.dart';

import '../providers/recipes.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  static const routeName = '/favorite';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var _isInit = true;
  var _isLoading = false;
  final _showFavs = true;

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
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: const AppBars(title: 'Favorites'),
      drawer: const AppDrawer(),
      body: FavoriteGrid(media: media),
    );
  }
}
