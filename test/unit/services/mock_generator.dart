import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([FirebaseFirestore, http.Client, CollectionReference, DocumentReference, QuerySnapshot, QueryDocumentSnapshot])
void main() {}
