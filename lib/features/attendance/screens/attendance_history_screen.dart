/// Attendance History Screen
/// Monthly attendance records with summary
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/attendance_provider.dart';
import '../widgets/attendance_list_item.dart';
import '../widgets/month_year_picker.dart';

class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState
    extends ConsumerState<AttendanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(attendanceHistoryProvider.notifier).fetchHistory();
    });
  }

  Future<void> _refreshData() async {
    await ref.read(attendanceHistoryProvider.notifier).fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Month Year Picker
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: MonthYearPicker(
                selectedMonth: state.selectedMonth,
                selectedYear: state.selectedYear,
                onChanged: (month, year) {
                  ref
                      .read(attendanceHistoryProvider.notifier)
                      .changeMonth(month, year);
                },
              ),
            ),

            // Summary Card
            if (state.summary != null)
              Container(
                padding: const EdgeInsets.all(16),
                child: _SummaryCard(summary: state.summary!),
              ),

            // List
            Expanded(
              child: state.isLoading
                  ? const LoadingWidget(message: 'Memuat riwayat...')
                  : state.errorMessage != null
                  ? ErrorDisplayWidget(
                      message: state.errorMessage!,
                      onRetry: _refreshData,
                    )
                  : state.attendances.isEmpty
                  ? const EmptyWidget(
                      message: 'Tidak ada data kehadiran',
                      icon: Icons.event_busy,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: state.attendances.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final attendance = state.attendances[index];
                        return AttendanceListItem(attendance: attendance);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(
              label: 'Hadir',
              value: '${summary.totalPresent}',
              color: AppColors.success,
            ),
            _SummaryItem(
              label: 'Terlambat',
              value: '${summary.totalLate}',
              color: AppColors.warning,
            ),
            _SummaryItem(
              label: 'Tidak Hadir',
              value: '${summary.totalAbsent}',
              color: AppColors.error,
            ),
            _SummaryItem(
              label: 'Cuti',
              value: '${summary.totalLeave}',
              color: AppColors.info,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
