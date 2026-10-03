import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/edith_file.dart';
import '../widgets/reader/document_viewer_panel.dart';
import '../widgets/library/custom_bottom_nav_bar.dart';
import 'tools_screen.dart';
import '../theme/app_theme.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  late EdithFile file1;
  late EdithFile file2;

  @override
  void initState() {
    super.initState();
    // Initialize with two dummy files to test the split view immediately
    file1 = EdithFile(
      id: const Uuid().v4(),
      displayName: 'Cell_Biology_Ch7_Membranes.pdf',
      path: 'dummy',
      type: 'pdf',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: 14200000,
    );
    file2 = EdithFile(
      id: const Uuid().v4(),
      displayName: 'Organic_Chemistry_Reaction_Mechanisms.docx',
      path: 'dummy',
      type: 'docx',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: 4800000,
    );
  }

  void _handleNavTap(int idx) {
    if (idx == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (idx == 1) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (idx == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ToolsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = width > 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.95),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  Image.asset('assets/logo.png', height: 32, errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book, color: Colors.white)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edith',
                        style: TextStyle(
                          color: AppTheme.lightBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Split View',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary.withValues(alpha: 0.8),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isTabletOrDesktop)
            CustomNavRail(
              currentIndex: 2,
              onTap: _handleNavTap,
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
      
                if (isDesktop) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 64,
                      bottom: isTabletOrDesktop ? 16 : 80,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DocumentViewerPanel(file: file1, showDesktopSidebar: false),
                        ),
                        Container(
                          width: 4,
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.textMuted.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DocumentViewerPanel(file: file2, showDesktopSidebar: false),
                        ),
                      ],
                    ),
                  );
                }
      
                // Mobile view - stacked vertically
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 64,
                    bottom: isTabletOrDesktop ? 16 : 80,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: DocumentViewerPanel(file: file1, showDesktopSidebar: false),
                      ),
                      Container(
                        height: 4,
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        child: Center(
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.textMuted.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DocumentViewerPanel(file: file2, showDesktopSidebar: false),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: isTabletOrDesktop
          ? null
          : CustomBottomNavBar(
              currentIndex: 2, // Split tab
              onTap: _handleNavTap,
            ),
    );
  }
}
