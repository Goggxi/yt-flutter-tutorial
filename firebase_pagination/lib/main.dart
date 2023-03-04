import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/wallpaper_page.dart';
import 'package:firebase_pagination/wallpaper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WallpaperProvider(),
      child: MaterialApp(
        title: 'Wallpaper Pagination',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const WallpaperPage(),
      ),
    );
  }
}
