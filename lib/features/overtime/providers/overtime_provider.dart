/// Overtime Provider
/// State management for overtime feature
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../data/models/overtime_model.dart';
import '../data/repositories/overtime_repository.dart';

/// Overtime list state
class OvertimeListState {
  final bool isLoading;
  final List<OvertimeModel> overtimes;
  final String? errorMessage;

  const OvertimeListState({
    this.isLoading = false,
    this.overtimes = const [],
    this.errorMessage,
  });

  OvertimeListState copyWith({
    bool? isLoading,
    List<OvertimeModel>? overtimes,
    String? errorMessage,
  }) {
    return OvertimeListState(
      isLoading: isLoading ?? this.isLoading,
      overtimes: overtimes ?? this.overtimes,
      errorMessage: errorMessage,
    );
  }
}

/// Overtime list notifier
class OvertimeListNotifier extends StateNotifier<OvertimeListState> {
  final OvertimeRepository _repository;

  OvertimeListNotifier(this._repository) : super(const OvertimeListState());

  /// Fetch overtime list
  Future<void> fetchOvertimes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final overtimes = await _repository.getOvertimes();
      state = state.copyWith(isLoading: false, overtimes: overtimes);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan',
      );
    }
  }

  /// Cancel overtime
  Future<bool> cancelOvertime(int id) async {
    try {
      await _repository.cancelOvertime(id);
      final updatedList = state.overtimes.where((o) => o.id != id).toList();
      state = state.copyWith(overtimes: updatedList);
      return true;
    } on AppException {
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// Overtime list provider
final overtimeListProvider =
    StateNotifierProvider<OvertimeListNotifier, OvertimeListState>((ref) {
      final repository = ref.watch(overtimeRepositoryProvider);
      return OvertimeListNotifier(repository);
    });

/// Overtime form state
class OvertimeFormState {
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const OvertimeFormState({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  OvertimeFormState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return OvertimeFormState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

/// Overtime form notifier
class OvertimeFormNotifier extends StateNotifier<OvertimeFormState> {
  final OvertimeRepository _repository;

  OvertimeFormNotifier(this._repository) : super(const OvertimeFormState());

  /// Submit overtime request
  Future<bool> submitOvertime(OvertimeRequestModel request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await _repository.createOvertime(request);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Pengajuan lembur berhasil!',
      );
      return true;
    } on ValidationException catch (e) {
      final errorMsg = e.errors.isNotEmpty
          ? e.errors.values.first.first
          : e.message;
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return false;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan',
      );
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

/// Overtime form provider
final overtimeFormProvider =
    StateNotifierProvider<OvertimeFormNotifier, OvertimeFormState>((ref) {
      final repository = ref.watch(overtimeRepositoryProvider);
      return OvertimeFormNotifier(repository);
    });
