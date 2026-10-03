import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/folder.dart';

class FileManagementDialogs {
  /// Show rename dialog. Returns the new name if confirmed, or null if cancelled.
  static Future<String?> showRenameDialog(BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context, newName);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show move to folder dialog. Returns the selected folder ID, or null if cancelled/root selected.
  static Future<String?> showMoveToFolderDialog(BuildContext context, List<Folder> folders) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to Folder'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Root Directory'),
                onTap: () => Navigator.pop(context, ''), // Using empty string to represent root
              ),
              const Divider(),
              ...folders.map((folder) => ListTile(
                leading: const Icon(Icons.folder),
                title: Text(folder.name),
                onTap: () => Navigator.pop(context, folder.id),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog. Returns true if confirmed.
  static Future<bool> showDeleteConfirmDialog(BuildContext context, String itemName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Are you sure you want to delete "$itemName"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
