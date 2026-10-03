import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';
import '../theme/app_theme.dart';

class NotesPanel extends StatefulWidget {
  final String fileId;
  const NotesPanel({super.key, required this.fileId});

  @override
  State<NotesPanel> createState() => _NotesPanelState();
}

class _NotesPanelState extends State<NotesPanel> {
  final LocalStorageService _storage = LocalStorageService();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _labelsController = TextEditingController();
  
  List<Note> get _notes => _storage.getNotesForFile(widget.fileId);

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;
    
    List<String> labels = _labelsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final note = Note(
      id: const Uuid().v4(),
      fileId: widget.fileId,
      text: _noteController.text.trim(),
      labels: labels,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _storage.addNote(note);
    _noteController.clear();
    _labelsController.clear();
    setState(() {});
  }

  void _deleteNote(String id) {
    _storage.removeNote(id);
    setState(() {});
  }

  @override
  void dispose() {
    _noteController.dispose();
    _labelsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
                    border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            note.createdAt.toString().substring(0, 16),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 16, color: AppTheme.errorColor),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _deleteNote(note.id),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(note.text, style: Theme.of(context).textTheme.bodyMedium),
                      if (note.labels.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          children: note.labels
                              .map((l) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(l, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.primary, fontFamily: 'JetBrains Mono', fontSize: 10)),
                                  ))
                              .toList(),
                        )
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a note...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _labelsController,
                  decoration: InputDecoration(
                    hintText: 'Labels (comma separated)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
                    ),
                    onPressed: _addNote,
                    child: const Text('Add Note'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
