import 'package:drift/drift.dart';

import 'package:myhealth_ai/data/db/connection/unsupported.dart'
    if (dart.library.io) 'package:myhealth_ai/data/db/connection/native.dart'
    if (dart.library.js_interop) 'package:myhealth_ai/data/db/connection/web.dart'
    as impl;

/// Cross-platform database connector.
/// Automatically resolves to Native (Windows/Android/iOS) or Web (WASM) implementation.
DatabaseConnection openConnection({String dbName = 'myhealth_ai.sqlite'}) {
  return impl.connect();
}
