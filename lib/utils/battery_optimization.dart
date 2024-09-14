import 'package:app_settings/app_settings.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/foundation.dart';

class BatteryOptimization {
  static Future<bool> isOptimizationDisabled() async {
    try {
      final result =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      return result ?? true;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking battery optimization status: $e");
      }
      return false;
    }
  }

  static Future<void> openBatteryOptimizationSettings() async {
    try {
      await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    } catch (e) {
      if (kDebugMode) {
        print("Error opening battery optimization settings: $e");
      }
      // Fallback to app_settings if the above fails
      await AppSettings.openAppSettings(
          type: AppSettingsType.batteryOptimization);
    }
  }
}
