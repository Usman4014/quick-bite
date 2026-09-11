// ignore_for_file: file_names

class FixedAssetModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final bool isActive;

  const FixedAssetModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.isActive,
  });

  factory FixedAssetModel.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return FixedAssetModel(
      id: documentId,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}