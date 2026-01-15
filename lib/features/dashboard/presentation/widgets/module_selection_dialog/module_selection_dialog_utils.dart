import 'dart:math' as math;

import 'package:flutter/material.dart';

enum DialogBreakpoint { mobile, tablet, desktop }

DialogBreakpoint getBreakpointForWidth(double width) {
  if (width < 600) return DialogBreakpoint.mobile;
  if (width < 1024) return DialogBreakpoint.tablet;
  return DialogBreakpoint.desktop;
}

class DialogSizing {
  final double dialogWidth;
  final double dialogHeight;
  final double outerPadding;
  final double gap;
  final double cardWidth;
  final double cardHeight;
  final int columns;
  final WrapAlignment wrapAlignment;
  final DialogBreakpoint breakpoint;

  DialogSizing({
    required this.dialogWidth,
    required this.dialogHeight,
    required this.outerPadding,
    required this.gap,
    required this.cardWidth,
    required this.cardHeight,
    required this.columns,
    required this.wrapAlignment,
    required this.breakpoint,
  });

  factory DialogSizing.calculate(double maxWidth, double maxHeight) {
    final bp = getBreakpointForWidth(maxWidth);

    // Responsive dialog width
    final dialogW = bp == DialogBreakpoint.mobile
        ? math.min(maxWidth * 0.95, maxWidth - 32)
        : math.min(maxWidth, 1200.0);
    final dialogH = math.min(maxHeight * 0.9, 647.0);

    final outerPad = bp == DialogBreakpoint.mobile ? 12.0 : 32.0;
    final gap = bp == DialogBreakpoint.mobile ? 8.0 : (bp == DialogBreakpoint.tablet ? 12.0 : 20.0);
    final cardW = bp == DialogBreakpoint.mobile ? 150.0 : (bp == DialogBreakpoint.tablet ? 200.0 : 260.0);
    final cardH = bp == DialogBreakpoint.mobile ? 160.0 : (bp == DialogBreakpoint.tablet ? 190.0 : 220.0);

    final availableGridW = dialogW - (outerPad * 2);
    int cols = ((availableGridW + gap) / (cardW + gap)).floor();
    cols = cols.clamp(bp == DialogBreakpoint.mobile ? 1 : 2, 4);

    final wrapAlign = WrapAlignment.start;

    return DialogSizing(
      dialogWidth: dialogW,
      dialogHeight: dialogH,
      outerPadding: outerPad,
      gap: gap,
      cardWidth: cardW,
      cardHeight: cardH,
      columns: cols,
      wrapAlignment: wrapAlign,
      breakpoint: bp,
    );
  }
}
