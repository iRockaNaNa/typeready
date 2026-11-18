/// The passage category a test draws from.
enum PassageCategory {
  general,
  dataEntry,
  customerSupport;

  String get label {
    switch (this) {
      case PassageCategory.general:
        return 'General';
      case PassageCategory.dataEntry:
        return 'Data Entry';
      case PassageCategory.customerSupport:
        return 'Customer Support';
    }
  }

  /// Short blurb shown on the home screen under each category.
  String get blurb {
    switch (this) {
      case PassageCategory.general:
        return 'Everyday English, like most typing tests use.';
      case PassageCategory.dataEntry:
        return 'Names, numbers, amounts, addresses and dates.';
      case PassageCategory.customerSupport:
        return 'Realistic support replies: orders, refunds, resets.';
    }
  }

  /// Key used when saving best scores in shared preferences.
  String get storageKey => name;
}

/// How long a test runs.
enum TestLength {
  oneMinute,
  threeMinutes,
  fiveMinutes;

  int get seconds {
    switch (this) {
      case TestLength.oneMinute:
        return 60;
      case TestLength.threeMinutes:
        return 180;
      case TestLength.fiveMinutes:
        return 300;
    }
  }

  String get label {
    switch (this) {
      case TestLength.oneMinute:
        return '1 min';
      case TestLength.threeMinutes:
        return '3 min';
      case TestLength.fiveMinutes:
        return '5 min';
    }
  }
}

/// The settings a test run is started with.
class TestSettings {
  const TestSettings({
    required this.length,
    required this.category,
  });

  final TestLength length;
  final PassageCategory category;
}
