import 'package:flutter/material.dart';

class MetadataSubBar extends StatelessWidget {
  final String fileName;
  final bool isDrawingLocked;
  final VoidCallback onToggleLock;
  
  const MetadataSubBar({
    super.key, 
    required this.fileName,
    required this.isDrawingLocked,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryContainer = Color(0xFF163824);
    const surfaceContainerLow = Color(0xFFF3F4F1);
    const onSurfaceVariant = Color(0xFF424843);
    const outlineVariant = Color(0xFFC2C8C0);

    return Container(
      color: surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.menu_book, size: 18, color: primaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fileName,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontFamily: 'JetBrains Mono',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            'P. 14 / 42',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 10,
                              color: onSurfaceVariant,
                            ),
                          ),
                          _buildDot(outlineVariant),
                          Text(
                            '125%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 10,
                              color: primaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _buildDot(outlineVariant),
                          const Icon(Icons.pinch, size: 12, color: onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(
                            'Pinch active',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggleLock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDrawingLocked ? primaryContainer : const Color(0xFFF9FAF7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
              ),
              child: Row(
                children: [
                  Icon(
                    isDrawingLocked ? Icons.lock : Icons.lock_open,
                    size: 14,
                    color: isDrawingLocked ? Colors.white : primaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDrawingLocked ? 'Draw: Locked' : 'Draw: Free',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDrawingLocked ? Colors.white : primaryContainer,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDrawingLocked ? const Color(0xFFB4F2B3) : const Color(0xFF727972),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
