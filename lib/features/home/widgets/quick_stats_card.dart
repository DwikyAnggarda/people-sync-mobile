/// Quick Stats Card Widget
/// Shows monthly attendance summary
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../attendance/data/models/attendance_model.dart';
import '../../attendance/data/repositories/attendance_repository.dart';

/// Quick stats provider
final quickStatsProvider = FutureProvider<AttendanceSummaryModel?>((ref) async {
  try {
    final repository = ref.watch(attendanceRepositoryProvider);
    return await repository.getAttendanceSummary();
  } catch (e) {
    return null;
  }
});

class QuickStatsCard extends ConsumerWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(quickStatsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Bulan Ini',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => const Center(
                child: Text(
                  'Gagal memuat statistik',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              data: (summary) {
                if (summary == null) {
                  return const Center(
                    child: Text(
                      'Tidak ada data',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return Row(
                  children: [
                    _StatItem(
                      icon: Icons.check_circle,
                      color: AppColors.success,
                      value: summary.totalPresent.toString(),
                      label: 'Hadir',
                    ),
                    _StatItem(
                      icon: Icons.schedule,
                      color: AppColors.error,
                      value: summary.totalLate.toString(),
                      label: 'Terlambat',
                    ),
                    _StatItem(
                      icon: Icons.event_busy,
                      color: AppColors.warning,
                      value: summary.totalLeave.toString(),
                      label: 'Cuti',
                    ),
                    _StatItem(
                      icon: Icons.cancel,
                      color: AppColors.textLight,
                      value: summary.totalAbsent.toString(),
                      label: 'Tidak Hadir',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
