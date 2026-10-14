import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers.dart';

/// Video calls for tele-vet (spec 7.7). Version 1 uses a simulated call
/// (no camera, microphone or network); Version 2 (L4) plugs in a real
/// provider with tokens from Cloud Functions.
abstract class VideoCallService {
  bool get simulated;

  /// Joins the call room for a consultation. Returns when connected.
  Future<void> join({required String consultationId, required String uid});
  Future<void> leave();
}

class DemoVideoCallService implements VideoCallService {
  @override
  bool get simulated => true;

  @override
  Future<void> join({required String consultationId, required String uid}) =>
      Future<void>.delayed(const Duration(milliseconds: 1600));

  @override
  Future<void> leave() async {}
}

/// Version 2 placeholder: the real provider is chosen in Live phase L4.
class LiveVideoCallService implements VideoCallService {
  @override
  bool get simulated => false;

  @override
  Future<void> join({required String consultationId, required String uid}) =>
      Future<void>.error(UnsupportedError('Live video calls arrive in Version 2 (Live phase L4).'));

  @override
  Future<void> leave() async {}
}

final videoCallServiceProvider = Provider<VideoCallService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.serviceMode('video') == AppMode.demo ? DemoVideoCallService() : LiveVideoCallService();
});
