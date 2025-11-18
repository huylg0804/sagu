// File: lib/src/features/auth/presentation/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

// Chúng ta dùng [ConsumerStatefulWidget] để:
// 1. Truy cập [ref] (để gọi provider)
// 2. Quản lý State của các TextField (email, password)
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Khai báo các controller cho TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = ''; // Để hiển thị lỗi nếu đăng nhập thất bại
  bool _isLoading = false; // Để hiển thị vòng xoay loading

  @override
  void dispose() {
    // Luôn dispose controller khi widget bị hủy
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm xử lý logic khi nhấn nút "Đăng nhập"
  Future<void> _login() async {
    // 1. Bắt đầu loading và xóa lỗi cũ
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 2. Lấy AuthRepository từ provider
      //    Chúng ta dùng ref.read() vì ta đang ở trong một hàm,
      //    không cần "watch" (lắng nghe) thay đổi.
      final authRepo = ref.read(authRepositoryProvider);

      // 3. Gọi hàm signInWithEmail
      await authRepo.signInWithEmail(
        _emailController.text.trim(), // .trim() để xóa khoảng trắng
        _passwordController.text.trim(),
      );

      // (Nếu đăng nhập thành công, Giai đoạn 3 (Routing)
      //  sẽ tự động điều hướng chúng ta sang trang Dashboard)
    } catch (e) {
      // 4. Nếu có lỗi, bắt lỗi và hiển thị
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      // 5. Dù thành công hay thất bại, cũng dừng loading
      if (mounted) {
        // Đảm bảo widget vẫn còn trên cây (tree)
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: _isLoading
                    ? null
                    : _login, // Cho phép nhấn "Enter" để login
              ),
              const SizedBox(height: 32),

              // Hiển thị lỗi nếu có
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Nút Đăng nhập
              _isLoading
                  ? const CircularProgressIndicator() // Hiển thị loading
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('Đăng nhập'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
