import 'package:digify_hr_system/core/navigation/app_header.dart';
import 'package:digify_hr_system/core/navigation/sidebar.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final sidebarExpanded = ref.watch(sidebarProvider);

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Row(
              children: [
                // Sidebar - visible on desktop/tablet, drawer on mobile
                if (!isMobile)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: sidebarExpanded ? 288.w : 0,
                    child: sidebarExpanded
                        ? const Sidebar()
                        : const SizedBox.shrink(),
                  ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer for mobile
      drawer: isMobile ? const Sidebar() : null,
    );
  }
}

