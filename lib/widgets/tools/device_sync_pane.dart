import 'package:flutter/material.dart';

class DeviceSyncPane extends StatelessWidget {
  const DeviceSyncPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // surface-container-lowest
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pairing Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zero-Account Sync (F12)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text('End-to-end encrypted cryptographic session', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424843))),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB1EFB0), // secondary-container
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.key, color: Color(0xFF366E3C), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 6-Digit Pairing Code Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F1), // surface-container-low
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'DESKTOP PAIRING CODE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFamily: 'JetBrains Mono',
                        color: const Color(0xFF424843),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCodeBox('8', theme),
                        const SizedBox(width: 6),
                        _buildCodeBox('4', theme),
                        const SizedBox(width: 6),
                        _buildCodeBox('9', theme),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('-', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 24, color: Color(0xFF727972))),
                        ),
                        _buildCodeBox('2', theme),
                        const SizedBox(width: 6),
                        _buildCodeBox('1', theme),
                        const SizedBox(width: 6),
                        _buildCodeBox('9', theme),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, size: 14, color: Color(0xFF452D00)),
                        const SizedBox(width: 4),
                        Text(
                          'Session expires in 14:22',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'JetBrains Mono',
                            color: const Color(0xFF452D00),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Quick QR Scan Block
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEB), // surface-container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                      ),
                      child: Icon(Icons.qr_code_2, size: 60, color: const Color(0xFF163824)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fast Pairing via Laptop Cam', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424843), height: 1.3),
                              children: [
                                const TextSpan(text: 'Open '),
                                TextSpan(
                                  text: 'edith.app/pair',
                                  style: TextStyle(fontFamily: 'JetBrains Mono', color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
                                ),
                                const TextSpan(text: ' on your browser and point your webcam here.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Live Infrastructure Status Telemetry
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SYNC MESH STATUS', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF424843), letterSpacing: 1.1)),
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF326A38), shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Encrypted (AES-GCM)', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF326A38), fontFamily: 'JetBrains Mono')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F1), // surface-container-low
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cloud_done, size: 16, color: Color(0xFF326A38)),
                            const SizedBox(width: 6),
                            Text('Firebase Firestore Metadata', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF191C1B))),
                          ],
                        ),
                        Text('Connected (0ms)', style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF191C1B), fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storage, size: 16, color: Color(0xFF424843)),
                            const SizedBox(width: 6),
                            Text('Backblaze B2 Archival Storage', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF191C1B))),
                          ],
                        ),
                        Text('3.8 GB / 10 GB', style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF424843))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Storage Gauge
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEEEB),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.38,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF163824),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Recovery Code Action
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text('View Printed Backup Recovery Sheet'),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEDEEEB),
                    foregroundColor: const Color(0xFF191C1B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(String char, ThemeData theme) {
    return Container(
      width: 36,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: theme.textTheme.titleLarge?.copyWith(
          fontFamily: 'JetBrains Mono',
          color: const Color(0xFF163824),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
