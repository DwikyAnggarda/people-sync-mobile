/// Leave Provider
/// State management for leave feature
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../data/models/leave_model.dart';
import '../data/repositories/leave_repository.dart';

/// Leave list state
class LeaveListState {
  final bool isLoading;
  final List<LeaveModel> leaves;
  final String? errorMessage;

  const LeaveListState({
    this.isLoading = false,
    this.leaves = const [],
    this.errorMessage,
  });

  LeaveListState copyWith({
    bool? isLoading,
    List<LeaveModel>? leaves,
    String? errorMessage,
  }) {
    return LeaveListState(
      isLoading: isLoading ?? this.isLoading,
      leaves: leaves ?? this.leaves,
      errorMessage: errorMessage,
    );
  }
}

/// Leave list notifier
class LeaveListNotifier extends StateNotifier<LeaveListState> {
  final LeaveRepository _repository;

  LeaveListNotifier(this._repository) : super(const LeaveListState());

  /// Fetch leave list
  Future<void> fetchLeaves() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final leaves = await _repository.getLeaves();
      state = state.copyWith(isLoading: false, leaves: leaves);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan',
      );
    }
  }

  /// Cancel leave
  Future<bool> cancelLeave(int id) async {
    try {
      await _repository.cancelLeave(id);
      // Remove from list
      final updatedLeaves = state.leaves.where((l) => l.id != id).toList();
      state = state.copyWith(leaves: updatedLeaves);
      return true;
    } on AppException {
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// Leave list provider
final leaveListProvider =
    StateNotifierProvider<LeaveListNotifier, LeaveListState>((ref) {
      final repository = ref.watch(leaveRepositoryProvider);
      return LeaveListNotifier(repository);
    });

/// Leave form state
class LeaveFormState {
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const LeaveFormState({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  LeaveFormState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return LeaveFormState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

/// Leave form notifier
class LeaveFormNotifier extends StateNotifier<LeaveFormState> {
  final LeaveRepository _repository;

  LeaveFormNotifier(this._repository) : super(const LeaveFormState());

  /// Submit leave request
  Future<bool> submitLeave(LeaveRequestModel request) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await _repository.createLeave(request);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Pengajuan cuti berhasil!',
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

/// Leave form provider
final leaveFormProvider =
    StateNotifierProvider<LeaveFormNotifier, LeaveFormState>((ref) {
      final repository = ref.watch(leaveRepositoryProvider);
      return LeaveFormNotifier(repository);
    });
