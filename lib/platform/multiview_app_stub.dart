import 'package:flutter/material.dart';

void runGmdexApp({
  required Widget Function(BuildContext context, int viewId) home,
  required Widget fallback,
}) {
  runApp(fallback);
}
