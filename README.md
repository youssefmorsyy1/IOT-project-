# Smart Air Quality Monitoring System

*(Group Project)*

An IoT air-quality monitoring system pairing an ESP32-based sensor node with a Flutter mobile app for live monitoring. The device reads temperature, humidity, and gas/air-quality data and publishes it over MQTT; the app subscribes to the broker and displays live readings to the user.

## Architecture

```
┌─────────────┐      ┌───────────┐      ┌────────────────┐
│  Sensors     │      │           │      │                │
│  DHT11/DHT22 │ ───▶ │  ESP32    │ ───▶ │  MQTT Broker   │ ───▶  Flutter App
│  Gas sensor  │      │  (firmware)│      │                │      (subscriber, live UI)
└─────────────┘      └───────────┘      └────────────────┘
```

- **Sensor layer.** A DHT11/DHT22 sensor reads temperature and humidity; a separate gas sensor reads air-quality/gas concentration.
- **Firmware (ESP32, PlatformIO).** Polls both sensors, packages the readings, and publishes them to an MQTT broker over WiFi.
- **Communication.** MQTT is used as the messaging layer between the device and the app, decoupling the sensor node from the client so multiple subscribers could listen to the same data stream.
- **Mobile app (Flutter).** Subscribes to the relevant MQTT topic(s) and renders incoming readings for the user in real time.

## My Contribution

Built the embedded firmware: sensor integration (DHT11/DHT22 + gas sensor) on the ESP32 and publishing readings to the MQTT broker, using PlatformIO as the development environment. The Flutter mobile app was built by a teammate.

## Tech Stack

ESP32, PlatformIO, DHT11/DHT22, gas sensor, MQTT, Flutter/Dart

## Repository Contents

- `Platform IO/` — ESP32 firmware project (PlatformIO): sensor reading and MQTT publishing logic
- `flutter/` — Flutter mobile app: MQTT subscriber and live monitoring UI
- `Smart Air Quality Monitoring System.pptx` — project presentation
- `Final Project Task Sheet.csv` — task/role tracking sheet

## Possible Extensions

- Add data logging/persistence (e.g. a time-series database) so historical trends can be reviewed, not just live readings.
- Add threshold-based alerts (push notification when air quality crosses a defined limit).
- Support multiple sensor nodes reporting to the same broker for multi-room monitoring.
