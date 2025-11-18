import 'package:flutter/foundation.dart';

@immutable
class SensorData {
  final double ec; // Thay salinity bằng ec cho rõ
  final double ppt;
  final double temp;
  final double ph;
  final DateTime timestamp;

  const SensorData({
    required this.ec,
    required this.ppt,
    required this.temp,
    required this.ph,
    required this.timestamp,
  });

  // Hàm lấy giờ phút (ví dụ: 14:30)
  factory SensorData.fromMap(Map<String, dynamic> map) {
    // 1. Hàm phụ để xử lý dữ liệu an toàn (Dù là Số hay Chuỗi "...")
    double parseValue(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble(); // Nếu là số (10)
      if (value is String) {
        return double.tryParse(value) ?? 0.0; // Nếu là chuỗi ("10.5")
      }
      return 0.0;
    }

    // 2. Xử lý Timestamp
    final timestampVal = map['timestamp'];
    DateTime date;
    if (timestampVal is int) {
      date = DateTime.fromMillisecondsSinceEpoch(timestampVal);
    } else {
      date = DateTime.now();
    }

    return SensorData(
      // 3. MAP ĐÚNG TÊN KEY TỪ ẢNH CỦA BẠN
      ec: parseValue(map['ec_ms_cm']), // Sửa 'EC' -> 'ec_ms_cm'
      temp: parseValue(map['temperature']), // Sửa 'Temp' -> 'temperature'
      ph: parseValue(map['ph_value']), // Sửa 'pH' -> 'ph_value'
      ppt: parseValue(map['salinity_ppt']), // Sửa 'ppt' -> 'salinity_ppt'
      timestamp: date,
    );
  }d
}
