import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'recipe.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _items = [];
  String? authToken = '';
  String? userId;

  Recipes(this.authToken, this.userId, this._items);

  List<Recipe> get items {
    return [..._items];
  }

  Recipe findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Recipe> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> toggleFavoriteStatus(
      String token, String userId, String id) async {
    var index = items.indexWhere((element) => element.id == id);
    items[index].isFavorite = !items[index].isFavorite;
    notifyListeners();
    final url = Uri.https(
        'recipe-94a61-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavorites/$userId/$id.json',
        {'auth': token});
    try {
      final response = await http.put(
        url,
        body: json.encode(items[index].isFavorite),
      );
      if (response.statusCode >= 400) {
        items[index].isFavorite = !items[index].isFavorite;
        notifyListeners();
      }
    } catch (error) {
      items[index].isFavorite = !items[index].isFavorite;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetRecipes([bool filterByUser = false]) async {
    var params;
    if (filterByUser == true) {
      params = <String, String?>{
        'auth': authToken,
      };
    }
    var url = Uri.https(
      'recipe-94a61-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/recipes.json',
      params,
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == {}) {
        return;
      }
      url = Uri.https(
          'recipe-94a61-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/userFavorites/$userId.json',
          {'auth': '$authToken'});
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Recipe> loadedRecipes = [];
      extractedData.forEach((key, value) {
        loadedRecipes.add(Recipe(
          id: key,
          title: value['title'],
          description: value['description'],
          image: value['image'],
          isFavorite: favData == null ? false : favData[key] ?? false,
        ));
      });
      _items = loadedRecipes;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    final url = Uri.https(
        'recipe-94a61-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/recipes.json',
        {'auth': '$authToken'});
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': recipe.title,
          'description': recipe.description,
          'image': recipe.image,
          'creatorId': userId,
        }),
      );
      final newRecipe = Recipe(
        id: json.decode(response.body)['name'],
        title: recipe.title,
        description: recipe.description,
        image: recipe.image,
      );
      _items.add(newRecipe);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateRecipe(String id, Recipe newRecipe) async {
    final recipeIndex = _items.indexWhere((element) => element.id == id);
    if (recipeIndex >= 0) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("recipes/$id");
      await ref.update({
        "title": newRecipe.title,
        "description": newRecipe.description,
        "image": newRecipe.image,
      });
      _items[recipeIndex] = newRecipe;
      notifyListeners();
    } else {}
  }

  Future<void> deleteRecipe(String id) async {
    final existingRecipeIndex =
        _items.indexWhere((element) => element.id == id);
    DatabaseReference ref = FirebaseDatabase.instance.ref("recipes/$id");
    await ref.remove();
    _items.removeAt(existingRecipeIndex);
    notifyListeners();
  }
}
