import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:edith/services/cloud_storage_service.dart';
import 'package:edith/models/edith_file.dart';
import 'package:http/http.dart' as http;
import 'mock_generator.mocks.dart';

void main() {
  late CloudStorageService service;
  late MockFirebaseFirestore mockFirestore;
  late MockClient mockHttpClient;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockHttpClient = MockClient();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);
    when(mockDocRef.set(any)).thenAnswer((_) async => {});

    service = CloudStorageService(
      firestore: mockFirestore,
      httpClient: mockHttpClient,
    );
  });

  group('CloudStorageService Unit Tests', () {
    test('cloud_storage_upload_validMetadata_savesToFirestore', () async {
      final file = EdithFile(
        id: '123',
        displayName: 'Test.pdf',
        path: '/dummy',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 100,
      );

      final result = await service.uploadFile(
        file, 
        diskFile: null,
      );

      expect(result, true);
      verify(mockFirestore.collection('files')).called(1);
      verify(mockCollection.doc('123')).called(1);
      verify(mockDocRef.set(file.toJson())).called(1);
    });

    test('cloud_storage_download_validResponse_writesFile', () async {
      // Mocking HTTP response
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('file bytes', 200));

      final file = EdithFile(
        id: '123',
        displayName: 'Test.pdf',
        path: '/dummy',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 100,
      );

      // Test the logic that triggers HTTP get.
      // If it throws an unhandled error here, the test correctly fails.
      await service.downloadFile(
        file, 
        'test/unit/services/dummy_download.txt',
        downloadUrl: 'https://test',
        token: 'token',
      );
      
      verify(mockHttpClient.get(any, headers: anyNamed('headers'))).called(1);
    });
    
    test('cloud_storage_download_networkLoss_returnsFalse', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      final file = EdithFile(
        id: '123',
        displayName: 'Test.pdf',
        path: '/dummy',
        type: 'pdf',
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: 100,
      );

      final result = await service.downloadFile(
        file, 
        'dummy_path',
        downloadUrl: 'https://test',
        token: 'token',
      );
      expect(result, false);
    });
  });
}
