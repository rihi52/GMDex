/// Web-only stand-in for the native SQLite database constructor.
///
/// Conditional imports can resolve this symbol while compiling for web, but
/// attempting to open a native database there fails explicitly.
class NativeDatabase {
  /// Native in-memory databases are unavailable in browser builds.
  static Never memory() {
    throw UnsupportedError('NativeDatabase is not available on web platform');
  }
}
