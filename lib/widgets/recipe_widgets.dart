import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/providers/recipe.dart';
import '/providers/recipes.dart';
import '/screens/recipe_detail_screen.dart';

class RecipeGrid extends StatelessWidget {
  final MediaQueryData media;
  final String search;
  const RecipeGrid({super.key, required this.media, required this.search});

  @override
  Widget build(BuildContext context) {
    final recipesData = Provider.of<Recipes>(context);
    final recipes = recipesData.items;
    final filteredRecipes = search.isEmpty
        ? recipes
        : recipes.where((recipe) {
            final title = recipe.title.toLowerCase();
            return title.contains(search.toLowerCase());
          }).toList();

    return SizedBox(
      height: media.size.height * 0.79,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          return RecipeItem(data: filteredRecipes[i]);
        },
        itemCount: filteredRecipes.length,
      ),
    );
  }
}

class RecipeItem extends StatefulWidget {
  final Recipe data;
  const RecipeItem({super.key, required this.data});

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<Recipes>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        title: Center(
          child: Text(
            widget.data.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {});
            recipes.toggleFavoriteStatus(
                authData.token!, authData.userId, widget.data.id!);
            setState(() {});
          },
          icon: Icon(
            widget.data.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever),
          color: Colors.red,
          onPressed: () async {
            try {
              await Provider.of<Recipes>(context, listen: false)
                  .deleteRecipe(widget.data.id.toString());
            } catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(RecipeDetailScreen.routeName,
              arguments: widget.data.id);
        },
        child: Hero(
          tag: widget.data.id as Object,
          child: FadeInImage(
            placeholder: const AssetImage('assets/images/logo.png'),
            image: widget.data.image == ''
                ? const AssetImage('assets/images/logo.png') as ImageProvider
                : NetworkImage(widget.data.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FavoriteGrid extends StatefulWidget {
  final MediaQueryData media;
  const FavoriteGrid({super.key, required this.media});

  @override
  State<FavoriteGrid> createState() => _FavoriteGridState();
}

class _FavoriteGridState extends State<FavoriteGrid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.media.size.height * 0.79,
        child: Consumer<Recipes>(
          builder: (context, value, _) {
            var recipes = value.favoriteItems;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => RecipeItem(data: recipes[i]),
              itemCount: recipes.length,
            );
          },
        ));
  }
}
