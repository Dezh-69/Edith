import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 72,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.local_library, 'Library'),
          _buildNavItem(context, 1, Icons.edit, 'Reader'),
          _buildNavItem(context, 2, Icons.vertical_split, 'Split'),
          _buildNavItem(context, 3, Icons.document_scanner, 'Tools'),
          _buildNavItem(context, 4, Icons.cloud_done_outlined, 'Sync'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final isActive = currentIndex == index;
    final primary = AppTheme.primary;
    final muted = AppTheme.textMuted;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? primary : muted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isActive ? primary : muted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = AppTheme.primary;
    final muted = AppTheme.textMuted;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: muted.withValues(alpha: 0.2))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Image.asset('assets/logo.png', height: 32, errorBuilder: (context, error, stackTrace) => Icon(Icons.menu_book, color: primary)),
          const SizedBox(height: 32),
          Expanded(
            child: Column(
              children: [
                _buildRailItem(context, 0, Icons.local_library, 'Library'),
                _buildRailItem(context, 1, Icons.edit, 'Reader'),
                _buildRailItem(context, 2, Icons.vertical_split, 'Split'),
                _buildRailItem(context, 3, Icons.document_scanner, 'Tools'),
                _buildRailItem(context, 4, Icons.cloud_done_outlined, 'Sync'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRailItem(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final isActive = currentIndex == index;
    final primary = AppTheme.primary;
    final muted = AppTheme.textMuted;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.secondary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? primary : muted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isActive ? primary : muted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
