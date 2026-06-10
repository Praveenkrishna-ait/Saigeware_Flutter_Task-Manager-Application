import 'package:task_manager/core/constants/app_constants.dart';

/// Validation helper class
class Validators {
  Validators._();

  /// Validate task title
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.errorTitleRequired;
    }
    if (value.length < AppConstants.minTitleLength) {
      return 'Title must be at least ${AppConstants.minTitleLength} character';
    }
    if (value.length > AppConstants.maxTitleLength) {
      return AppConstants.errorTitleTooLong;
    }
    return null;
  }

  /// Validate description (optional but has max length)
  static String? validateDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';
    }
    return null;
  }

  /// Check if string is valid and not empty
  static bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Check if string meets minimum length
  static bool meetsMinLength(String? value, int minLength) {
    return value != null && value.length >= minLength;
  }

  /// Check if string meets maximum length
  static bool meetsMaxLength(String? value, int maxLength) {
    return value == null || value.length <= maxLength;
  }
}
