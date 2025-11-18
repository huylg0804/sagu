// File: lib/src/features/dashboard/logic/dashboard_providers.dart (CHỈ CẦN DỮ LIỆU TỨC THỜI)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/data/dashboard_repository.dart';
import '../../../features/auth/data/sensor_model.dart';

final dashboardRepositoryProvider = Provider((ref) => DashboardRepository());

// Provider cung cấp danh sách lịch sử cho biểu đồ
final sensorHistoryProvider = StreamProvider<List<SensorData>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getHistoryStream();
});
