import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FloatingAnnotationToolbar extends StatelessWidget {
  final String activeTool;
  final Color activeColor;
  final ValueChanged<String> onToolSelected;
  final ValueChanged<Color> onColorSelected;

  const FloatingAnnotationToolbar({
    super.key,
    required this.activeTool,
    required this.activeColor,
    required this.onToolSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.95),
            theme.colorScheme.surface.withValues(alpha: 0.0),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ARCHIVAL INKS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: AppTheme.textMuted,
                  ),
                ),
                Row(
                  children: [
                    _buildSwatch(const Color(0xFF4E8752), activeColor == const Color(0xFF4E8752)),
                    const SizedBox(width: 8),
                    _buildSwatch(AppTheme.primary, activeColor == AppTheme.primary),
                    const SizedBox(width: 8),
                    _buildSwatch(const Color(0xFFFCD34D), activeColor == const Color(0xFFFCD34D)),
                    const SizedBox(width: 8),
                    _buildSwatch(const Color(0xFFFB7185), activeColor == const Color(0xFFFB7185)),
                    const SizedBox(width: 8),
                    _buildSwatch(const Color(0xFFC084FC), activeColor == const Color(0xFFC084FC)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildToolBtn(Icons.highlight, 'Highlight', 'highlight', activeTool == 'highlight'),
                  _buildToolBtn(Icons.visibility_off, 'Blind (F4)', 'blind', activeTool == 'blind'),
                  _buildToolBtn(Icons.note_add, 'Sticker (F5)', 'sticker', activeTool == 'sticker'),
                  _buildToolBtn(Icons.gesture, 'Pen', 'pen', activeTool == 'pen'),
                  _buildToolBtn(Icons.add_photo_alternate, 'Pic (F17)', 'pic', activeTool == 'pic'),
                  _buildToolBtn(Icons.dashboard_customize, 'Reorder (F11)', 'reorder', activeTool == 'reorder'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwatch(Color color, bool isActive) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isActive ? Border.all(color: AppTheme.primary, width: 2) : null,
        ),
      ),
    );
  }

  Widget _buildToolBtn(IconData icon, String label, String toolId, bool isActive) {
    return GestureDetector(
      onTap: () => onToolSelected(toolId),
      child: Container(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isActive ? Colors.white : AppTheme.textPrimaryLight),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppTheme.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
