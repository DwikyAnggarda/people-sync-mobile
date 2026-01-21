/// Clock Modal Widget
/// Bottom sheet for clock in/out with location check
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../../attendance/providers/attendance_provider.dart';

class ClockModal extends ConsumerStatefulWidget {
  final bool isClockIn;

  const ClockModal({super.key, required this.isClockIn});

  @override
  ConsumerState<ClockModal> createState() => _ClockModalState();
}

class _ClockModalState extends ConsumerState<ClockModal> {
  @override
  void initState() {
    super.initState();
    // Check location when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clockActionProvider.notifier).checkLocation();
    });
  }

  Future<void> _performClockAction() async {
    final notifier = ref.read(clockActionProvider.notifier);

    bool success;
    if (widget.isClockIn) {
      success = await notifier.clockIn();
    } else {
      success = await notifier.clockOut();
    }

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isClockIn ? 'Clock in berhasil!' : 'Clock out berhasil!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clockActionProvider);

    // Listen for errors
    ref.listen<ClockActionState>(clockActionProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(clockActionProvider.notifier).clearMessages();
      }
    });

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 24),

              // Title
              Text(
                widget.isClockIn ? 'Clock In' : 'Clock Out',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Pastikan Anda berada di area kantor',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Location Status
              if (state.isLoading && state.currentPosition == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Mendapatkan lokasi...'),
                    ],
                  ),
                )
              else if (state.currentPosition != null) ...[
                // Current Location
                _LocationInfoTile(
                  icon: Icons.my_location,
                  label: 'Lokasi Anda',
                  value:
                      '${state.currentPosition!.latitude.toStringAsFixed(6)}, ${state.currentPosition!.longitude.toStringAsFixed(6)}',
                ),
                const SizedBox(height: 12),

                // Nearest Office
                if (state.geofenceResult?.nearestOffice != null)
                  _LocationInfoTile(
                    icon: Icons.business,
                    label: 'Kantor Terdekat',
                    value: state.geofenceResult!.nearestOffice!.name,
                  ),
                const SizedBox(height: 12),

                // Distance & Status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: state.geofenceResult?.isWithinGeofence == true
                        ? AppColors.successLight
                        : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.geofenceResult?.isWithinGeofence == true
                            ? Icons.check_circle
                            : Icons.error,
                        color: state.geofenceResult?.isWithinGeofence == true
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.geofenceResult?.isWithinGeofence == true
                                  ? 'Anda di dalam area kantor'
                                  : 'Anda di luar area kantor',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    state.geofenceResult?.isWithinGeofence ==
                                        true
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                            Text(
                              'Jarak: ${state.geofenceResult?.formattedDistance ?? "-"}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    state.geofenceResult?.isWithinGeofence ==
                                        true
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: widget.isClockIn ? 'Clock In' : 'Clock Out',
                      isLoading: state.isLoading,
                      onPressed: state.geofenceResult?.isWithinGeofence == true
                          ? _performClockAction
                          : null,
                    ),
                  ),
                ],
              ),

              // Refresh button
              if (!state.isLoading) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () =>
                      ref.read(clockActionProvider.notifier).checkLocation(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh Lokasi'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LocationInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
