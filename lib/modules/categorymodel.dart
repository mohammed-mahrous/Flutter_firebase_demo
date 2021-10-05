class CategoryModel {
  final String? id;
  final String name;

  CategoryModel({this.id, required this.name});

  factory CategoryModel.fromJson(documentid, Map<String, dynamic> json) {
    return CategoryModel(id: documentid, name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  String toString() {
    return {'id': id, 'name': name}.toString();
  }
}
