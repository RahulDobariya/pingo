import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = 'e8666daa6ea7430b8deda5d4f61fff6f';

  Future<List<Article>> fetchTopHeadlines(String country) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}

class Article {
  final String? title;
  final String? description;

  Article({required this.title, required this.description});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
    );
  }
}
