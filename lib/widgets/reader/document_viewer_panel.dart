import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/edith_file.dart';
import '../sticker_sheet.dart';
import '../redaction_sticker.dart';
import 'metadata_sub_bar.dart';
import 'floating_annotation_toolbar.dart';
import '../../screens/notes_panel.dart';
import '../../services/local_storage_service.dart';

class DocumentViewerPanel extends StatefulWidget {
  final EdithFile file;
  final bool showDesktopSidebar;

  const DocumentViewerPanel({
    super.key,
    required this.file,
    this.showDesktopSidebar = true,
  });

  @override
  State<DocumentViewerPanel> createState() => _DocumentViewerPanelState();
}

class _DocumentViewerPanelState extends State<DocumentViewerPanel> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final List<Key> _stickerSheets = [];
  final List<Key> _redactionStickers = [];
  bool _lockedDrawingMode = false;
  bool _showNotesTray = false;
  String _activeTool = 'highlight';
  Color _activeColor = const Color(0xFFFCD34D);

  void _onToolSelected(String toolId) {
    if (toolId == 'sticker') {
      _addStickerSheet();
      return;
    }
    if (toolId == 'blind') {
      _addRedactionSticker();
      return;
    }
    setState(() => _activeTool = toolId);
  }

  void _addStickerSheet() {
    setState(() => _stickerSheets.add(UniqueKey()));
  }
  void _removeStickerSheet(Key key) {
    setState(() => _stickerSheets.remove(key));
  }
  void _addRedactionSticker() {
    setState(() => _redactionStickers.add(UniqueKey()));
  }
  void _removeRedactionSticker(Key key) {
    setState(() => _redactionStickers.remove(key));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildDocumentView() {
      if (widget.file.type == 'word') {
        return Container(
          color: const Color(0xFFE5E5E5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.description, size: 64, color: Colors.black26),
                const SizedBox(height: 16),
                Text('Word format conversion pending (v2)', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.black26)),
              ],
            ),
          ),
        );
      }

      if (widget.file.path == 'dummy' || widget.file.path.startsWith('web://')) {
        return Container(
          color: const Color(0xFFE5E5E5),
          child: Center(
            child: Text(
              widget.file.path.startsWith('web://') 
                  ? 'Web preview not supported for local files' 
                  : 'Placeholder Document Canvas', 
              style: theme.textTheme.headlineMedium?.copyWith(color: Colors.black26)
            ),
          ),
        );
      }

      if (widget.file.type == 'pdf') {
        return SfPdfViewer.file(
          File(widget.file.path),
          key: _pdfViewerKey,
          canShowScrollHead: false,
          canShowScrollStatus: false,
        );
      }

      return InteractiveViewer(
        child: Image.file(File(widget.file.path)),
      );
    }

    final documentView = Stack(
      children: [
        Positioned.fill(
          child: buildDocumentView(),
        ),
        if (_lockedDrawingMode) const StickerSheet(isFullscreen: true),
        for (final key in _stickerSheets)
          StickerSheet(key: key, onClose: () => _removeStickerSheet(key)),
        for (final key in _redactionStickers)
          RedactionSticker(key: key, onClose: () => _removeRedactionSticker(key)),
        if (_activeTool == 'reorder')
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.95),
              child: _buildPageReorderOverlay(),
            ),
          ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        
        if (isDesktop && widget.showDesktopSidebar) {
          return Column(
            children: [
              MetadataSubBar(
                fileName: widget.file.displayName,
                isDrawingLocked: _lockedDrawingMode,
                onToggleLock: () => setState(() => _lockedDrawingMode = !_lockedDrawingMode),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          documentView,
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: FloatingAnnotationToolbar(
                              activeTool: _activeTool,
                              activeColor: _activeColor,
                              onToolSelected: _onToolSelected,
                              onColorSelected: (color) => setState(() => _activeColor = color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 360,
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: theme.colorScheme.outlineVariant)),
                        color: const Color(0xFFF3F4F1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            color: const Color(0xFFEDEEEB),
                            child: Row(
                              children: [
                                const Icon(Icons.sticky_note_2, color: Color(0xFF163824), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${LocalStorageService().getNotesForFile(widget.file.id).length} Notes Attached',
                                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: NotesPanel(fileId: widget.file.id)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Mobile View or Desktop without sidebar
        return Column(
          children: [
            MetadataSubBar(
              fileName: widget.file.displayName,
              isDrawingLocked: _lockedDrawingMode,
              onToggleLock: () => setState(() => _lockedDrawingMode = !_lockedDrawingMode),
            ),
            Expanded(
              child: Stack(
                children: [
                  documentView,
                  // Notes Drawer Context Banner
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _showNotesTray = !_showNotesTray),
                          child: Container(
                            color: const Color(0xFFEDEEEB),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.sticky_note_2, color: Color(0xFF163824), size: 18),
                                    const SizedBox(width: 8),
                                    Text('${LocalStorageService().getNotesForFile(widget.file.id).length} Notes Attached', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('#MidtermExam', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF163824), fontFamily: 'JetBrains Mono', fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('View', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF163824), fontWeight: FontWeight.bold)),
                                    Icon(_showNotesTray ? Icons.expand_less : Icons.expand_more, size: 16, color: const Color(0xFF163824)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_showNotesTray)
                          Container(
                            color: const Color(0xFFF3F4F1),
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: NotesPanel(fileId: widget.file.id),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FloatingAnnotationToolbar(
                      activeTool: _activeTool,
                      activeColor: _activeColor,
                      onToolSelected: _onToolSelected,
                      onColorSelected: (color) => setState(() => _activeColor = color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageReorderOverlay() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFEDEEEB),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Page Reorder Mode (Drag to rearrange)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _activeTool = 'highlight'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFC2C8C0)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
                ),
                child: Center(
                  child: Text('Page ${index + 1}', style: theme.textTheme.labelMedium?.copyWith(color: Colors.black26)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
