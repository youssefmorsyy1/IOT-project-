#include <Arduino.h>
#include <DHT.h>
#include <Keypad.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>

static const char *root_ca PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";

// Pin definitions
const int FAN_PIN = 13;
const int PM_LED_PIN = 27;
const int PM_READING_PIN = 35;
const int DHT_PIN = 14;
const int MQ135_PIN = 34;

#define DHTTYPE DHT22
DHT dht(DHT_PIN, DHTTYPE);

// Keypad setup
const byte ROWS = 4;
const byte COLS = 4;
byte rowPins[ROWS] = {32, 33, 25, 26};
byte colPins[COLS] = {5, 18, 19, 23};

char keys[ROWS][COLS] = {
    {'1', '2', '3', 'A'},
    {'4', '5', '6', 'B'},
    {'7', '8', '9', 'C'},
    {'*', '0', '#', 'D'}
};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// I2C LCD setup
LiquidCrystal_I2C lcd(0x27, 16, 2); // Address 0x27, 16 columns, 2 rows

// WiFi and MQTT credentials
const char* ssid = "Allam A51";        // Replace with your WiFi SSID
const char* password = "11223344";  // Replace with your WiFi password
const char* mqtt_username = "Ahmed@11";  // Replace with your MQTT username
const char* mqtt_password = "Ahmed@11";  // Replace with your MQTT password
const char* mqtt_server = "573c3880651840c8a35aead5dc4a9e76.s1.eu.hivemq.cloud"; // MQTT Broker (HiveMQ)
const int mqtt_port = 8883;

// MQTT Topics
const char* temperatureTopic = "home/airquality/temperature";
const char* humidityTopic = "home/airquality/humidity";
const char* gasLevelTopic = "home/airquality/gas";
const char* PMLevelTopic = "home/airquality/PM";
const char* fanControlTopic = "home/airquality/fancontrol";

WiFiClientSecure espClient;
PubSubClient client(espClient);

// Thresholds for sensors
int gasThreshold = 512;
int pmThreshold = 1024;
float tempThreshold = 32.0;
float humidityThreshold = 70.0;

bool lcdOn = true;  // Start with LCD on
bool autoMode = true;  // Start in auto mode

// Function to connect to WiFi
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);  // Start WiFi connection

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
}

// Function to connect/reconnect to the MQTT broker
void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP32Client", mqtt_username, mqtt_password)) {
      Serial.println("connected");
      client.subscribe(fanControlTopic);  // Subscribe to fan control topic
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

// Function to publish sensor data to MQTT topics
void publishSensorData(float temperature, float humidity, int gasLevel, int PMLevel) {
  client.publish(temperatureTopic, String(temperature).c_str());
  client.publish(humidityTopic, String(humidity).c_str());
  client.publish(gasLevelTopic, String(gasLevel).c_str());
  client.publish(PMLevelTopic, String(PMLevel).c_str());
  Serial.println("Sensor data published to MQTT");
}

// Function to handle incoming MQTT messages
void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");

  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.println(message);

  // If the message is for fan control, handle it
  if (String(topic) == fanControlTopic) {
    if (message == "ON") {
      digitalWrite(FAN_PIN, HIGH);  // Turn on the fan
      lcd.setCursor(0, 1);
      lcd.print("Fan: ON ");
      Serial.println("Fan turned ON via MQTT");
    } else if (message == "OFF") {
      digitalWrite(FAN_PIN, LOW);  // Turn off the fan
      lcd.setCursor(0, 1);
      lcd.print("Fan: OFF");
      Serial.println("Fan turned OFF via MQTT");
    }
  }
}

// Function to read the PM sensor
int readPMSensor() {
  digitalWrite(PM_LED_PIN, HIGH);
  delayMicroseconds(280);
  int PMValue = analogRead(PM_READING_PIN);
  digitalWrite(PM_LED_PIN, LOW);
  delayMicroseconds(40);
  return PMValue;
}

