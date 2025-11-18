// File: lib/main.dart (ĐÃ CẬP NHẬT)

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import file cấu hình Firebase (Giai đoạn 1)
import 'firebase_options.dart';

// Import file router (Giai đoạn 3)
import 'src/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

// Biến MyApp thành ConsumerWidget để có thể 'watch' provider
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 'watch' (theo dõi) routerProvider
    final router = ref.watch(routerProvider);

    // 2. Thay đổi MaterialApp thành MaterialApp.router
    return MaterialApp.router(
      title: 'Sensor Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Bạn có thể đổi màu nếu muốn
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 3. Cấu hình router
      routerConfig: router,
    );
  }
}
