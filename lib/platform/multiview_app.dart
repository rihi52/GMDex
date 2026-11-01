import 'package:flutter/material.dart';

import 'multiview_app_stub.dart'
    if (dart.library.io) 'multiview_app_io.dart'
    as implementation;

void runGmdexApp({
  required Widget Function(BuildContext context, int viewId) home,
  required Widget fallback,
}) {
  implementation.runGmdexApp(home: home, fallback: fallback);
}
