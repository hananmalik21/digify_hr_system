import 'package:digify_hr_system/core/navigation/app_header.dart';
import 'package:digify_hr_system/core/navigation/sidebar/sidebar.dart';
import 'package:digify_hr_system/core/navigation/sidebar/sidebar_provider.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/keyboard_scroll_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appInitializationAfterAuthProvider);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isSidebarExpanded = ref.watch(sidebarProvider);

    return Scaffold(
      onDrawerChanged: isMobile
          ? (bool isOpened) {
              if (!isOpened) ref.read(sidebarProvider.notifier).collapse();
            }
          : null,
      body: Row(
        children: [
          if (!isMobile) const Sidebar(),
          Expanded(
            child: Column(
              children: [
                AppHeader(isSidebarExpanded: isSidebarExpanded),
                Expanded(child: AppKeyboardScroller(child: child)),
              ],
            ),
          ),
        ],
      ),
      drawer: isMobile ? const Sidebar() : null,
    );
  }
}
