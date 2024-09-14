import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/utils/battery_optimization.dart';
import 'package:iaso/utils/toast.dart';

class BatteryOptimizationScreen extends StatefulWidget {
  const BatteryOptimizationScreen({super.key});

  @override
  State<BatteryOptimizationScreen> createState() =>
      _BatteryOptimizationScreenState();
}

class _BatteryOptimizationScreenState extends State<BatteryOptimizationScreen>
    with WidgetsBindingObserver {
  bool _isOptimizationDisabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBatteryOptimizationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBatteryOptimizationStatus();
    }
  }

  Future<void> _checkBatteryOptimizationStatus() async {
    setState(() {
      _isLoading = true;
    });
    bool status = await BatteryOptimization.isOptimizationDisabled();
    setState(() {
      _isOptimizationDisabled = status;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: edgeInset),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isOptimizationDisabled ? Icons.battery_full : Icons.battery_alert,
            size: 80,
            color: _isOptimizationDisabled ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.battery_optimization_title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            _isOptimizationDisabled
                ? l10n.battery_optimization_disabled
                : l10n.battery_optimization_description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _handleBatteryOptimization,
                  child: Text(_isOptimizationDisabled
                      ? l10n.optimization_disabled
                      : l10n.disable_optimization),
                ),
        ],
      ),
    );
  }

  Future<void> _handleBatteryOptimization() async {
    final l10n = AppLocalizations.of(context)!;

    if (_isOptimizationDisabled) {
      ToastUtil.success(context, l10n.optimization_disabled);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await BatteryOptimization.openBatteryOptimizationSettings();

    // We don't need to call _checkBatteryOptimizationStatus() here
    // as it will be called when the app resumes

    setState(() {
      _isLoading = false;
    });
  }
}
