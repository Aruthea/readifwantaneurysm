import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/model.dart';

abstract class HomePageRepository {
  Future<dynamic> askAI(String prompt1, prompt2, prompt3);
  Future<dynamic> askAI2(String prompt4, prompt5, prompt6, recipe);
}

class HomePageRepo extends HomePageRepository {
  @override
  Future<dynamic> askAI(String prompt1, prompt2, prompt3) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-instruct",
            "prompt":
                "Buat resep dari judul: \n$prompt1, daftar bahan: \n$prompt2, detail: \n$prompt3",
            "max_tokens": 500,
            "temperature": 0,
            "top_p": 1,
          },
        ),
      );
      print(response.body);
      return ResponseModel.fromJson(response.body).choices[0]['text'];
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<dynamic> askAI2(String prompt4, prompt5, prompt6, recipe) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-instruct",
            "prompt":
                "Ubah resep $recipe dengan memasukkan judul: \n$prompt4, daftar bahan: \n$prompt5, detail: \n$prompt6",
            "max_tokens": 500,
            "temperature": 0,
            "top_p": 1,
          },
        ),
      );
      print(response.body);
      return ResponseModel.fromJson(response.body).choices[0]['text'];
    } catch (e) {
      return e.toString();
    }
  }
}
