import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edith/services/local_storage_service.dart';
import 'package:edith/models/edith_file.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LocalStorageService service;

  setUp(() async {
    // Mock shared preferences
    SharedPreferences.setMockInitialValues({});
    
    // We need to recreate the singleton for clean state, 
    // but Dart singletons are tricky to reset in tests.
    // For test purposes, LocalStorageService could ideally take a param, 
    // but we will work with the singleton and clear it.
    service = LocalStorageService();
    await service.init();
    
    // Clear state
    for (var f in service.files) {
      service.removeFile(f.id);
    }
  });

  group('LocalStorageService Unit Tests', () {
    test('local_storage_create_validFile_appearsInList', () {
      final file = EdithFile(
        id: '1',
        displayName: 'Test File.pdf',
        path: '/dummy/path.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      );

      service.addFile(file);

      expect(service.files.length, 1);
      expect(service.files.first.id, '1');
      expect(service.files.first.displayName, 'Test File.pdf');
    });

    test('local_storage_rename_validName_updatesName', () {
      final file = EdithFile(
        id: '1',
        displayName: 'Old Name.pdf',
        path: '/dummy/path.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      );

      service.addFile(file);
      service.renameFile('1', 'New Name.pdf');

      expect(service.files.first.displayName, 'New Name.pdf');
    });

    test('local_storage_move_validFolder_updatesFolderId', () {
      final file = EdithFile(
        id: '1',
        displayName: 'File.pdf',
        path: '/dummy/path.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      );

      service.addFile(file);
      service.moveFileToFolder('1', 'folder-123');

      expect(service.files.first.parentFolderId, 'folder-123');
    });

    test('local_storage_delete_validId_removesFromList', () {
      final file = EdithFile(
        id: '1',
        displayName: 'File.pdf',
        path: '/dummy/path.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      );

      service.addFile(file);
      service.removeFile('1');

      expect(service.files.isEmpty, true);
    });

    test('local_storage_search_partialMatch_returnsResults', () {
      service.addFile(EdithFile(
        id: '1',
        displayName: 'Lecture1.pdf',
        path: '/dummy/path1.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      ));
      service.addFile(EdithFile(
        id: '2',
        displayName: 'Notes.pdf',
        path: '/dummy/path2.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      ));

      final results = service.searchFiles('lecture');
      expect(results.length, 1);
      expect(results.first.displayName, 'Lecture1.pdf');
    });

    test('local_storage_search_noResults_returnsEmpty', () {
      service.addFile(EdithFile(
        id: '1',
        displayName: 'Lecture1.pdf',
        path: '/dummy/path1.pdf',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 1024,
      ));

      final results = service.searchFiles('xyz');
      expect(results.isEmpty, true);
    });

    test('local_storage_filter_byType_returnsOnlyType', () {
      service.addFile(EdithFile(id: '1', displayName: '1.pdf', path: '1', type: 'pdf', createdAt: DateTime.now(), lastOpenedAt: DateTime.now(), sizeBytes: 100));
      service.addFile(EdithFile(id: '2', displayName: '2.png', path: '2', type: 'image', createdAt: DateTime.now(), lastOpenedAt: DateTime.now(), sizeBytes: 100));

      final results = service.filterFiles(type: 'pdf');
      expect(results.length, 1);
      expect(results.first.id, '1');
    });

    test('local_storage_filter_bySize_returnsMatchingSize', () {
      service.addFile(EdithFile(id: '1', displayName: '1', path: '1', type: 'pdf', createdAt: DateTime.now(), lastOpenedAt: DateTime.now(), sizeBytes: 50));
      service.addFile(EdithFile(id: '2', displayName: '2', path: '2', type: 'pdf', createdAt: DateTime.now(), lastOpenedAt: DateTime.now(), sizeBytes: 200));

      final results = service.filterFiles(minSizeBytes: 100);
      expect(results.length, 1);
      expect(results.first.id, '2');
    });
  });
}
