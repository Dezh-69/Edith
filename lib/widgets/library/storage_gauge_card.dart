import 'package:flutter/material.dart';

class StorageGaugeCard extends StatelessWidget {
  const StorageGaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const surfaceContainerLow = Color(0xFFF3F4F1);
    const primaryContainer = Color(0xFF163824);
    const secondary = Color(0xFF326A38);
    const secondaryContainer = Color(0xFFB1EFB0);
    const outline = Color(0xFF727972);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cloud_sync, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Backblaze B2 Storage',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Auto-save active (every 5 min)',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: outline,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '38% Quota',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.38,
              minHeight: 8,
              backgroundColor: Color(0xFFE2E3E0),
              valueColor: AlwaysStoppedAnimation<Color>(primaryContainer),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3.8 GB of 10 GB free tier used',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: outline,
                  fontSize: 10,
                ),
              ),
              Text(
                '6.2 GB available',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF366E3C),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
