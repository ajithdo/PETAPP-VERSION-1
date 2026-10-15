import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/tokens.dart';
import 'buttons.dart';
import 'illustrations.dart';
import 'layout.dart';

/// Friendly empty state with one call to action (spec 4: States).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.scene = Scene.empty,
    this.compact = false,
  });

  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Scene scene;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? Space.lg : Space.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Illustration(scene, size: compact ? 110 : 160),
              const SizedBox(height: Space.lg),
              Text(title, style: context.text.titleMedium, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: Space.sm),
                Text(message!, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary),
                    textAlign: TextAlign.center),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: Space.lg),
                PrimaryButton(label: actionLabel!, onPressed: onAction, expand: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Says what happened in plain words and offers "Try again".
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry});
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: context.paw.textSecondary),
            const SizedBox(height: Space.md),
            Text(context.l10n.errorTitle, style: context.text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: Space.sm),
            Text(message ?? context.l10n.errorBody,
                style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary),
                textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: Space.lg),
              SecondaryButton(label: context.l10n.tryAgain, onPressed: onRetry, expand: false, icon: Icons.refresh_rounded),
            ],
          ],
        ),
      ),
    );
  }
}

/// Grey placeholder block with a soft pulse (still when reduce motion is on).
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.height = 16, this.width, this.radius = 8});
  final double height;
  final double? width;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.paw.outline;
    Widget box(double t) => Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Color.lerp(base, base.withValues(alpha: 0.4), t),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
    if (context.reduceMotion) return box(0);
    return AnimatedBuilder(animation: _c, builder: (_, _) => box(_c.value));
  }
}

/// A list of card-shaped skeletons for loading screens.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 4, this.itemHeight = 84});
  final int count;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      // Clipped, never overflowing, when it sits in a small space.
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.gutter),
        child: Column(
          children: [
            for (var i = 0; i < count; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: Skeleton(height: itemHeight, radius: Radii.card),
              ),
          ],
        ),
      ),
    );
  }
}

/// Renders an AsyncValue with skeleton, error (Try again) and data states.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.data, this.onRetry, this.loading});
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? const SkeletonList(),
      error: (e, st) {
        debugPrint('AsyncView error: $e\n$st');
        return ErrorState(onRetry: onRetry);
      },
    );
  }
}
