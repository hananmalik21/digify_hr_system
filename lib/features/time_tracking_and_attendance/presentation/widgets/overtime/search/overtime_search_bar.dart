import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class OvertimeSearchBar extends ConsumerStatefulWidget {
  final String hintText;
  final bool isDark;
  final double? width;

  const OvertimeSearchBar({
    super.key,
    required this.hintText,
    required this.isDark,
    this.width,
  });

  @override
  ConsumerState<OvertimeSearchBar> createState() => _OvertimeSearchBarState();
}

class _OvertimeSearchBarState extends ConsumerState<OvertimeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = "";

    if (searchQuery == null && _controller.text.isNotEmpty) {
      _controller.clear();
    } else if (searchQuery != null && _controller.text.isEmpty) {
      _controller.text = searchQuery;
    }

    return DigifyTextField.search(
      controller: _controller,
      hintText: widget.hintText,
      onSubmitted: (value) {
        final query = value.trim();
      },
    );
  }
}
