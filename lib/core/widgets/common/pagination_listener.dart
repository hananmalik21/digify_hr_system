import 'package:flutter/material.dart';

/// A wrapper widget that listens to scroll notifications from ancestor scrollables
/// and triggers a callback when scrolling reaches the bottom threshold.
///
/// This widget uses NotificationListener to catch scroll events from parent
/// scrollables, making it work reliably across mobile and web platforms.
class PaginationListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final double threshold;

  const PaginationListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.threshold = 200.0,
  });

  @override
  State<PaginationListener> createState() => _PaginationListenerState();
}

class _PaginationListenerState extends State<PaginationListener> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Only handle scroll update notifications
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          final distanceFromBottom = metrics.maxScrollExtent - metrics.pixels;

          if (distanceFromBottom < widget.threshold + 100) {
            print(
              '📜 Scroll position - pixels: ${metrics.pixels.toStringAsFixed(0)}, max: ${metrics.maxScrollExtent.toStringAsFixed(0)}, distance from bottom: ${distanceFromBottom.toStringAsFixed(0)}px',
            );
          }

          // Check if we're near the bottom and not already loading
          if (!_isLoading &&
              metrics.pixels >= metrics.maxScrollExtent - widget.threshold) {
            print('🎯 Pagination threshold reached! Triggering load more...');
            _isLoading = true;

            // Call the load more callback
            widget.onLoadMore();

            // Reset the loading flag after a short delay to allow next trigger
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          }
        }

        // Return false to allow the notification to continue bubbling up
        return false;
      },
      child: widget.child,
    );
  }
}
