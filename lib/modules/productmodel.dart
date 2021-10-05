class ProductModel {
  final String? id;
  final String name;
  final int price;
  final String categoryId;

  ProductModel(
      {this.id,
      required this.name,
      required this.categoryId,
      required this.price});

  factory ProductModel.fromJson(documentid, Map<String, dynamic> json) {
    return ProductModel(
      id: documentid,
      name: json['name'],
      price: json['price'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'categoryId': categoryId};
  }

  @override
  String toString() {
    return {'id': id, 'name': name, 'price': price, 'categoryId': categoryId}
        .toString();
  }
}
