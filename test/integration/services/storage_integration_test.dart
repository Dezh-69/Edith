import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edith/services/local_storage_service.dart';
import 'package:edith/services/cloud_storage_service.dart';
import 'package:edith/models/edith_file.dart';
import 'package:mockito/mockito.dart';
import '../../unit/services/mock_generator.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LocalStorageService localStorage;
  late CloudStorageService cloudStorage;
  late MockFirebaseFirestore mockFirestore;
  late MockClient mockHttpClient;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localStorage = LocalStorageService();
    await localStorage.init();

    // Clear state
    for (var f in localStorage.files.toList()) {
      localStorage.removeFile(f.id);
    }

    mockFirestore = MockFirebaseFirestore();
    mockHttpClient = MockClient();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);
    when(mockDocRef.set(any)).thenAnswer((_) async => {});

    cloudStorage = CloudStorageService(
      firestore: mockFirestore,
      httpClient: mockHttpClient,
    );
  });

  test('integration_fileLifecycle_createRenameMoveUploadDelete', () async {
    // 1. Create a file
    final file = EdithFile(
      id: 'int-123',
      displayName: 'Integration.pdf',
      path: '/dummy/int.pdf',
      type: 'pdf',
      createdAt: DateTime.now(),
      lastOpenedAt: DateTime.now(),
      sizeBytes: 2048,
    );
    localStorage.addFile(file);
    expect(localStorage.files.length, 1);

    // 2. Rename the file
    localStorage.renameFile('int-123', 'Integration_Renamed.pdf');
    expect(localStorage.files.first.displayName, 'Integration_Renamed.pdf');

    // 3. Move to folder
    localStorage.moveFileToFolder('int-123', 'folder-x');
    expect(localStorage.files.first.parentFolderId, 'folder-x');

    // 4. Upload file metadata
    final uploadSuccess = await cloudStorage.uploadFile(localStorage.files.first);
    expect(uploadSuccess, true);
    verify(mockFirestore.collection('files')).called(1);

    // 5. Delete file
    localStorage.removeFile('int-123');
    expect(localStorage.files.isEmpty, true);
  });
}
