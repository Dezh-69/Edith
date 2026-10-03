import 'package:flutter/material.dart';

import '../../services/image_input_service.dart';

class OcrScannerPane extends StatefulWidget {
  const OcrScannerPane({super.key});

  @override
  State<OcrScannerPane> createState() => _OcrScannerPaneState();
}

class _OcrScannerPaneState extends State<OcrScannerPane> {
  final ImageInputService _imageInputService = ImageInputService();
  bool _isProcessing = false;
  String _extractedText = '### Section 4.2: Cellular Respiration\n\nGlycolysis initiates the metabolic pathway within the cytoplasm, cleaving a six-carbon hexose glucose molecule into two three-carbon pyruvate molecules without molecular oxygen requirements...';

  Future<void> _captureImage() async {
    setState(() => _isProcessing = true);
    final file = await _imageInputService.captureAndImportImage();
    if (file != null) {
      // In a real app we'd wait for OCR to finish and get the text.
      // Here we simulate getting the text for the preview.
      setState(() {
        _extractedText = 'Successfully captured ${file.displayName} and queued OCR analysis.';
        _isProcessing = false;
      });
    } else {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // Camera Viewfinder with Edge Recognition Simulation
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF2E312F),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Stack(
                children: [
                  // Ambient Image
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVp6dpkx-vdJcwb1RwIPbTsGSXAYySsf-DSL3YHyXIFVrJAgRMzh3OR3Gzu2fQ4-UXmG9YynPp_2JtkbiBqpmUVo-v35pH6tPSvVtuloDatiKAToES1SItwc_RgncPWXWD6u7WTFh_D4KBSzC1evJVxXAIvad6OropnZHpEMcmU6wVYYfgvDvGVMXJmFt_AWLdbstkC2fDJITUETBoA9iIsClmg_praz6gEqTJzqbfhX9wwPgJv0b',
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.luminosity,
                      ),
                    ),
                  ),
                  // ML Edge Detection Overlay
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB4F2B3).withValues(alpha: 0.05),
                        border: Border.all(color: const Color(0xFFB4F2B3).withValues(alpha: 0.2), width: 1),
                      ),
                      child: Stack(
                        children: [
                          Positioned(top: 0, left: 0, child: _buildCorner(isTop: true, isLeft: true)),
                          Positioned(top: 0, right: 0, child: _buildCorner(isTop: true, isLeft: false)),
                          Positioned(bottom: 0, left: 0, child: _buildCorner(isTop: false, isLeft: true)),
                          Positioned(bottom: 0, right: 0, child: _buildCorner(isTop: false, isLeft: false)),
                          Center(
                            child: Container(
                              height: 2,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, Color(0xFFB4F2B3), Colors.transparent],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Top Overlay Bar
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E312F).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB4F2B3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ML Kit: 4 Vertices Locked',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFFF9FAF7),
                                  fontFamily: 'JetBrains Mono',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E312F).withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flash_on, color: Color(0xFFF9FAF7), size: 18),
                        ),
                      ],
                    ),
                  ),
                  // Bottom Overlay Trigger Panel
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E312F).withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_fix_high, color: Color(0xFFF9FAF7), size: 15),
                              const SizedBox(width: 4),
                              Text('De-skew: Active', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFFF9FAF7))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _isProcessing ? null : _captureImage,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB4F2B3),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: _isProcessing 
                                ? const CircularProgressIndicator(color: Color(0xFF163824))
                                : const Icon(Icons.photo_camera, color: Color(0xFF163824), size: 24),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E312F).withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.crop, color: Color(0xFFF9FAF7), size: 15),
                              const SizedBox(width: 4),
                              Text('Manual Crop', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFFF9FAF7))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Live Extracted Text Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // surface-container-lowest
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified, color: Color(0xFF326A38), size: 18),
                          const SizedBox(width: 6),
                          Text('Extracted Text Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E8E6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Google ML Kit',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'JetBrains Mono',
                            color: const Color(0xFF7DA288),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Language & Precision Meta
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEEEB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.translate, size: 13, color: Color(0xFF326A38)),
                            const SizedBox(width: 4),
                            Text(
                              'English (Latin v2.4)',
                              style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF424843)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1EFB0).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.analytics, size: 13, color: Color(0xFF366E3C)),
                            const SizedBox(width: 4),
                            Text(
                              '99.4% Confidence',
                              style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF366E3C)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Formatted Output Snippet
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F1),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(left: BorderSide(color: Color(0xFF326A38), width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MARKDOWN STREAM',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'JetBrains Mono',
                            color: const Color(0xFF424843),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _extractedText,
                          style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF191C1B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Footer
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.content_copy, size: 16),
                          label: const Text('Copy Snippet'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF191C1B),
                            side: const BorderSide(color: Color(0xFFC2C8C0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.note_add, size: 16),
                          label: const Text('Save as Note (F3)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF163824),
                            foregroundColor: const Color(0xFFF9FAF7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download, size: 14),
                      label: const Text('Export raw .TXT format'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF424843),
                        textStyle: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFFB4F2B3), width: 2) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFFB4F2B3), width: 2) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFFB4F2B3), width: 2) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFFB4F2B3), width: 2) : BorderSide.none,
        ),
      ),
    );
  }
}
