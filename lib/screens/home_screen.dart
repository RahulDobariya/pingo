import 'package:flutter/material.dart';
import 'package:pingo_demo_rahul/services/auth_service.dart';
import 'package:pingo_demo_rahul/services/news_service.dart';
import 'package:pingo_demo_rahul/services/remote_config_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfigService = Provider.of<RemoteConfigService>(context);

    if (remoteConfigService == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final newsService = Provider.of<NewsService>(context);
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            newsService.fetchTopHeadlines(remoteConfigService.getCountryCode()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data as List<Article>).isEmpty) {
            return const Center(child: Text('No news found'));
          } else {
            List<Article> articles = snapshot.data as List<Article>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(articles[index].title.toString()),
                  subtitle: Text(articles[index].description.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
