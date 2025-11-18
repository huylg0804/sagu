import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/sensor_model.dart';

class SensorLineChart extends StatelessWidget {
  final List<SensorData> data;

  const SensorLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Đang chờ dữ liệu..."));
    }

    return Column(
      children: [
        const Text(
          "Biểu đồ EC (Vàng) và PPT (Xanh)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Hiển thị giờ ở trục dưới
                        final index = value.toInt();
                        if (index >= 0 &&
                            index < data.length &&
                            index % 5 == 0) {
                          // % 5 để không hiển thị quá dày đặc
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data[index].formatedTime,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                lineBarsData: [
                  // Đường biểu diễn EC
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.ec);
                    }).toList(),
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.amber.withOpacity(0.1),
                    ),
                  ),
                  // Đường biểu diễn PPT
                  // LƯU Ý: Vì PPT thường rất nhỏ so với EC,
                  // đường này có thể nằm sát đáy.
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.ppt);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
