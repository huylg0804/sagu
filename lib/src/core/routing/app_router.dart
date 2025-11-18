// File: lib/src/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import các provider và các trang của chúng ta
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/dashboard_page.dart';

// Provider cho GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  // 1. Watch (theo dõi) provider trạng thái đăng nhập
  //    authState.value sẽ là User (nếu đã login) hoặc null (nếu chưa)
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    // Bắt đầu ứng dụng ở trang '/dashboard'
    // Logic redirect sẽ xử lý nếu chưa đăng nhập
    initialLocation: '/dashboard',

    // 2. Logic điều hướng tự động (redirect)
    redirect: (BuildContext context, GoRouterState state) {
      // Lấy trạng thái đăng nhập
      // authState.value != null có nghĩa là đã đăng nhập
      final isLoggedIn = authState.value != null;

      // Lấy vị trí (path) mà người dùng đang truy cập
      final location = state.uri.toString();

      // Kịch bản 1: Chưa đăng nhập VÀ đang không ở trang login
      // -> Đẩy về trang /login
      if (!isLoggedIn && location != '/login') {
        return '/login';
      }

      // Kịch bản 2: Đã đăng nhập VÀ đang ở trang login
      // -> Đẩy về trang /dashboard
      if (isLoggedIn && location == '/login') {
        return '/dashboard';
      }

      // Các trường hợp khác (ví dụ: đang tải, hoặc đã ở đúng chỗ)
      // thì không cần redirect, trả về null.
      return null;
    },

    // 3. Định nghĩa các trang (routes)
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
});
