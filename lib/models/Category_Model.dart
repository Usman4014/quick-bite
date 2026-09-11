// ignore_for_file: file_names

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isActive,
  });

  factory CategoryModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }
}