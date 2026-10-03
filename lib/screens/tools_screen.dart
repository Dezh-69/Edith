import 'dart:ui';
import 'package:flutter/material.dart';

import '../widgets/library/custom_bottom_nav_bar.dart';
import '../widgets/tools/ocr_scanner_pane.dart';
import '../widgets/tools/converter_pane.dart';
import '../widgets/tools/merge_files_pane.dart';
import '../widgets/tools/device_sync_pane.dart';
import '../theme/app_theme.dart';
import 'split_screen.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  int _activeTabIndex = 0; // 0 = OCR, 1 = Converter, 2 = Merge, 3 = Device Sync

  void _handleNavTap(int idx) {
    if (idx == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (idx == 1) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (idx == 2) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (idx == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplitScreen()),
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
                        'Tools',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary.withValues(alpha: 0.8),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (isTabletOrDesktop)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Paired • B2 Active',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.lightBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isTabletOrDesktop)
            CustomNavRail(
              currentIndex: 3,
              onTap: _handleNavTap,
            ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 64),
                // Segmented Studio Controller
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildTabButton(0, 'OCR Scanner', Icons.document_scanner)),
                        Expanded(child: _buildTabButton(1, 'Converter', Icons.transform)),
                        Expanded(child: _buildTabButton(2, 'Merge Files', Icons.call_merge)),
                        Expanded(child: _buildTabButton(3, 'Device Sync', Icons.phonelink_ring)),
                      ],
                    ),
                  ),
                ),
                // Tab Content
                Expanded(
                  child: IndexedStack(
                    index: _activeTabIndex,
                    children: const [
                      OcrScannerPane(),
                      ConverterPane(),
                      MergeFilesPane(),
                      DeviceSyncPane(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isTabletOrDesktop 
          ? null 
          : CustomBottomNavBar(
              currentIndex: 3, // Tools tab
              onTap: _handleNavTap,
            ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive ? const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))] : [],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : AppTheme.textPrimaryLight),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive ? Colors.white : AppTheme.textPrimaryLight,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
