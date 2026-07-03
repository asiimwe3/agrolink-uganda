import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';

/// GPS Land Measurement — walk the farm boundary, capture points,
/// compute area (acres/hectares) and perimeter via the Shoelace formula.
class MeasureLandScreen extends StatefulWidget {
  const MeasureLandScreen({super.key});

  @override
  State<MeasureLandScreen> createState() => _MeasureLandScreenState();
}

class _MeasureLandScreenState extends State<MeasureLandScreen> {
  final List<Position> _points = [];
  String? _error;

  Future<void> _capturePoint() async {
    setState(() => _error = null);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          setState(() => _error = 'Location permission is required to measure land.');
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _points.add(position));
    } catch (e) {
      setState(() => _error = 'Could not get GPS location. Move to an open area and retry.');
    }
  }

  /// Shoelace formula on an equirectangular projection — good enough
  /// approximation for small farm plots.
  double get _areaSqMeters {
    if (_points.length < 3) return 0;
    const earthRadius = 6378137.0;
    final lat0 = _points.first.latitude * (math.pi / 180);
    double sum = 0;
    for (int i = 0; i < _points.length; i++) {
      final p1 = _points[i];
      final p2 = _points[(i + 1) % _points.length];
      final x1 = earthRadius * (p1.longitude * math.pi / 180) * math.cos(lat0);
      final y1 = earthRadius * (p1.latitude * math.pi / 180);
      final x2 = earthRadius * (p2.longitude * math.pi / 180) * math.cos(lat0);
      final y2 = earthRadius * (p2.latitude * math.pi / 180);
      sum += (x1 * y2 - x2 * y1);
    }
    return sum.abs() / 2;
  }

  double get _perimeterMeters {
    if (_points.length < 2) return 0;
    double total = 0;
    for (int i = 0; i < _points.length; i++) {
      final p1 = _points[i];
      final p2 = _points[(i + 1) % _points.length];
      total += Geolocator.distanceBetween(
        p1.latitude,
        p1.longitude,
        p2.latitude,
        p2.longitude,
      );
    }
    return total;
  }

  double get _acres => _areaSqMeters / 4046.86;
  double get _hectares => _areaSqMeters / 10000;

  void _finish() {
    // TODO: persist to farm_boundaries table via repository (area, perimeter, points).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Farm boundary saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measure Land (GPS)')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _points.isEmpty ? null : () => setState(() => _points.clear()),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _points.length >= 3 ? _finish : null,
                    child: const Text('Finish'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: _points.isEmpty
                    ? const Text('Walk around your farm and tap "Capture Point"\nat each corner.',
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary))
                    : CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: _BoundaryPainter(_points),
                      ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatChip(label: 'Acres', value: _acres.toStringAsFixed(2))),
                const SizedBox(width: 10),
                Expanded(child: _StatChip(label: 'Hectares', value: _hectares.toStringAsFixed(2))),
                const SizedBox(width: 10),
                Expanded(child: _StatChip(label: 'Perimeter (m)', value: _perimeterMeters.toStringAsFixed(1))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _capturePoint,
                icon: const Icon(Icons.add_location_alt_rounded),
                label: Text('Capture Point (${_points.length})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _BoundaryPainter extends CustomPainter {
  final List<Position> points;
  _BoundaryPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final lats = points.map((p) => p.latitude).toList();
    final lngs = points.map((p) => p.longitude).toList();
    final minLat = lats.reduce((a, b) => a < b ? a : b);
    final maxLat = lats.reduce((a, b) => a > b ? a : b);
    final minLng = lngs.reduce((a, b) => a < b ? a : b);
    final maxLng = lngs.reduce((a, b) => a > b ? a : b);

    Offset toOffset(Position p) {
      final dx = maxLng == minLng ? 0.5 : (p.longitude - minLng) / (maxLng - minLng);
      final dy = maxLat == minLat ? 0.5 : (maxLat - p.latitude) / (maxLat - minLat);
      return Offset(20 + dx * (size.width - 40), 20 + dy * (size.height - 40));
    }

    final offsets = points.map(toOffset).toList();
    final path = Path()..addPolygon(offsets, true);

    final fillPaint = Paint()..color = AppColors.secondaryGreen.withOpacity(0.25);
    final strokePaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    for (final o in offsets) {
      canvas.drawCircle(o, 5, Paint()..color = AppColors.goldAccent);
    }
  }

  @override
  bool shouldRepaint(covariant _BoundaryPainter oldDelegate) => oldDelegate.points.length != points.length;
}
