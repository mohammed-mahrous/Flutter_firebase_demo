import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/modules/productmodel.dart';

class FireDataBase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference categroyRef;
  late CollectionReference productRef;

  FireDataBase() {
    categroyRef = _db.collection('category').withConverter<CategoryModel>(
          fromFirestore: (snapshot, options) =>
              CategoryModel.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (category, options) => category.toJson(),
        );

    productRef =
        _db.collection('category.products').withConverter<ProductModel>(
              fromFirestore: (snapshot, opts) =>
                  ProductModel.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (product, opts) => product.toJson(),
            );
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      debugPrint('trying to add category: $category to database');
      await categroyRef.add(category);
      debugPrint('successfull operation');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addProduct(categoryId, ProductModel product) async {
    try {
      debugPrint('trying to add product: $product to database');
      await productRef.add(product);
      debugPrint('successfull operation');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateCategory(String id, map) async {
    await categroyRef.doc(id).update(map);
  }

  Future<void> deleteCategory(String id) async {
    await categroyRef
        .doc(id)
        .collection('products')
        .get()
        .then((value) => value.docs.clear());

    await categroyRef.doc(id).delete();
  }

  Future<void> updateProduct(String id, map) async {
    await productRef.doc(id).update(map);
  }

  Future<void> deleteProduct(String id) async {
    await productRef.doc(id).delete();
  }

  Stream<List<CategoryModel>>? getAllCategroies() {
    try {
      debugPrint('getting data');

      return categroyRef.snapshots().map((snapShot) {
        return snapShot.docs.map((document) {
          print(document.data().toString());
          return document.data() as CategoryModel;
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<ProductModel>>? getAllProducts(categoryId) {
    try {
      debugPrint('getting data');

      return productRef
          .where('categoryId', isEqualTo: categoryId)
          .snapshots()
          .map((snapShot) {
        return snapShot.docs.map((document) {
          print(document.data().toString());
          return document.data() as ProductModel;
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
