/// Leave Screen
/// Tab view with leave history and new request form
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/leave_provider.dart';
import '../widgets/leave_form.dart';
import '../widgets/leave_list_item.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveListProvider.notifier).fetchLeaves();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await ref.read(leaveListProvider.notifier).fetchLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cuti'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Riwayat'),
            Tab(text: 'Ajukan Cuti'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // History Tab
          _LeaveHistoryTab(onRefresh: _refreshData),
          // Form Tab
          LeaveForm(
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

class _LeaveHistoryTab extends ConsumerWidget {
  final VoidCallback onRefresh;

  const _LeaveHistoryTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaveListProvider);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: state.isLoading
          ? const LoadingWidget(message: 'Memuat riwayat cuti...')
          : state.errorMessage != null
          ? ErrorDisplayWidget(message: state.errorMessage!, onRetry: onRefresh)
          : state.leaves.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 100),
                EmptyWidget(
                  message: 'Belum ada pengajuan cuti',
                  icon: Icons.event_busy,
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.leaves.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final leave = state.leaves[index];
                return LeaveListItem(
                  leave: leave,
                  onCancel: leave.canCancel
                      ? () => _showCancelDialog(context, ref, leave.id)
                      : null,
                );
              },
            ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, int leaveId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pengajuan?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pengajuan cuti ini?',
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
                  .read(leaveListProvider.notifier)
                  .cancelLeave(leaveId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Pengajuan cuti dibatalkan'
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
