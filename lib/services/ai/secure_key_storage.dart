library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _kAnthropicApiKeyKey = 'anthropic_api_key';

/// Secure storage service for sensitive API credentials.
/// Never stores keys in plaintext, logs, or unencrypted storage.
abstract final class SecureKeyStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    wOptions: WindowsOptions(useBackwardCompatibility: false),
  );

  /// Retrieves the saved Anthropic API Key (or null if unset).
  static Future<String?> getAnthropicApiKey() async {
    try {
      return await _storage.read(key: _kAnthropicApiKeyKey);
    } catch (_) {
      return null;
    }
  }

  /// Securely saves the Anthropic API Key.
  static Future<void> saveAnthropicApiKey(String key) async {
    await _storage.write(key: _kAnthropicApiKeyKey, value: key.trim());
  }

  /// Clears the saved API Key.
  static Future<void> clearAnthropicApiKey() async {
    await _storage.delete(key: _kAnthropicApiKeyKey);
  }
}
