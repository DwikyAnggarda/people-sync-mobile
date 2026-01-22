/// Attendance List Item Widget
/// Individual attendance record item for the history list
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../data/models/attendance_model.dart';

class AttendanceListItem extends StatelessWidget {
  final AttendanceModel attendance;

  const AttendanceListItem({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusLabel = _getStatusLabel();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Date
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDay(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    _getMonthShort(),
                    style: TextStyle(fontSize: 11, color: statusColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Times
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getWeekday(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.login,
                        size: 14,
                        color: attendance.clockInAt != null
                            ? AppColors.success
                            : AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attendance.clockInTimeFormatted ?? '--:--',
                        style: TextStyle(
                          color: attendance.clockInAt != null
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.logout,
                        size: 14,
                        color: attendance.clockOutAt != null
                            ? AppColors.secondary
                            : AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        attendance.clockOutTimeFormatted ?? '--:--',
                        style: TextStyle(
                          color: attendance.clockOutAt != null
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status badge
            StatusBadge(label: statusLabel, backgroundColor: statusColor),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (attendance.clockInAt == null) {
      return AppColors.absent;
    }
    if (attendance.isLate) {
      return AppColors.warning;
    }
    return AppColors.success;
  }

  String _getStatusLabel() {
    if (attendance.clockInAt == null) {
      return 'Tidak Hadir';
    }
    if (attendance.isLate) {
      return 'Terlambat';
    }
    return 'Tepat Waktu';
  }

  String _getDay() {
    try {
      final date = DateTime.parse(attendance.date);
      return date.day.toString().padLeft(2, '0');
    } catch (e) {
      return '--';
    }
  }

  String _getMonthShort() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    try {
      final date = DateTime.parse(attendance.date);
      return months[date.month - 1];
    } catch (e) {
      return '--';
    }
  }

  String _getWeekday() {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    try {
      final date = DateTime.parse(attendance.date);
      return weekdays[date.weekday - 1];
    } catch (e) {
      return '--';
    }
  }
}