// Function to control the fan based on sensor readings
void controlFan(int gasValue, int PMValue, float temperature, float humidity) {
  if (gasValue > gasThreshold || PMValue > pmThreshold ||
      temperature > tempThreshold || humidity > humidityThreshold) {
    digitalWrite(FAN_PIN, HIGH);
  } else {
    digitalWrite(FAN_PIN, LOW);
  }
}

void setup() {
  Serial.begin(9600);

  setup_wifi();  // Connect to WiFi
  espClient.setCACert(root_ca);
  client.setServer(mqtt_server, mqtt_port);  // Set the MQTT broker address
  client.setCallback(callback);  // Set the MQTT callback function
  dht.begin();
  lcd.init();
  lcd.backlight();

  pinMode(FAN_PIN, OUTPUT);
  pinMode(PM_LED_PIN, OUTPUT);
  pinMode(MQ135_PIN, INPUT);
  pinMode(PM_READING_PIN, INPUT);

  digitalWrite(FAN_PIN, LOW);
  digitalWrite(PM_LED_PIN, LOW);

  lcd.setCursor(0, 0);
  lcd.print("Booting up...");
}

void loop() {
  // Reconnect to MQTT if necessary
  if (!client.connected()) {
    reconnect();
  }
  client.loop();  // Handle incoming MQTT messages

  // Always check for keypad input
  char key = keypad.getKey();

  if (key) { // When a key is pressed
    Serial.print("Key Pressed: ");
    Serial.println(key); // Show key press on Serial

    // Control the LCD and fan based on keypad input
    if (key == 'A') {
      autoMode = true;  // Switch to auto mode
      lcd.setCursor(0, 1);
      lcd.print("Mode: Auto    ");
    } else if (key == 'B') {
      autoMode = false;  // Disable auto mode
      digitalWrite(FAN_PIN, HIGH); // Turn on fan
      lcd.setCursor(0, 1);
      lcd.print("Mode: ON      ");
      Serial.println("Fan turned ON");
    }
    else if (key == 'C') {
      autoMode = false; // Turn off fan
      digitalWrite(FAN_PIN, LOW);
      lcd.setCursor(0, 1);
      lcd.print("Mode: OFF     ");
      Serial.println("Fan turned OFF");
    } else if (key == 'D') {
      lcdOn = !lcdOn; // Toggle LCD on/off
      if (lcdOn) {
        lcd.backlight();
        lcd.setCursor(0, 1);
        lcd.print("LCD ON        ");
        Serial.println("LCD turned ON");
      } else {
        lcd.noBacklight();
        lcd.setCursor(0, 1);
        lcd.print("LCD OFF       ");
        Serial.println("LCD turned OFF");
      }
    }
  }

  // Read sensor data every second
  static unsigned long lastSensorUpdate = 0;
  const unsigned long sensorUpdateInterval = 1000;  // Sensor read interval

  if (millis() - lastSensorUpdate >= sensorUpdateInterval) {
    lastSensorUpdate = millis();  // Update the timestamp for the last sensor read

    // Read sensor data
    int gasLevel = analogRead(MQ135_PIN);
    int PMLevel = readPMSensor();
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    Serial.print("\nTemperature: ");
    Serial.println(temperature);
    Serial.print("Humidity: ");
    Serial.println(humidity);
    Serial.print("PM: ");
    Serial.println(PMLevel);
    Serial.print("Gas: ");
    Serial.println(gasLevel);

    // Publish sensor data to MQTT
    publishSensorData(temperature, humidity, gasLevel, PMLevel);

    // Display sensor data and current mode
    if (lcdOn) {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("T:");
      lcd.print(temperature);
      lcd.print(" H:");
      lcd.print(humidity);
      lcd.setCursor(0, 1);
      lcd.print("PM:");
      lcd.print(PMLevel);
      lcd.print(" Gas:");
      lcd.print(gasLevel);
    }

    // Control the fan in auto mode based on sensor values
    if (autoMode) {
      controlFan(gasLevel, PMLevel, temperature, humidity);
    }
  }
}