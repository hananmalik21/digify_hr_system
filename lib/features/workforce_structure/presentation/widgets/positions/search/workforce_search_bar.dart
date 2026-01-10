import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';

class WorkforceSearchBar extends ConsumerStatefulWidget {
  final String hintText;
  final bool isDark;
  final double? width;

  const WorkforceSearchBar({super.key, required this.hintText, required this.isDark, this.width});

  @override
  ConsumerState<WorkforceSearchBar> createState() => _WorkforceSearchBarState();
}

class _WorkforceSearchBarState extends ConsumerState<WorkforceSearchBar> {
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
    final searchQuery = ref.watch(positionNotifierProvider.select((s) => s.searchQuery));

    if (searchQuery != null && _controller.text != searchQuery) {
      _controller.text = searchQuery;
    } else if (searchQuery == null && _controller.text.isNotEmpty) {
      _controller.clear();
    }

    return DigifyTextField.search(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: (value) => ref.read(positionNotifierProvider.notifier).search(value),
    );
  }
}
