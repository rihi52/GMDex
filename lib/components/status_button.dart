import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({
    super.key,
    required this.label,
    this.initiallySelected = false,
    this.onChanged,
    this.fillColor,
    this.height = 32,
  });

  final bool initiallySelected;
  final ValueChanged<bool>? onChanged;
  final String label;
  final Color? fillColor; // background when selected
  final double height;

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  late bool _selected = widget.initiallySelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = widget.fillColor ?? AppColors.primary;

    return SizedBox(
      height: widget.height,
      child: FilledButton(
        onPressed: () {
          setState(() => _selected = !_selected);
          widget.onChanged?.call(_selected);
        },
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          backgroundColor: _selected ? fill : Colors.transparent,
          foregroundColor: Colors.white,
          side: BorderSide(color: scheme.outline, width: 1),
          minimumSize: Size(0, widget.height),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.spacingSmall),
          ),
        ),
        child: Text(
          widget.label,
          maxLines: 1,
          softWrap: false,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

/// Labelled counter button whose fill rises from the bottom as its count grows.
class CountFillButton extends StatefulWidget {
  const CountFillButton({
    super.key,
    required this.label,
    required this.tooltip,
    this.tooltipBuilder,
    this.layers = 6,
    this.initialCount = 0,
    this.fillColor,
    this.borderColor,
    this.height = 32,
    this.wrapAround = true,
    this.onChanged,
  });

  final String label;
  final String tooltip;
  final String Function(int count, int layers)? tooltipBuilder;
  final int layers;
  final int initialCount;
  final Color? fillColor; // color of the rising fill
  final Color? borderColor;
  final double height;
  final bool wrapAround;
  final ValueChanged<int>? onChanged;

  @override
  State<CountFillButton> createState() => _CountFillButtonState();
}

class _CountFillButtonState extends State<CountFillButton> {
  late int _count = widget.initialCount.clamp(0, widget.layers);

  void _handlePress() {
    setState(() {
      if (_count < widget.layers) {
        _count++;
      } else if (widget.wrapAround) {
        _count = 0;
      }
    });
    widget.onChanged?.call(_count);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = widget.fillColor ?? AppColors.primary;
    final border = widget.borderColor ?? scheme.outline;

    final tooltipText = widget.tooltipBuilder != null
        ? widget.tooltipBuilder!(_count, widget.layers)
        : '${widget.tooltip}: $_count/${widget.layers}';

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.spacingSmall),
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: Alignment.centerLeft,
                widthFactor: _count / widget.layers,
                heightFactor: 1,
                child: ColoredBox(color: fill),
              ),
            ),
          ),
          Tooltip(
            message: tooltipText,
            child: FilledButton(
              onPressed: _handlePress,
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                side: BorderSide(color: border, width: 1),
                minimumSize: Size(0, widget.height),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.spacingSmall),
                ),
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
