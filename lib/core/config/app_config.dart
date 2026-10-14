/// How the app runs. Chosen at build time with --dart-define, for example:
///   flutter run -d chrome --dart-define=BACKEND=emulator
///
/// APP_MODE: demo (Version 1, simulated outside services) or live (Version 2).
/// BACKEND: standalone (in-app demo database), emulator (Firebase Local
/// Emulator Suite) or firebase (a real Firebase project).
enum AppMode { demo, live }

enum Backend { standalone, emulator, firebase }

class AppConfig {
  const AppConfig({
    required this.mode,
    required this.backend,
    required this.emulatorHost,
    required this.firebaseProjectId,
  });

  final AppMode mode;
  final Backend backend;

  /// Host where the emulators run. Android emulators reach the computer at
  /// 10.0.2.2; a real phone needs the computer's Wi-Fi address.
  final String emulatorHost;
  final String firebaseProjectId;

  bool get isDemo => mode == AppMode.demo;
  bool get isStandalone => backend == Backend.standalone;
  bool get usesFirebase => backend != Backend.standalone;

  /// Per-service override, e.g. --dart-define=PAYMENTS_MODE=live.
  /// Falls back to [mode]. Demo mode never calls a real service.
  AppMode serviceMode(String service) {
    final raw = switch (service) {
      'payments' => const String.fromEnvironment('PAYMENTS_MODE'),
      'messaging' => const String.fromEnvironment('MESSAGING_MODE'),
      'video' => const String.fromEnvironment('VIDEO_MODE'),
      'ai' => const String.fromEnvironment('AI_MODE'),
      'devices' => const String.fromEnvironment('DEVICES_MODE'),
      _ => '',
    };
    if (raw == 'live') return AppMode.live;
    if (raw == 'demo') return AppMode.demo;
    return mode;
  }

  static AppConfig fromEnvironment() {
    const modeRaw = String.fromEnvironment('APP_MODE', defaultValue: 'demo');
    const backendRaw =
        String.fromEnvironment('BACKEND', defaultValue: 'standalone');
    const host =
        String.fromEnvironment('EMULATOR_HOST', defaultValue: 'localhost');
    const projectId =
        String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'demo-pawsetu');
    return AppConfig(
      mode: modeRaw == 'live' ? AppMode.live : AppMode.demo,
      backend: switch (backendRaw) {
        'emulator' => Backend.emulator,
        'firebase' => Backend.firebase,
        _ => Backend.standalone,
      },
      emulatorHost: host,
      firebaseProjectId: projectId,
    );
  }
}
