/// Utility exports for MyHealth AI core layer.
library;

// Date formatting, validation helpers, string utilities
// will be added here as needed across phases.

/// Formats a [DateTime] to a human-readable clinical date.
String formatClinicalDate(DateTime date) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

/// Formats a [DateTime] to a time string (24h).
String formatTime24h(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
