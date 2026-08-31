import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Salted password hashing utility for local-only authentication.
///
/// Generates cryptographic 16-byte random salts and hashes passwords
/// using SHA-256 with multiple iterations.
abstract final class PasswordHasher {
  static const int _iterations = 1000;

  /// Generates a random cryptographic salt.
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Hashes a [password] with a given [salt].
  static String hashPassword(String password, String salt) {
    List<int> currentBytes = utf8.encode('$salt:$password');
    for (var i = 0; i < _iterations; i++) {
      currentBytes = Uint8List.fromList(sha256.convert(currentBytes).bytes);
    }
    return base64Url.encode(currentBytes);
  }

  /// Verifies if a plaintext [password] matches a stored [salt] and [hash].
  static bool verify(String password, String salt, String hash) {
    final computedHash = hashPassword(password, salt);
    return computedHash == hash;
  }
}
