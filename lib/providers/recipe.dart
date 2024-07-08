import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recipe with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String image;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'recipe-94a61-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavorites/$userId/$id.json',
        {'auth': token});
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
