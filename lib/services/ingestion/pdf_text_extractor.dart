library;

import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;

/// Pure-Dart offline PDF text extractor (RQ1 Ingestion Pipeline).
abstract final class PdfTextExtractor {
  static const int maxFileSizeBytes = 15 * 1024 * 1024; // 15MB
  static const int maxPages = 25;

  /// Extracts plain text content from a local PDF file bytes.
  static String extractTextFromBytes(Uint8List bytes) {
    if (bytes.length > maxFileSizeBytes) {
      throw ArgumentError('PDF file exceeds maximum allowed size of 15MB.');
    }

    final document = syncfusion.PdfDocument(inputBytes: bytes);
    try {
      if (document.pages.count > maxPages) {
        throw ArgumentError('PDF exceeds maximum allowed length of 25 pages.');
      }

      final text = syncfusion.PdfTextExtractor(document).extractText();
      return text.trim();
    } finally {
      document.dispose();
    }
  }
}
