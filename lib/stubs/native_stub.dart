/// Stub for NativeDatabase on web platform
/// This file is only used when compiling for web to satisfy the import requirement
class NativeDatabase {
  static Never memory() {
    throw UnsupportedError('NativeDatabase is not available on web platform');
  }
}
