import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const PawSetuLogo(size: Sizes.logoXl),
          const SizedBox(height: Space.lg),
          SizedBox(
            width: Sizes.avatarXs,
            height: Sizes.avatarXs,
            child: CircularProgressIndicator(strokeWidth: Strokes.chart, color: context.colors.primary),
          ),
        ]),
      ),
    );
  }
}
