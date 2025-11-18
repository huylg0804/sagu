// --- File: config.h ---
#pragma once

// === 1. Cấu hình WiFi ===

#define WIFI_SSID "TRUONG VNPT"
#define WIFI_PASSWORD "11335577"

// --- 2. Cấu hình Firebase ---
#define API_KEY "AIzaSyBGE339gEbD1SrpfG1yxmccl6GlAJ8zTlM"
#define DATABASE_URL "https://salin-c9bcf-default-rtdb.firebaseio.com/" 
#define FIREBASE_AUTH "TyIF9W7PUWU5E6BOzmOcubh0JqkBRkUe597GTaL9"


// === 3. Cấu hình Chân (GPIO) ===
#define SDA_PIN 27              // Chân I2C SDA (cho LCD)
#define SCL_PIN 14             // Chân I2C SCL (cho LCD)
#define PH_PIN 34               // (ADC1) Chân Analog cho cảm biến pH
#define EC_PIN 35               // (ADC1) Chân Analog cho cảm biến EC
#define NTC_PIN 33              // (ADC1) Chân Analog cho cảm biến Nhiệt độ NTC
// (Các chân 25, 26 đã được dùng trực tiếp trong code getEC)

// === 4. Cấu hình Màn hình LCD ===
#define LCD_ADDRESS 0x27        // Địa chỉ I2C của LCD (hoặc 0x3F)

// === 5. Cấu hình Hệ thống & Logic ===
#define VIN 3.3                 // Điện áp tham chiếu của ADC ESP32
#define PUSH_INTERVAL 30000     // Gửi data lên Firebase mỗi 30 giây (30000 ms)
#define SALINITY_THRESHOLD_EC 3000 // Ngưỡng cảnh báo (ví dụ: 5000 µS/cm)

// === 6. HẰNG SỐ HIỆU CHUẨN (CRITICAL CALIBRATION) ===

// --- 6.1. Hiệu chuẩn Cảm biến Nhiệt độ (NTC) ---
#define SERIES_RESISTOR 10000       // (Ohm) Điện trở nối tiếp với NTC (ví dụ 10k)
#define NOMINAL_RESISTANCE 10000    // (Ohm) Điện trở của NTC tại nhiệt độ danh định (ví dụ 10k @ 25°C)
#define NOMINAL_TEMPERATURE 20      // (°C) Nhiệt độ danh định
#define B_COEFFICIENT 3950          // Hệ số Beta của NTC (xem datasheet)

// --- 6.2. Hiệu chuẩn Cảm biến pH (Tuyến tính) ---
// (Cần được tìm ra bằng thực nghiệm với dung dịch đệm 4.0 và 7.0)
// ph = 7.0 + slope * (voltage - voltage_at_7)
#define PH_VOLTAGE_AT_7   1.650     // (Volt) Điện áp đo được trong dung dịch pH 7.0
#define PH_SLOPE          -5.55     // (pH/Volt) Độ dốc (thường là âm)

// --- 6.3. Hiệu chuẩn Cảm biến EC (Quan trọng nhất) ---
#define EC_R1 1000.0                // (Ohm) Giá trị điện trở cầu chia áp (R1)
#define EC_SAMPLES 100              // Số lần lấy mẫu đo EC
#define EC_DTIME 100                // (microseconds) Thời gian chờ đảo cực

// (Hằng số K của đầu dò, xem trên thân đầu dò hoặc datasheet)
#define EC_CELL_CONSTANT 0.9125        // (K=1.0 cho nước thông thường, K=0.1 cho nước tinh khiết)

// (Hệ số bù trừ nhiệt độ, thường là 2.0% mỗi độ C)
#define EC_TEMP_COEFF 0.020         // (0.019 -> 0.021)

// (Hệ số chuyển đổi từ EC (µS/cm) sang TDS (ppm))
#define TDS_K_VALUE 0.5             // (0.5 cho NaCl, 0.64 cho "442",...)

#define SEND_INTERVAL 30000
