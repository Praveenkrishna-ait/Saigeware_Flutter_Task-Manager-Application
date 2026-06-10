import 'package:intl/intl.dart';

/// Extension methods for DateTime
extension DateTimeExtension on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast {
    return isBefore(DateTime.now());
  }

  /// Check if date is in the future
  bool get isFuture {
    return isAfter(DateTime.now());
  }

  /// Format date as readable string
  String get formattedDate {
    if (isToday) {
      return 'Today at ${DateFormat('h:mm a').format(this)}';
    } else if (isYesterday) {
      return 'Yesterday';
    } else if (isTomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d, y').format(this);
    }
  }

  /// Format date for display in list
  String get formattedDateShort {
    if (isToday) {
      return 'Today';
    } else if (isYesterday) {
      return 'Yesterday';
    } else if (isTomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM d').format(this);
    }
  }

  /// Get time difference in human-readable format
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formattedDateShort;
    }
  }
}

/// Extension methods for String
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Check if string is empty or whitespace only
  bool get isEmptyOrWhitespace {
    return trim().isEmpty;
  }

  /// Truncate string to specific length with ellipsis
  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }
}

/// Extension methods for int (Priority)
extension PriorityExtension on int {
  /// Get priority name from index
  String get priorityName {
    switch (this) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Low';
    }
  }

  /// Check if priority is high
  bool get isHighPriority => this == 2;

  /// Check if priority is medium
  bool get isMediumPriority => this == 1;

  /// Check if priority is low
  bool get isLowPriority => this == 0;
}

/// Extension methods for List
extension ListExtension<T> on List<T>? {
  /// Check if list is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  /// Get first item or null
  T? get firstOrNull {
    if (isNullOrEmpty) return null;
    return this!.first;
  }

  /// Get last item or null
  T? get lastOrNull {
    if (isNullOrEmpty) return null;
    return this!.last;
  }
}

/// Extension methods for Map
extension MapExtension<K, V> on Map<K, V>? {
  /// Check if map is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}
