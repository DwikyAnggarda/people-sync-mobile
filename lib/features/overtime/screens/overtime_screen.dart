/// Overtime Screen
/// Tab view with overtime history and new request form
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/overtime_provider.dart';
import '../widgets/overtime_form.dart';
import '../widgets/overtime_list_item.dart';

class OvertimeScreen extends ConsumerStatefulWidget {
  const OvertimeScreen({super.key});

  @override
  ConsumerState<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends ConsumerState<OvertimeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(overtimeListProvider.notifier).fetchOvertimes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await ref.read(overtimeListProvider.notifier).fetchOvertimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lembur'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Riwayat'),
            Tab(text: 'Ajukan Lembur'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // History Tab
          _OvertimeHistoryTab(onRefresh: _refreshData),
          // Form Tab
          OvertimeForm(
            onSuccess: () {
              _tabController.animateTo(0);
              _refreshData();
            },
          ),
        ],
      ),
    );
  }
}

class _OvertimeHistoryTab extends ConsumerWidget {
  final VoidCallback onRefresh;

  const _OvertimeHistoryTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overtimeListProvider);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: state.isLoading
          ? const LoadingWidget(message: 'Memuat riwayat lembur...')
          : state.errorMessage != null
          ? ErrorDisplayWidget(message: state.errorMessage!, onRetry: onRefresh)
          : state.overtimes.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 100),
                EmptyWidget(
                  message: 'Belum ada pengajuan lembur',
                  icon: Icons.schedule,
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.overtimes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final overtime = state.overtimes[index];
                return OvertimeListItem(
                  overtime: overtime,
                  onCancel: overtime.canCancel
                      ? () => _showCancelDialog(context, ref, overtime.id)
                      : null,
                );
              },
            ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, int overtimeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pengajuan?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pengajuan lembur ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(overtimeListProvider.notifier)
                  .cancelOvertime(overtimeId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Pengajuan lembur dibatalkan'
                          : 'Gagal membatalkan pengajuan',
                    ),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );
  }
}
