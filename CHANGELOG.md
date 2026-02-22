## 1.0.0

* Migrated to Dart 3 and Flutter 3.10+
* Updated Android build to AGP 8.11.1, Gradle 8.14, Java 17
* Fixed Instagram sharing broken on Android 11+ (API 30+) by declaring `<queries>` package visibility
* Added `FLAG_GRANT_READ_URI_PERMISSION` so Instagram can read the shared file URI
* Removed obsolete V1 Flutter embedding (`registerWith` / `Registrar`)
* Removed `WRITE_EXTERNAL_STORAGE` permission gate that blocked sharing on Android 10+
* Replaced deprecated `jcenter()` with `mavenCentral()`

## 0.1.0

* Migrated the codebase to V2 Android Embedding

## 0.0.1

* Initial release.