/// Attendance Card Widget
/// Shows today's attendance status with clock button
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../attendance/data/models/attendance_today_model.dart';
import '../../attendance/providers/attendance_provider.dart';
import 'clock_modal.dart';

class AttendanceCard extends ConsumerWidget {
  final AttendanceTodayModel attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canClockIn = attendance.canClockIn;
    final canClockOut = attendance.canClockOut;
    final hasClockedIn = attendance.hasClockedIn;
    final hasClockedOut = attendance.hasClockedOut;

    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (!hasClockedIn) {
      statusColor = AppColors.warning;
      statusIcon = Icons.access_time;
      statusText = 'Belum Clock In';
    } else if (!hasClockedOut) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Sudah Clock In';
    } else {
      statusColor = AppColors.primary;
      statusIcon = Icons.done_all;
      statusText = 'Sudah Clock Out';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Clock times row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TimeDisplay(
                  label: 'Clock In',
                  time: _formatTime(attendance.clockInAt),
                  isLate: attendance.isLate ?? false,
                  lateInfo: attendance.lateDurationFormatted,
                ),
                Container(width: 1, height: 50, color: AppColors.divider),
                _TimeDisplay(
                  label: 'Clock Out',
                  time: _formatTime(attendance.clockOutAt),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Clock Button
            if (canClockIn || canClockOut)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showClockModal(context, canClockIn),
                  icon: Icon(canClockIn ? Icons.login : Icons.logout),
                  label: Text(canClockIn ? 'Clock In' : 'Clock Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canClockIn
                        ? AppColors.success
                        : AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              )
            else if (!attendance.isWorkingDay! || attendance.isHoliday!)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, color: AppColors.info),
                    SizedBox(width: 8),
                    Text('Hari Libur', style: TextStyle(color: AppColors.info)),
                  ],
                ),
              ),

            // Work schedule info
            if (attendance.workSchedule != null) ...[
              const SizedBox(height: 16),
              Text(
                'Jam Kerja: ${attendance.workSchedule!.workStartTime} - ${attendance.workSchedule!.workEndTime}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return '--:--';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  void _showClockModal(BuildContext context, bool isClockIn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClockModal(isClockIn: isClockIn),
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final String label;
  final String time;
  final bool isLate;
  final String? lateInfo;

  const _TimeDisplay({
    required this.label,
    required this.time,
    this.isLate = false,
    this.lateInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isLate ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        if (isLate && lateInfo != null) ...[
          const SizedBox(height: 2),
          Text(
            'Terlambat $lateInfo',
            style: const TextStyle(color: AppColors.error, fontSize: 11),
          ),
        ],
      ],
    );
  }
}
