/// Month Year Picker Widget
/// Horizontal slider for month/year selection
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MonthYearPicker extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final void Function(int month, int year) onChanged;

  const MonthYearPicker({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChanged,
  });

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _goToPreviousMonth,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.textSecondary,
        ),
        InkWell(
          onTap: () => _showPicker(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_monthNames[selectedMonth - 1]} $selectedYear',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: _canGoToNextMonth() ? _goToNextMonth : null,
          icon: const Icon(Icons.chevron_right),
          color: _canGoToNextMonth()
              ? AppColors.textSecondary
              : AppColors.border,
        ),
      ],
    );
  }

  void _goToPreviousMonth() {
    if (selectedMonth == 1) {
      onChanged(12, selectedYear - 1);
    } else {
      onChanged(selectedMonth - 1, selectedYear);
    }
  }

  void _goToNextMonth() {
    if (selectedMonth == 12) {
      onChanged(1, selectedYear + 1);
    } else {
      onChanged(selectedMonth + 1, selectedYear);
    }
  }

  bool _canGoToNextMonth() {
    final now = DateTime.now();
    if (selectedYear < now.year) return true;
    if (selectedYear == now.year && selectedMonth < now.month) return true;
    return false;
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MonthYearPickerSheet(
        selectedMonth: selectedMonth,
        selectedYear: selectedYear,
        onChanged: (month, year) {
          onChanged(month, year);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _MonthYearPickerSheet extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;
  final void Function(int month, int year) onChanged;

  const _MonthYearPickerSheet({
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  State<_MonthYearPickerSheet> createState() => _MonthYearPickerSheetState();
}

class _MonthYearPickerSheetState extends State<_MonthYearPickerSheet> {
  late int _month;
  late int _year;

  static const List<String> _monthNames = [
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

  @override
  void initState() {
    super.initState();
    _month = widget.selectedMonth;
    _year = widget.selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Pilih Bulan & Tahun',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() => _year--),
                icon: const Icon(Icons.chevron_left),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_year',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _year < now.year
                    ? () => setState(() => _year++)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Month grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final isSelected = month == _month;
              final isDisabled = _year == now.year && month > now.month;

              return InkWell(
                onTap: isDisabled ? null : () => setState(() => _month = month),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isDisabled
                        ? AppColors.surfaceVariant
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _monthNames[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isDisabled
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onChanged(_month, _year),
              child: const Text('Pilih'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
