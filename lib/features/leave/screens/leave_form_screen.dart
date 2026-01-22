/// Leave Form Screen
/// Full screen form for creating leave requests (used in routes)
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/leave_form.dart';

class LeaveFormScreen extends StatelessWidget {
  const LeaveFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajukan Cuti'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: LeaveForm(onSuccess: () => context.pop()),
    );
  }
}
