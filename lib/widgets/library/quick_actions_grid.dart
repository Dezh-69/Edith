import 'package:flutter/material.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const surfaceVariant = Color(0xFF424843);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SCHOLARLY TOOLING',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: surfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Desktop Hotkeys Active',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: surfaceVariant,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _buildActionCard(context, Icons.photo_camera, 'Scan Camera', 'Press F8'),
            _buildActionCard(context, Icons.upload_file, 'Import File', 'PDF / DOCX'),
            _buildActionCard(context, Icons.note_alt, 'Sticker Board', 'Freeform Notes'),
            _buildActionCard(context, Icons.call_merge, 'Merge Files', 'Press F10'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    const primaryContainer = Color(0xFF163824);
    const surfaceContainer = Color(0xFFEDEEEB);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryContainer, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF424843),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
