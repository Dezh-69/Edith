import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/edith_file.dart';
import '../widgets/reader/document_viewer_panel.dart';
import '../theme/app_theme.dart';

class DocumentViewerScreen extends StatelessWidget {
  final EdithFile file;

  const DocumentViewerScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
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
                        'Reader',
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
                if (isDesktop)
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
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 64),
        child: DocumentViewerPanel(file: file, showDesktopSidebar: isDesktop),
      ),
    );
  }
}
