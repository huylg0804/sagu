import 'package:firebase_database/firebase_database.dart';
import 'sensor_model.dart';

class DashboardRepository {
  // Trỏ vào node chứa lịch sử
  final DatabaseReference _readingsRef =
      FirebaseDatabase.instance.ref('sensor_logs');

  // Lấy 20 điểm dữ liệu gần nhất
  Stream<List<SensorData>> getHistoryStream() {
    return _readingsRef.limitToLast(20).onValue.map((event) {
      final List<SensorData> dataList = [];
      if (event.snapshot.value != null) {
        // Firebase trả về Map, ta cần chuyển nó thành List
        final Map<dynamic, dynamic> values = event.snapshot.value as Map;
        values.forEach((key, value) {
          final dataMap = Map<String, dynamic>.from(value as Map);
          dataList.add(SensorData.fromMap(dataMap));
        });
      }
      // Sắp xếp lại theo thời gian (cũ trước, mới sau)
      dataList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return dataList;
    });
  }
}
