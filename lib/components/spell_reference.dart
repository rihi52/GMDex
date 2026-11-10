import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gmdex/components/spell_details.dart';
import 'package:gmdex/database/database.dart';
import 'package:gmdex/database/spell_lookup.dart';
import 'package:gmdex/theme/apptheme.dart';

/// Displays a creature spell name and reveals its catalog details when found.
class SpellReference extends StatefulWidget {
  const SpellReference({
    super.key,
    required this.database,
    required this.name,
    required this.style,
  });

  final AppDatabase database;
  final String name;
  final TextStyle? style;

  @override
  State<SpellReference> createState() => _SpellReferenceState();
}

class _SpellReferenceState extends State<SpellReference> {
  final _overlayController = OverlayPortalController();
  final _anchorKey = GlobalKey();
  late Stream<SpellRow?> _spellStream;
  Timer? _closeTimer;
  bool _isHovered = false;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _watchSpell();
  }

  @override
  void didUpdateWidget(covariant SpellReference oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.database != widget.database ||
        oldWidget.name != widget.name) {
      _watchSpell();
    }
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  void _watchSpell() {
    _spellStream = watchSpellByName(widget.database, widget.name);
  }

  void _showHoverCard() {
    _closeTimer?.cancel();
    if (!_isHovered) setState(() => _isHovered = true);
    _overlayController.show();
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      _overlayController.hide();
      setState(() => _isHovered = false);
    });
  }

  Widget _hoverCard(SpellRow spell) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final renderObject = _anchorKey.currentContext?.findRenderObject();
          if (renderObject is! RenderBox || !renderObject.hasSize) {
            return const SizedBox.shrink();
          }

          final screenSize = MediaQuery.sizeOf(context);
          final anchorRect =
              renderObject.localToGlobal(Offset.zero) & renderObject.size;
          final width = math.min(420.0, screenSize.width - 16);
          final maxHeight = math.min(460.0, screenSize.height - 16);
          final left = anchorRect.left
              .clamp(8.0, screenSize.width - width - 8)
              .toDouble();
          final below = anchorRect.bottom + 8;
          final top = below + maxHeight <= screenSize.height
              ? below
              : math.max(8.0, anchorRect.top - maxHeight - 8);

          return Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                width: width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: MouseRegion(
                    onEnter: (_) => _showHoverCard(),
                    onExit: (_) => _scheduleClose(),
                    child: Material(
                      color: AppColors.cardBackground,
                      elevation: 12,
                      shadowColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cornerRadiusMedium,
                        ),
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SingleChildScrollView(
                        child: SpellDetails(spell: spell),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    _isMobile =
        platform == TargetPlatform.android ||
        platform == TargetPlatform.fuchsia ||
        platform == TargetPlatform.iOS;

    return StreamBuilder<SpellRow?>(
      stream: _spellStream,
      builder: (context, snapshot) {
        final spell = snapshot.data;
        if (spell == null) return Text(widget.name, style: widget.style);

        final text = Text(
          widget.name,
          style: widget.style?.copyWith(color: AppColors.primary),
        );

        if (_isMobile) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                contentPadding: EdgeInsetsDirectional.all(AppSpacing.spacingLarge),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusLarge)),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SpellDetails(spell: spell),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            child: text,
          );
        }

        return OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (_) => _hoverCard(spell),
          child: MouseRegion(
            key: _anchorKey,
            cursor: SystemMouseCursors.click,
            onEnter: (_) => _showHoverCard(),
            onExit: (_) => _scheduleClose(),
            child: DecoratedBox(
              key: const ValueKey('spell-reference-decoration'),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isHovered ? Colors.white : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: text,
              ),
            ),
          ),
        );
      },
    );
  }
}
