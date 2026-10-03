import 'package:flutter/material.dart';

import '../../services/file_service.dart';
import '../../services/local_storage_service.dart';
import '../../models/edith_file.dart';
import 'package:uuid/uuid.dart';

class MergeFilesPane extends StatefulWidget {
  const MergeFilesPane({super.key});

  @override
  State<MergeFilesPane> createState() => _MergeFilesPaneState();
}

class _MergeFilesPaneState extends State<MergeFilesPane> {
  final FileService _fileService = FileService();
  final LocalStorageService _storage = LocalStorageService();
  
  final List<EdithFile> _sourceFiles = [];
  bool _isMerging = false;

  Future<void> _addSourceFile() async {
    final file = await _fileService.pickAndImportFile();
    if (file != null) {
      setState(() => _sourceFiles.add(file));
    }
  }

  void _removeFile(int index) {
    setState(() => _sourceFiles.removeAt(index));
  }

  void _reorderFiles(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final file = _sourceFiles.removeAt(oldIndex);
      _sourceFiles.insert(newIndex, file);
    });
  }

  Future<void> _startMerge() async {
    if (_sourceFiles.length < 2) return;
    setState(() => _isMerging = true);
    
    // Simulate merge delay
    await Future.delayed(const Duration(seconds: 2));
    
    final newName = '${_sourceFiles.first.displayName.split('.').first}_merged.pdf';
    
    final mergedFile = EdithFile(
      id: const Uuid().v4(),
      displayName: newName,
      path: _sourceFiles.first.path, // reusing path since it's just a simulation
      type: 'pdf',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: _sourceFiles.fold(0, (sum, f) => sum + f.sizeBytes),
    );
    
    _storage.addFile(mergedFile);
    
    setState(() {
      _isMerging = false;
      _sourceFiles.clear();
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Merged into $newName! Find it in your library.')),
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
            color: Colors.white,
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
                      Text('Merge Documents', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text('Combine multiple files into one PDF', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424843))),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7E8E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call_merge, color: Color(0xFF163824), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Source Files List
              Text('FILES TO MERGE (Drag to reorder)', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF424843), letterSpacing: 1.1)),
              const SizedBox(height: 8),
              if (_sourceFiles.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE7E8E6), style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: Text('No files selected yet.', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF424843))),
                  ),
                )
              else
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sourceFiles.length,
                  onReorder: _reorderFiles,
                  itemBuilder: (context, index) {
                    final file = _sourceFiles[index];
                    return Container(
                      key: ValueKey(file.id),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.drag_handle, color: Color(0xFF424843)),
                        title: Text(file.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('${file.type.toUpperCase()} • ${FileService.formatFileSize(file.sizeBytes)}', style: theme.textTheme.labelSmall?.copyWith(fontFamily: 'JetBrains Mono', color: const Color(0xFF424843))),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _removeFile(index),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              // Add File Button
              Center(
                child: TextButton.icon(
                  onPressed: _addSourceFile,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Document'),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEDEEEB),
                    foregroundColor: const Color(0xFF191C1B),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Primary Action
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: (_sourceFiles.length < 2 || _isMerging) ? null : _startMerge,
                  icon: _isMerging 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.call_merge),
                  label: Text(_isMerging ? 'Merging...' : 'Merge Documents'),
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
}
