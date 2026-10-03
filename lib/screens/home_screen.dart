import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/edith_file.dart';
import '../models/folder.dart';
import '../services/local_storage_service.dart';
import '../services/file_service.dart';
import 'document_viewer_screen.dart';
import 'split_screen.dart';
import 'tools_screen.dart';

import '../widgets/library/active_study_session_card.dart';
import '../widgets/library/storage_gauge_card.dart';
import '../widgets/library/quick_actions_grid.dart';
import '../widgets/library/document_card.dart';
import '../widgets/library/custom_bottom_nav_bar.dart';
import '../widgets/library/file_management_dialogs.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorageService _storage = LocalStorageService();
  final FileService _fileService = FileService();
  
  String? _currentFolderId;
  int _currentNavIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_storage.isInitialized) {
      await _storage.init();
    }
    setState(() {});
  }

  Future<void> _importFile() async {
    final file = await _fileService.pickAndImportFile(parentFolderId: _currentFolderId);
    if (file != null) {
      setState(() {});
      _openFile(file);
    }
  }

  void _openFile(EdithFile file) {
    file.lastOpenedAt = DateTime.now();
    _storage.updateFile(file);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerScreen(file: file),
      ),
    );
  }

  void _openDummyFile() {
    final dummy = EdithFile(
      id: const Uuid().v4(),
      displayName: 'Cell_Biology_Ch7_Membranes.pdf',
      path: 'dummy',
      type: 'pdf',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: 14200000,
    );
    _openFile(dummy);
  }

  void _showFileMenu(EdithFile file) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () async {
                Navigator.pop(context);
                final newName = await FileManagementDialogs.showRenameDialog(context, file.displayName);
                if (newName != null) {
                  _storage.renameFile(file.id, newName);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text('Move to Folder'),
              onTap: () async {
                Navigator.pop(context);
                final folderId = await FileManagementDialogs.showMoveToFolderDialog(context, _storage.folders);
                if (folderId != null) {
                  _storage.moveFileToFolder(file.id, folderId.isEmpty ? null : folderId);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.errorColor),
              title: const Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await FileManagementDialogs.showDeleteConfirmDialog(context, file.displayName);
                if (confirm) {
                  await _fileService.deleteFile(file);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavTap(int idx) {
    setState(() {
      _currentNavIndex = idx;
    });
    if (idx == 1) {
      _openDummyFile();
    } else if (idx == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SplitScreen()),
      ).then((_) {
        setState(() {
          _currentNavIndex = 0;
        });
      });
    } else if (idx == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ToolsScreen()),
      ).then((_) {
        setState(() {
          _currentNavIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTabletOrDesktop = width > 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.95),
              elevation: 0,
              title: Row(
                children: [
                  Image.asset('assets/logo.png', height: 32, errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book, color: Colors.white)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edith',
                        style: TextStyle(
                          color: AppTheme.lightBackground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Library',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary.withValues(alpha: 0.8),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (isTabletOrDesktop)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Paired • B2 Active',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.lightBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isTabletOrDesktop)
            CustomNavRail(
              currentIndex: _currentNavIndex,
              onTap: _handleNavTap,
            ),
          if (isDesktop)
            Container(
              width: 280,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: AppTheme.textMuted.withValues(alpha: 0.2))),
                color: theme.colorScheme.surface,
              ),
              child: ListView(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('INDEX / BINDER', style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.textMuted, letterSpacing: 1.1)),
                        IconButton(
                          icon: const Icon(Icons.create_new_folder, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            final folderName = await FileManagementDialogs.showRenameDialog(context, '');
                            if (folderName != null && folderName.isNotEmpty) {
                              _storage.addFolder(Folder(
                                id: const Uuid().v4(),
                                name: folderName,
                                createdAt: DateTime.now(),
                              ));
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.all_inbox, color: AppTheme.primary),
                    title: Text('All Documents', style: theme.textTheme.titleSmall),
                    selected: _currentFolderId == null,
                    selectedTileColor: AppTheme.secondary.withValues(alpha: 0.1),
                    onTap: () {
                      setState(() => _currentFolderId = null);
                    },
                  ),
                  const Divider(),
                  ..._storage.folders.map((folder) => ListTile(
                    leading: const Icon(Icons.folder, color: AppTheme.primary),
                    title: Text(folder.name, style: theme.textTheme.titleSmall),
                    selected: _currentFolderId == folder.id,
                    selectedTileColor: AppTheme.secondary.withValues(alpha: 0.1),
                    onTap: () {
                      setState(() => _currentFolderId = folder.id);
                    },
                    onLongPress: () async {
                      // Show rename/delete for folder
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Rename Folder'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  final newName = await FileManagementDialogs.showRenameDialog(context, folder.name);
                                  if (newName != null) {
                                    _storage.renameFolder(folder.id, newName);
                                    setState(() {});
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete, color: AppTheme.errorColor),
                                title: const Text('Delete Folder', style: TextStyle(color: AppTheme.errorColor)),
                                onTap: () async {
                                  Navigator.pop(context);
                                  final confirm = await FileManagementDialogs.showDeleteConfirmDialog(context, folder.name);
                                  if (confirm) {
                                    _storage.removeFolder(folder.id);
                                    if (_currentFolderId == folder.id) _currentFolderId = null;
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 80,
                bottom: isTabletOrDesktop ? 120 : 120, // space for nav + FAB
                left: 16,
                right: 16,
              ),
              children: [
                const ActiveStudySessionCard(),
                const SizedBox(height: 16),
                const StorageGaugeCard(),
                const SizedBox(height: 16),
                const QuickActionsGrid(),
                const SizedBox(height: 24),
                // Search & Filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0,1))],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: AppTheme.textMuted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search annotations, transcripts...',
                                  hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '⌘K',
                                style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.textPrimaryLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0,1))],
                      ),
                      child: const Icon(Icons.tune, size: 20, color: AppTheme.textPrimaryLight),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _buildFilterChip('All (18)', true),
                      _buildFilterChip('#Bio201 (6)', false),
                      _buildFilterChip('#Chem302 (4)', false),
                      _buildFilterChip('#Hist110 (5)', false),
                      _buildFilterChip('#LabNotes (3)', false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Study Documents',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Sorted by recent edit',
                      style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // High Fidelity Document Cards
                LayoutBuilder(builder: (context, constraints) {
                  final files = _storage.searchFiles(_searchQuery)
                      .where((f) => f.parentFolderId == _currentFolderId)
                      .toList()
                    ..sort((a, b) => b.lastOpenedAt.compareTo(a.lastOpenedAt));

                  if (files.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'No documents found.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
                        ),
                      ),
                    );
                  }

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: files.map((file) {
                      final metadata = '${FileService.formatFileSize(file.sizeBytes)} • Edited ${FileService.formatRelativeTime(file.lastOpenedAt)}';
                      final icon = file.type == 'pdf' ? Icons.picture_as_pdf : (file.type == 'word' ? Icons.description : Icons.image);
                      final iconLabel = file.type.toUpperCase();

                      return SizedBox(
                        width: isDesktop ? (constraints.maxWidth / 2) - 8 : constraints.maxWidth,
                        child: HighFidelityDocumentCard(
                          title: file.displayName,
                          metadata: metadata,
                          icon: icon,
                          iconLabel: iconLabel,
                          badges: const [],
                          onTap: () => _openFile(file),
                          onMoreTap: () => _showFileMenu(file),
                        ),
                      );
                    }).toList(),
                  );
                }),
                
                // Ambient Tip
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_stories, color: AppTheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Marginalia Pro-Tip', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(
                              'Tap any paragraph twice in Split View to create an Active Recall flashcard instantly.',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.textPrimaryLight),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: isTabletOrDesktop ? 16.0 : 72.0),
        child: FloatingActionButton(
          onPressed: _importFile,
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      bottomNavigationBar: isTabletOrDesktop 
          ? null 
          : CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _handleNavTap,
            ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primary : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive ? [] : const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0,1))],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppTheme.textPrimaryLight,
        ),
      ),
    );
  }

}
