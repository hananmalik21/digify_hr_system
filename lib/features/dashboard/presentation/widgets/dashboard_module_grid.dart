import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderables/reorderables.dart';

import 'dashboard_button_model.dart';
import 'dashboard_module_button.dart';

class DashboardModuleGrid extends ConsumerStatefulWidget {
  final List<DashboardButton> buttons;
  final Function(DashboardButton) onButtonTap;

  const DashboardModuleGrid({super.key, required this.buttons, required this.onButtonTap});

  @override
  ConsumerState<DashboardModuleGrid> createState() => _DashboardModuleGridState();
}

class _DashboardModuleGridState extends ConsumerState<DashboardModuleGrid> {
  late List<DashboardButton> _buttons;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _buttons = List.from(widget.buttons);
  }

  @override
  void didUpdateWidget(DashboardModuleGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttons != widget.buttons) {
      _buttons = List.from(widget.buttons);
    }
  }

  GridSpec _gridSpecForWidth(BuildContext context, double maxW) {
    final bool isMobile = maxW < 600;
    final bool isTablet = maxW >= 600 && maxW < 1024;
    final bool isWeb = maxW >= 1024;

    final double spacing = isMobile ? 4.w : 6.w;

    if (isMobile) {
      const int columns = 2;
      final double totalSpacing = spacing * (columns - 1);
      final double tileW = ((maxW - totalSpacing) / columns).floorToDouble();
      final double tileH = (tileW * 1.0).clamp(130.h, 150.h).toDouble();

      return GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH, needsLongPress: true);
    }

    final double minTileW = 140.w;
    final double maxTileW = isWeb ? 175.w : 155.w;

    int columns = ((maxW + spacing) / (minTileW + spacing)).floor();

    if (isTablet) {
      columns = columns.clamp(3, 5);
    } else if (isWeb) {
      columns = columns.clamp(4, 9);
    }

    final double usableZone = maxW - (spacing * (columns - 1));
    final double tileW = (usableZone / columns).clamp(minTileW, maxTileW).toDouble();
    final double tileH = (tileW * 0.85).clamp(120.h, 145.h).toDouble();

    return GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH, needsLongPress: false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 600;

        final spec = _gridSpecForWidth(context, maxW);

        return ReorderableWrap(
          spacing: spec.spacing,
          runSpacing: isMobile ? 4.h : 6.h,
          alignment: WrapAlignment.start,
          needsLongPressDraggable: spec.needsLongPress,

          buildDraggableFeedback: (context, boxConstraints, child) {
            return Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: ConstrainedBox(constraints: boxConstraints, child: child),
            );
          },

          onReorderStarted: (_) {
            setState(() => _isDragging = true);
          },

          onReorder: (oldIndex, newIndex) {
            setState(() {
              final item = _buttons.removeAt(oldIndex);
              _buttons.insert(newIndex, item);
              _isDragging = false;
            });
          },

          children: List.generate(_buttons.length, (index) {
            final btn = _buttons[index];
            return SizedBox(
              key: ValueKey('dash-${btn.id}'),
              width: spec.tileW,
              height: spec.tileH,
              child: DashboardModuleButton(button: btn, isDragging: _isDragging, onTap: () => widget.onButtonTap(btn)),
            );
          }),
        );
      },
    );
  }
}
