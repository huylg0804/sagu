// File: lib/firebase_options.dart
// HÃY SAO CHÉP VÀ DÁN TOÀN BỘ NỘI DUNG NÀY

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Đây là cấu hình từ ảnh chụp màn hình của bạn
      return const FirebaseOptions(
        apiKey: "AIzaSyBGE339gEbD1SrpfG1yxmccl6GlAJ8zTlM",
        authDomain: "salin-c9bcf.firebaseaflutter pub getpp.com",
        databaseURL: "https://salin-c9bcf-default-rtdb.firebaseio.com",
        projectId: "salin-c9bcf",
        storageBucket: "salin-c9bcf.firebasestorage.app",
        messagingSenderId: "717988419516",
        appId: "1:717988419516:web:81cf5d3bd8c6b47c6434e9",
        measurementId: "G-GRX3X3JTND",
      );
    }

    // Phần còn lại đã được sửa lỗi 'TargetTargetPlatform'
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'bạn sẽ cần chạy "flutterfire configure" sau khi cài Android Studio',
        );
      case TargetPlatform.iOS: // ĐÃ SỬA LỖI GÕ NHẦM
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'bạn sẽ cần chạy "flutterfire configure" trên máy macOS',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
