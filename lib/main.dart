import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pingo_demo_rahul/screens/auth_wrapper.dart';
import 'package:pingo_demo_rahul/services/auth_service.dart';
import 'package:pingo_demo_rahul/services/news_service.dart';
import 'package:pingo_demo_rahul/services/remote_config_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => NewsService()),
        FutureProvider<RemoteConfigService>(
          create: (_) => RemoteConfigService.initialize(),
          initialData: RemoteConfigService.defaultService(),
          catchError: (_, error) {
            return RemoteConfigService.defaultService();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
