import 'package:drift/drift.dart';

Never _unsupported() => throw UnsupportedError(
      'Cannot open database: platform not supported.',
    );

DatabaseConnection connect() => _unsupported();
