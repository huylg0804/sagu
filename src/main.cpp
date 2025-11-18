/*
 * ======================================================
 * PRO DUCT ESP32 (FULL CODE - FIXED BRACKET ERROR)
 * ======================================================
 * Fix: Đóng ngoặc hàm loop()
 * Update: Đã thêm Nhiệt độ vào Firebase
 */

// --- 1. THƯ VIỆN ---
#include <WiFi.h>
#include <FirebaseESP32.h> 
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <math.h> 

// --- 2. TỆP CẤU HÌNH ---
#include "config.h" 

// --- 3. KHỞI TẠO ---
FirebaseConfig config_firebase; 
FirebaseData fbdo;
FirebaseAuth auth; 
LiquidCrystal_I2C lcd(LCD_ADDRESS, 16, 2); 

// --- 4. BIẾN TOÀN CỤC ---
unsigned long lastSendMillis = 0; 

// --- 5. KHAI BÁO HÀM (PROTOTYPES) ---
void pushDataToFirebase(float temp, float ec_ms, float ph, float salinity_ppt);
float getPH();
float getEC();
float getTemp();

// =================================================================
//                   HÀM SETUP
// =================================================================
void setup() {
  Serial.begin(115200);
  Serial.println("--- ProDuct ESP32 Salinity Alert ---");

  Serial.println("Khoi tao Cam bien va LCD...");
  analogSetAttenuation(ADC_11db); 

  pinMode(25, OUTPUT); 
  pinMode(26, OUTPUT); 
  pinMode(PH_PIN, INPUT); 
  pinMode(EC_PIN, INPUT); 
  pinMode(NTC_PIN, INPUT);
  
  Wire.begin(SDA_PIN, SCL_PIN); 
  lcd.init(); 
  lcd.backlight();
  lcd.clear();
  lcd.print("Dang khoi tao...");

  Serial.println("Initializing WiFi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected.");
  lcd.setCursor(0, 1);
  lcd.print("WiFi OK");
  delay(1000);

  Serial.println("Initializing Firebase...");
  config_firebase.host = DATABASE_URL; 
  config_firebase.signer.tokens.legacy_token = FIREBASE_AUTH; 
  Firebase.begin(&config_firebase, &auth); 
  Firebase.reconnectWiFi(true); 
  Firebase.setReadTimeout(fbdo, 1000 * 60);
  Firebase.setwriteSizeLimit(fbdo, "tiny");

  lcd.clear();
}

// =================================================================
//                   HÀM LOOP CHÍNH
// =================================================================
void loop() {
  // 1. Đọc cảm biến
  float var_temp = getTemp(); 
  float var_ph = getPH();
  float var_EC_ohm = getEC(); 

  // 2. Tính toán
  float var_ppt = 0; 
  float ec_25_us = 0; 

  if (var_EC_ohm > 0 && var_temp > -100) {
    float ec_raw_us = (1000000.0 / var_EC_ohm) * EC_CELL_CONSTANT;
    ec_25_us = ec_raw_us / (1.0 + EC_TEMP_COEFF * (var_temp - 25.0));
    float tds_ppm = ec_25_us * TDS_K_VALUE;
    var_ppt = tds_ppm / 1000.0;
  }

  // 3. Hiển thị LCD
  lcd.clear(); 
  lcd.setCursor(0, 0); 
  lcd.print("T:"); lcd.print(var_temp, 1);
  lcd.print(" pH:"); lcd.print(var_ph, 2);

  lcd.setCursor(0, 1); 
  if (ec_25_us > SALINITY_THRESHOLD_EC) { 
    lcd.print("!!CANH BAO MAN!!");
  } else {
    lcd.print("EC:"); lcd.print(ec_25_us, 0); lcd.print(" uS");
  }

  // 4. Gửi Firebase
  if (Firebase.ready() && (millis() - lastSendMillis > SEND_INTERVAL)) { 
    lastSendMillis = millis(); 
    float ec_ms = ec_25_us / 1000.0;
    pushDataToFirebase(var_temp, ec_ms, var_ph, var_ppt);
  }

  delay(2000); 
} // <--- ĐÂY LÀ DẤU NGOẶC BẠN BỊ THIẾU TRƯỚC ĐÓ

// =================================================================
//                   HÀM PUSH FIREBASE
// =================================================================
void pushDataToFirebase(float temp, float ec_ms, float ph, float salinity_ppt) {
  Serial.printf("Pushing: T=%.1f, EC=%.2f, pH=%.2f, PPT=%.3f\n", temp, ec_ms, ph, salinity_ppt);

  FirebaseJson jsonPayload;
  jsonPayload.set("temperature", String(temp, 1)); 
  jsonPayload.set("ec_ms_cm", String(ec_ms, 2));
  jsonPayload.set("ph_value", String(ph, 2));
  jsonPayload.set("salinity_ppt", String(salinity_ppt, 3));
  jsonPayload.set("timestamp/.sv", "timestamp"); 

  String path = "/sensor_logs";

  if (Firebase.pushJSON(fbdo, path, jsonPayload)) {
    Serial.println("SUCCESS: Data pushed.");
  } else {
    Serial.println("FAILED: " + fbdo.errorReason());
  }
}

// =================================================================
//                   CÁC HÀM CẢM BIẾN
// =================================================================
float getPH() {
  float Value = analogRead(PH_PIN); 
  float voltage = Value * (VIN / 4095.0); 
  float voltage_at_7 = 1.650; // Sửa lại theo hiệu chuẩn của bạn nếu cần
  float slope = 5.55;         // Sửa lại theo hiệu chuẩn của bạn nếu cần
  float ph = 7.0 + slope * (voltage - voltage_at_7);
  if (ph < 0.0) ph = 0.0;
  if (ph > 14.0) ph = 14.0;
  return ph;
}

float getEC() {
  float tot = 0;
  int valid_samples = 0;
  int raw = 0;
  float Vout = 0;
  float buff = 0;
  float R2 = 0;
  
  for (int i = 0; i < EC_SAMPLES; i++) { 
    digitalWrite(26, HIGH); digitalWrite(25, LOW);
    delayMicroseconds(EC_DTIME); 
    digitalWrite(26, LOW); digitalWrite(25, HIGH);
    delayMicroseconds(EC_DTIME); 
    raw = analogRead(EC_PIN); 

    if (raw > 0 && raw < 4095) {
      Vout = (raw * VIN) / 4095.0; 
      buff = (VIN / Vout) - 1.0;
      if (buff > 0) { 
        R2 = EC_R1 * buff; 
        tot = tot + R2;
        valid_samples++;
      }
    }
  }
  if (valid_samples > 0) return tot / valid_samples;
  return 0;
}

float getTemp() {
  int adc_value = analogRead(NTC_PIN); 
  if (adc_value <= 0 || adc_value >= 4095) return -273.15;

  float voltage2 = adc_value * (VIN / 4095.0); 
  float resistance = (voltage2 * SERIES_RESISTOR) / (VIN - voltage2);

  if (resistance <= 0) return -273.15;

  float steinhart;
  steinhart = resistance / NOMINAL_RESISTANCE; 
  steinhart = log(steinhart); 
  steinhart /= B_COEFFICIENT; 
  steinhart += 1.0 / (NOMINAL_TEMPERATURE + 273.15); 
  steinhart = 1.0 / steinhart; 
  steinhart -= 273.15; 
  return steinhart;
}