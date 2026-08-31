library;

import 'dart:convert';

import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kRememberedAccountsKey = 'remembered_accounts';
const int _kMaxRememberedAccounts = 6;

/// A lightweight, non-secret record of an account that has previously
/// signed in on this device — enough to let the user recognize and
/// re-select it, never enough to log in without a password.
class RememberedAccount {
  const RememberedAccount({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
  });

  final int userId;
  final String email;
  final String fullName;
  final String role;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'fullName': fullName,
        'role': role,
      };

  factory RememberedAccount.fromJson(Map<String, dynamic> json) => RememberedAccount(
        userId: json['userId'] as int,
        email: json['email'] as String,
        fullName: json['fullName'] as String,
        role: json['role'] as String,
      );

  factory RememberedAccount.fromUser(User user) => RememberedAccount(
        userId: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role.name,
      );
}

/// Persists a short, most-recent-first list of accounts that have signed
/// in on this device — deliberately holds no passwords or session tokens,
/// just enough identity to power a one-tap "Switch Account" picker that
/// still requires re-entering the password.
abstract final class RememberedAccountsStore {
  static Future<List<RememberedAccount>> getAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kRememberedAccountsKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => RememberedAccount.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> remember(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getAll();
      final withoutThisUser = current.where((a) => a.userId != user.id).toList();
      final updated = [RememberedAccount.fromUser(user), ...withoutThisUser]
          .take(_kMaxRememberedAccounts)
          .toList();
      await prefs.setString(
        _kRememberedAccountsKey,
        jsonEncode(updated.map((a) => a.toJson()).toList()),
      );
    } catch (_) {
      // Non-fatal: worst case the account just won't appear in the picker.
    }
  }

  static Future<void> forget(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getAll();
      final updated = current.where((a) => a.userId != userId).toList();
      await prefs.setString(
        _kRememberedAccountsKey,
        jsonEncode(updated.map((a) => a.toJson()).toList()),
      );
    } catch (_) {
      // Non-fatal.
    }
  }
}
