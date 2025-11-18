// File: lib/src/features/auth/data/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lớp AuthRepository: đóng gói logic Firebase Auth
class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  // 1. Stream theo dõi trạng thái đăng nhập
  //    Stream này sẽ phát sra User (nếu đã đăng nhập) hoặc null (nếu đã đăng xuất)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 2. Hàm Đăng nhập
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow; // Ném lỗi ra để UI (ở Bước 8) có thể bắt và hiển thị
    }
  }

  // 3. Hàm Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// === CÁC PROVIDER (RIVERPOD) ===

// Provider 1: Cung cấp một thể hiện (instance) của FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider 2: Cung cấp AuthRepository, tự động lấy FirebaseAuth từ provider 1
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

// Provider 3 (Rất quan trọng):
// Cung cấp trạng thái đăng nhập MỘT CÁCH TỰ ĐỘNG
// UI sẽ "watch" provider này để biết user đã login hay chưa.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // Nó lắng nghe Stream 'authStateChanges' từ repository
  return ref.watch(authRepositoryProvider).authStateChanges;
});
