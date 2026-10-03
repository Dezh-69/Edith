import 'package:flutter/material.dart';

class ActiveStudySessionCard extends StatelessWidget {
  const ActiveStudySessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Colors from Stitch design
    const bgContainer = Color(0xFF452D00); // tertiary-container
    const onBgContainer = Color(0xFFCA8E17); // on-tertiary-container
    const tertiaryFixed = Color(0xFFFFDEAE); 
    const tertiaryFixedDim = Color(0xFFFDBA45);
    const secondaryFixed = Color(0xFFB4F2B3);
    const secondaryFixedDim = Color(0xFF98D599);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          // Background circle accent
          Positioned(
            right: -16,
            bottom: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onBgContainer.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: tertiaryFixedDim,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ACTIVE STUDY SESSION',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: tertiaryFixed,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1A00),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Midterm Due in 3d',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: onBgContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Cell Biology: Chapter 7 Redactions',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '8 active recall mask prompts remain unreviewed for today\'s cadence.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: tertiaryFixed.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        _buildOverlapAvatar('Q1', secondaryFixed, Colors.black),
                        _buildOverlapAvatar('Q2', secondaryFixedDim, Colors.black),
                        _buildOverlapAvatar('+6', tertiaryFixed, Colors.black),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Spaced Repetition Active',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: tertiaryFixedDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tertiaryFixed,
                      foregroundColor: const Color(0xFF281900),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('Review', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverlapAvatar(String text, Color bgColor, Color textColor) {
    return Transform.translate(
      offset: const Offset(-4, 0),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF452D00), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
