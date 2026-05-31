import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeImageService {
  static Future<String?> fetchImageUrl(String foodName) async {
    try {
      final full = await _search(foodName.trim());
      if (full != null) return full;
      final firstWord = foodName.trim().split(RegExp(r'\s+')).first;
      if (firstWord.length > 2 &&
          firstWord.toLowerCase() != foodName.trim().toLowerCase()) {
        return _search(firstWord);
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _search(String query) async {
    final uri = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(query)}',
    );
    final response =
        await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List?;
    if (meals == null || meals.isEmpty) return null;
    return (meals.first as Map<String, dynamic>)['strMealThumb'] as String?;
  }
}
