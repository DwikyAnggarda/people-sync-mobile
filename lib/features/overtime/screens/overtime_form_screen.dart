/// Overtime Form Screen
/// Full screen form for creating overtime requests (used in routes)
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/overtime_form.dart';

class OvertimeFormScreen extends StatelessWidget {
  const OvertimeFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajukan Lembur'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: OvertimeForm(onSuccess: () => context.pop()),
    );
  }
}
