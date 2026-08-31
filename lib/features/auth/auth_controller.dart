library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kSessionUserIdKey = 'session_user_id';

/// Current authenticated user state provider.
final currentUserProvider = StateProvider<User?>((ref) => null);

/// Auth state holder.
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(const AuthState()) {
    _initSession();
  }

  final Ref ref;

  Future<void> _initSession() async {
    state = const AuthState(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getInt(_kSessionUserIdKey);

    if (savedUserId != null) {
      final userResult = await ref.read(userRepositoryProvider).getUserById(savedUserId);
      userResult.fold(
        (user) {
          ref.read(currentUserProvider.notifier).state = user;
        },
        (_) async {
          await prefs.remove(_kSessionUserIdKey);
        },
      );
    }

    state = const AuthState(isLoading: false);
  }

  Future<bool> login(String email, String password) async {
    state = const AuthState(isLoading: true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(email: email, password: password);

    return result.fold(
      (user) async {
        ref.read(currentUserProvider.notifier).state = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_kSessionUserIdKey, user.id);
        state = const AuthState(isLoading: false);
        return true;
      },
      (failure) {
        state = AuthState(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> registerPatient({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required DateTime dob,
    required String gender,
    required String nationalId,
    required String bloodType,
    required List<String> allergies,
    required List<String> chronicConditions,
    required String emergencyContact,
  }) async {
    state = const AuthState(isLoading: true);

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.registerPatient(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      dob: dob,
      gender: gender,
      nationalId: nationalId,
      bloodType: bloodType,
      allergies: allergies,
      chronicConditions: chronicConditions,
      emergencyContact: emergencyContact,
    );

    return result.fold(
      (user) async {
        ref.read(currentUserProvider.notifier).state = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_kSessionUserIdKey, user.id);
        state = const AuthState(isLoading: false);
        return true;
      },
      (failure) {
        state = AuthState(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<void> logout() async {
    state = const AuthState(isLoading: true);
    await ref.read(authRepositoryProvider).logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionUserIdKey);
    ref.read(currentUserProvider.notifier).state = null;
    state = const AuthState(isLoading: false);
  }

  /// Quick demo user switch for defense evaluations.
  Future<void> switchDemoUser(String email, String password) async {
    await logout();
    await login(email, password);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
