class Folder {
  final String id;
  String name;
  final String? parentFolderId;
  final DateTime createdAt;

  Folder({
    required this.id,
    required this.name,
    this.parentFolderId,
    required this.createdAt,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      parentFolderId: json['parentFolderId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentFolderId': parentFolderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
