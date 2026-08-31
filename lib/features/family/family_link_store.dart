library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String _kFamilyLinksKey = 'family_links';

/// Relationship of a dependent to the guardian managing their account.
enum FamilyRelationship { child, parent, sibling, other }

extension FamilyRelationshipLabel on FamilyRelationship {
  String get label {
    switch (this) {
      case FamilyRelationship.child:
        return 'Child';
      case FamilyRelationship.parent:
        return 'Parent';
      case FamilyRelationship.sibling:
        return 'Sibling';
      case FamilyRelationship.other:
        return 'Family Member';
    }
  }
}

/// A guardian → dependent link. The dependent has their own full
/// `Users`/`PatientProfiles` record (created via the normal registration
/// path with a system-generated login the dependent never uses) — this
/// link is purely what grants the guardian permission to act on it.
class FamilyLink {
  const FamilyLink({
    required this.guardianUserId,
    required this.dependentUserId,
    required this.relationship,
    required this.createdAt,
  });

  final int guardianUserId;
  final int dependentUserId;
  final FamilyRelationship relationship;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'guardianUserId': guardianUserId,
        'dependentUserId': dependentUserId,
        'relationship': relationship.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FamilyLink.fromJson(Map<String, dynamic> json) => FamilyLink(
        guardianUserId: json['guardianUserId'] as int,
        dependentUserId: json['dependentUserId'] as int,
        relationship: FamilyRelationship.values.firstWhere(
          (r) => r.name == json['relationship'],
          orElse: () => FamilyRelationship.other,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Local-first store for guardian/dependent relationships.
///
/// Kept out of Drift deliberately: the project's generated database code
/// (`app_database.g.dart`) can't be safely regenerated in every
/// environment this app is built in, so this feature is built entirely on
/// tables and generated companions that already exist, plus this small
/// SharedPreferences-backed link list — the same mechanism already used
/// for session persistence and remembered accounts.
abstract final class FamilyLinkStore {
  static Future<List<FamilyLink>> _readAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kFamilyLinksKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => FamilyLink.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _writeAll(List<FamilyLink> links) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kFamilyLinksKey, jsonEncode(links.map((l) => l.toJson()).toList()));
    } catch (_) {
      // Non-fatal: the link just won't persist across restarts.
    }
  }

  /// Dependents this guardian has added and can manage.
  static Future<List<FamilyLink>> getDependentsFor(int guardianUserId) async {
    final all = await _readAll();
    return all.where((l) => l.guardianUserId == guardianUserId).toList();
  }

  /// Whether [guardianUserId] is authorized to manage [dependentUserId] —
  /// the single authorization check every "act as dependent" entry point
  /// should pass through.
  static Future<bool> canManage({required int guardianUserId, required int dependentUserId}) async {
    final links = await getDependentsFor(guardianUserId);
    return links.any((l) => l.dependentUserId == dependentUserId);
  }

  static Future<void> addLink({
    required int guardianUserId,
    required int dependentUserId,
    required FamilyRelationship relationship,
  }) async {
    final all = await _readAll();
    all.removeWhere((l) => l.guardianUserId == guardianUserId && l.dependentUserId == dependentUserId);
    all.add(FamilyLink(
      guardianUserId: guardianUserId,
      dependentUserId: dependentUserId,
      relationship: relationship,
      createdAt: DateTime.now(),
    ));
    await _writeAll(all);
  }

  static Future<void> removeLink({required int guardianUserId, required int dependentUserId}) async {
    final all = await _readAll();
    all.removeWhere((l) => l.guardianUserId == guardianUserId && l.dependentUserId == dependentUserId);
    await _writeAll(all);
  }
}
