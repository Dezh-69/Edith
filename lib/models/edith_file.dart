class EdithFile {
  final String id;
  String displayName;
  final String path;
  final String type; // 'pdf', 'image', or 'word'
  String? parentFolderId;
  final DateTime createdAt;
  DateTime lastOpenedAt;
  final int sizeBytes;

  EdithFile({
    required this.id,
    required this.displayName,
    required this.path,
    required this.type,
    this.parentFolderId,
    required this.createdAt,
    required this.lastOpenedAt,
    required this.sizeBytes,
  });

  factory EdithFile.fromJson(Map<String, dynamic> json) {
    return EdithFile(
      id: json['id'],
      displayName: json['displayName'],
      path: json['path'],
      type: json['type'],
      parentFolderId: json['parentFolderId'],
      createdAt: DateTime.parse(json['createdAt']),
      lastOpenedAt: DateTime.parse(json['lastOpenedAt']),
      sizeBytes: json['sizeBytes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'path': path,
      'type': type,
      'parentFolderId': parentFolderId,
      'createdAt': createdAt.toIso8601String(),
      'lastOpenedAt': lastOpenedAt.toIso8601String(),
      'sizeBytes': sizeBytes,
    };
  }
}
