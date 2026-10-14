import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

/// The first loaded value of a stream or future provider, for one-off reads
/// in callbacks. Riverpod 3 pauses providers that nobody listens to, so
/// `ref.read(provider.future)` alone can wait forever for a stream that is
/// not on screen; this keeps a listener open until the value arrives.
Future<T> readOnce<T>(WidgetRef ref, ProviderListenable<AsyncValue<T>> provider) {
  final done = Completer<T>();
  final sub = ref.listenManual<AsyncValue<T>>(
    provider,
    (_, next) {
      if (done.isCompleted || next.isLoading) return;
      if (next.hasError) {
        done.completeError(next.error!, next.stackTrace);
      } else if (next.hasValue) {
        done.complete(next.requireValue);
      }
    },
    fireImmediately: true,
  );
  return done.future.whenComplete(sub.close);
}
