import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';

import 'dashboard_button_model.dart';
import 'dashboard_module_button.dart';

class DashboardModuleGrid extends ConsumerStatefulWidget {
  final List<DashboardButton> buttons;

  const DashboardModuleGrid({
    super.key,
    required this.buttons,
  });

  @override
  ConsumerState<DashboardModuleGrid> createState() =>
      _DashboardModuleGridState();
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

    final double spacing = 16.w;

    if (isMobile) {
      const int columns = 2;
      final double usable = maxW - spacing;
      final double tileW = (usable / columns).clamp(130.0, 155.0).toDouble();
      final double tileH = (tileW * 0.95).clamp(155.0, 180.0).toDouble();

      return GridSpec(
        columns: columns,
        spacing: spacing,
        tileW: tileW,
        tileH: tileH,
        needsLongPress: true,
      );
    }

    final double minTileW = isTablet ? 170.0 : 170.0;
    final double maxTileW = isTablet ? 220.0 : 230.0;

    int columns = ((maxW + spacing) / (minTileW + spacing)).floor();

    if (isTablet) {
      columns = columns.clamp(2, 4);
    } else if (isWeb) {
      columns = columns.clamp(3, 6);
    }

    final double usable = maxW - (spacing * (columns - 1));
    final double tileW =
        (usable / columns).clamp(minTileW, maxTileW).toDouble();

    final double tileH = isTablet
        ? (tileW * 0.78).clamp(140.0, 160.0).toDouble()
        : (tileW * 0.70).clamp(120.0, 140.0).toDouble();

    return GridSpec(
      columns: columns,
      spacing: spacing,
      tileW: tileW,
      tileH: tileH,
      needsLongPress: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final isMobile = maxW < 600;
        final isTablet = maxW >= 600 && maxW < 1024;

        final spec = _gridSpecForWidth(context, maxW);

        return ReorderableWrap(
          spacing: spec.spacing,
          runSpacing: isMobile ? 10.h : (isTablet ? 12.h : 14.h),
          alignment: WrapAlignment.start,
          needsLongPressDraggable: spec.needsLongPress,

          buildDraggableFeedback: (context, boxConstraints, child) {
            return Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: ConstrainedBox(
                constraints: boxConstraints,
                child: child,
              ),
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
              child: DashboardModuleButton(
                button: btn,
                isDragging: _isDragging,
                onTap: () => context.go(btn.route),
              ),
            );
          }),
        );
      },
    );
  }
}

