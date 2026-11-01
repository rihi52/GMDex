/// Width thresholds and helpers for selecting compact versus wide layouts.
///
/// Callers pass the width available to their own layout, rather than relying
/// on the overall display size, so split-screen and resized windows work too.
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints._();

  static const double navigation = 700;
  static const double browseDetails = 900;
  static const double encounterBuilder = 1050;
  static const double compactContent = 500;
  static const double encounterRun = 800;
}

class ResponsiveLayout {
  const ResponsiveLayout._();

  /// Returns whether [availableWidth] reaches the supplied wide-layout cutoff.
  static bool isWide(double availableWidth, {required double breakpoint}) {
    return availableWidth >= breakpoint;
  }

  /// Returns the inverse of [isWide] for compact-layout decisions.
  static bool isNarrow(double availableWidth, {required double breakpoint}) {
    return !isWide(availableWidth, breakpoint: breakpoint);
  }
}
