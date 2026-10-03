class Note {
  final String id;
  final String fileId;
  String text;
  int? pageNumber;
  List<String> labels;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.fileId,
    required this.text,
    this.pageNumber,
    required this.labels,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      fileId: json['fileId'],
      text: json['text'],
      pageNumber: json['pageNumber'],
      labels: List<String>.from(json['labels'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileId': fileId,
      'text': text,
      'pageNumber': pageNumber,
      'labels': labels,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
