import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class _DayForecast {
  final String day;
  final int high;
  final int low;
  final IconData icon;
  final int rainChance;
  const _DayForecast(this.day, this.high, this.low, this.icon, this.rainChance);
}

/// Mock 7-day forecast — swap with a real weather repository (OpenWeather/NASA POWER)
/// wired through Riverpod, matching the pattern used across other modules.
const _forecast = [
  _DayForecast('Mon', 26, 18, Icons.wb_sunny_rounded, 10),
  _DayForecast('Tue', 24, 17, Icons.wb_cloudy_rounded, 30),
  _DayForecast('Wed', 22, 16, Icons.grain_rounded, 70),
  _DayForecast('Thu', 23, 17, Icons.grain_rounded, 60),
  _DayForecast('Fri', 25, 18, Icons.wb_sunny_rounded, 15),
  _DayForecast('Sat', 26, 18, Icons.wb_sunny_rounded, 5),
  _DayForecast('Sun', 24, 17, Icons.wb_cloudy_rounded, 25),
];

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Text('Kyenjojo District', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text('24°C', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w700)),
                Text('Light Rain', style: TextStyle(color: Colors.white, fontSize: 15)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _WeatherStat(label: 'Humidity', value: '78%'),
                    _WeatherStat(label: 'Wind', value: '12 km/h'),
                    _WeatherStat(label: 'Rain', value: '65%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('7-Day Forecast', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._forecast.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 40, child: Text(f.day, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Icon(f.icon, color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('${f.rainChance}% rain', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ),
                      Text('${f.high}° / ${f.low}°', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.goldAccent),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Best planting day: Saturday · Best spraying day: Monday',
                    style: TextStyle(fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final String label;
  final String value;
  const _WeatherStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
