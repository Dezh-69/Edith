import 'package:flutter/material.dart';

import '../../services/file_service.dart';
import '../../services/local_storage_service.dart';
import '../../models/edith_file.dart';
import 'package:uuid/uuid.dart';

class ConverterPane extends StatefulWidget {
  const ConverterPane({super.key});

  @override
  State<ConverterPane> createState() => _ConverterPaneState();
}

class _ConverterPaneState extends State<ConverterPane> {
  final FileService _fileService = FileService();
  final LocalStorageService _storage = LocalStorageService();
  
  String _selectedFormat = 'PDF';
  String _fidelityMode = 'exact';
  EdithFile? _sourceFile;
  bool _isConverting = false;

  Future<void> _pickSourceFile() async {
    final file = await _fileService.pickAndImportFile();
    if (file != null) {
      setState(() => _sourceFile = file);
    }
  }

  Future<void> _startConversion() async {
    if (_sourceFile == null) return;
    setState(() => _isConverting = true);
    
    // Simulate conversion delay
    await Future.delayed(const Duration(seconds: 2));
    
    final newType = _selectedFormat.toLowerCase();
    final newName = '${_sourceFile!.displayName.split('.').first}_converted.$newType';
    
    final convertedFile = EdithFile(
      id: const Uuid().v4(),
      displayName: newName,
      path: _sourceFile!.path, // reusing path since it's just a simulation
      type: newType,
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: _sourceFile!.sizeBytes,
    );
    
    _storage.addFile(convertedFile);
    
    setState(() {
      _isConverting = false;
      _sourceFile = null;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Converted to $newName! Find it in your library.')),
      );
    }
  }

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
              // Card Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Format Conversion Studio', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text('Client-orchestrated LibreOffice engine', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424843))),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7E8E6), // surface-container-high
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sync_alt, color: Color(0xFF163824), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Source File Selection Tile
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F1), // surface-container-low
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF163824),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description, color: Color(0xFFF9FAF7), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_sourceFile?.displayName ?? 'No file selected', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (_sourceFile != null)
                            Text('${_sourceFile!.type.toUpperCase()} • ${FileService.formatFileSize(_sourceFile!.sizeBytes)}', style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF424843))),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _pickSourceFile,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEDEEEB),
                        foregroundColor: const Color(0xFF191C1B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 28),
                      ),
                      child: Text(_sourceFile == null ? 'Select' : 'Change', style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Target Format Selector
              Text('CONVERT OUTPUT TARGET', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF424843), letterSpacing: 1.1)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildFormatTarget('PDF', Icons.picture_as_pdf, 'PDF/A-2b')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFormatTarget('DOCX', Icons.article, 'Office Open')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFormatTarget('IMAGES', Icons.photo_library, 'PNG 300DPI')),
                ],
              ),
              const SizedBox(height: 24),
              // Engine Tuning Toggle & Radios
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CONVERSION ENGINE PARAMETER', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF424843), letterSpacing: 1.1)),
                  Text('LibreOffice Core v7.6', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF326A38), fontFamily: 'JetBrains Mono')),
                ],
              ),
              const SizedBox(height: 8),
              _buildFidelityRadio(
                'exact',
                'Preserve Layout Fidelity (Exact)',
                'Maintains pagination, academic footnotes, inline diagrams, and exact typographic leading.',
              ),
              const SizedBox(height: 8),
              _buildFidelityRadio(
                'clean',
                'Extract Readable Content Only (Clean)',
                'Strips watermarks and multi-column wrappers; optimized for mobile reading and margin synthesis.',
              ),
              const SizedBox(height: 24),
              // Primary Action
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: (_sourceFile == null || _isConverting) ? null : _startConversion,
                  icon: _isConverting 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.play_arrow),
                  label: Text(_isConverting ? 'Converting...' : 'Start Conversion & Save to Library'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF163824),
                    foregroundColor: const Color(0xFFF9FAF7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                    disabledBackgroundColor: const Color(0xFF163824).withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatTarget(String format, IconData icon, String subtitle) {
    final theme = Theme.of(context);
    final isActive = _selectedFormat == format;

    return InkWell(
      onTap: () => setState(() => _selectedFormat = format),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF163824) : const Color(0xFFEDEEEB),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))] : [],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: isActive ? const Color(0xFFF9FAF7) : const Color(0xFF191C1B)),
            const SizedBox(height: 4),
            Text(
              format,
              style: theme.textTheme.labelMedium?.copyWith(color: isActive ? const Color(0xFFF9FAF7) : const Color(0xFF191C1B)),
            ),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                fontFamily: 'JetBrains Mono',
                color: isActive ? const Color(0xFFF9FAF7).withValues(alpha: 0.8) : const Color(0xFF424843),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFidelityRadio(String value, String title, String subtitle) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _fidelityMode = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEEEB), // surface-container
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _fidelityMode == value ? const Color(0xFF163824) : const Color(0xFF424843),
                  width: 2,
                ),
              ),
              child: _fidelityMode == value
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF163824),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF191C1B))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424843), height: 1.2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
