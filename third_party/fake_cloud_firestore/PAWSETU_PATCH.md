# PawSetu patch

Copy of fake_cloud_firestore 4.3.0 (BSD licence, see LICENSE) from pub.dev.

Change: `MockFieldValueFactoryPlatform` now extends `FieldValueFactoryPlatform`
instead of mixing in `MockPlatformInterfaceMixin`. That mixin is rejected in
release builds, which stopped the standalone demo (`BACKEND=standalone`) from
starting in the release website and APK. Nothing else is changed.
