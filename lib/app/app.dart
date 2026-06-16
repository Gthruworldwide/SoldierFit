import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'services/firebase/firebase_service.dart';
import 'services/xp/xp_service.dart';
import 'services/rank/rank_service.dart';

class SoldierFitApp extends StatelessWidget {
  const SoldierFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => XPService()),
        ChangeNotifierProvider(create: (_) => RankService()),
        Provider(create: (_) => FirebaseService()),
      ],
      child: MaterialApp(
        title: 'SoldierFit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const HomePage();
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tacticalBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SOLDIERFIT',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.neonGreen,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: AppTheme.neonGreen,
            ),
          ],
        ),
      ),
    );
  }
}
