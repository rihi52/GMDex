import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:multiview_desktop/multiview_desktop.dart';

import 'multiview_support.dart';

void runGmdexApp({
  required Widget Function(BuildContext context, int viewId) home,
  required Widget fallback,
}) {
  if (!supportsMultiViewPlatform) {
    runApp(fallback);
    return;
  }

  runMultiApp(
    home: home,
    config: MultiAppConfig(
      mainWindowOptions:
          {
            TargetPlatform.windows,
            TargetPlatform.macOS,
            TargetPlatform.linux,
          }.contains(defaultTargetPlatform)
          ? const WindowOptions(size: Size(1300, 800))
          : null,
    ),
  );
}
