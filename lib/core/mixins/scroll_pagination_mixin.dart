import 'package:flutter/material.dart';

mixin ScrollPaginationMixin<T extends StatefulWidget> on State<T> {
  /// Override this to provide the scroll controller from your widget
  ScrollController? get scrollController;

  void onLoadMore();

  double get paginationThreshold => 200.0;

  bool get enablePaginationLogs => false;

  @override
  void initState() {
    super.initState();
    scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (scrollController == null || !scrollController!.hasClients) {
      return;
    }

    final position = scrollController!.position;
    final distanceFromBottom = position.maxScrollExtent - position.pixels;

    // Trigger load more when within threshold of bottom
    if (distanceFromBottom < paginationThreshold) {
      onLoadMore();
    }
  }
}
