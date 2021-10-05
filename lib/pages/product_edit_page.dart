import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/modules/productmodel.dart';
import 'package:flutter_firebase_app/services/firedatabase.dart';
import 'package:flutter_firebase_app/utilities/drawer.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductEditPage extends StatefulWidget {
  const ProductEditPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  late CategoryModel category;
  late var dropdownvalue = widget.product.categoryId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();

    var screen = MediaQuery.of(context).orientation;
    return Scaffold(
      drawer: MyDrawer(screen: screen),
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Form(
          key: formkey,
          child: columnformBody(context, screen),
        ),
      ),
    );
  }

  Widget columnformBody(BuildContext context, screen) {
    if (screen == Orientation.portrait) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          StreamProvider<List<CategoryModel>>(
            create: (context) => FireDataBase().getAllCategroies(),
            initialData: const [],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<List<CategoryModel>>(
                        builder: (context, snapshot, child) {
                      List<CategoryModel> categorylist = snapshot;
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Builder(
                          builder: (BuildContext context) {
                            if (categorylist.isNotEmpty) {
                              return SizedBox(
                                width: 150,
                                height: 60,
                                child: DropdownButtonFormField(
                                  dropdownColor: Colors.white,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(),
                                    ),
                                  ),
                                  onChanged: (dynamic newvalue) {
                                    setState(() {
                                      dropdownvalue = newvalue!;
                                    });
                                  },
                                  value: dropdownvalue,
                                  items: categorylist.map((category) {
                                    return DropdownMenuItem(
                                      child: Text(category.name),
                                      value: category.id,
                                    );
                                  }).toList(),
                                ),
                              );
                            }

                            return SizedBox(
                              width: 50,
                              child: DropdownButtonFormField(
                                value: 'nodata',
                                items: const [
                                  DropdownMenuItem(
                                      value: 'nodata', child: Text('nodata'))
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'this field is required';
                }
                if (value == widget.product.name &&
                    _priceController.text == widget.product.price.toString() &&
                    dropdownvalue == widget.product.categoryId) {
                  return 'changes are required to save the product';
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('cancel')),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      String updatedName = _nameController.text;
                      int updatedPrice = int.parse(_priceController.text);
                      String? updatedCategoryid = dropdownvalue;
                      String? productid = widget.product.id;

                      await FireDataBase().updateProduct(productid!, {
                        'categoryId': updatedCategoryid,
                        'name': updatedName,
                        'price': updatedPrice,
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('save'))
            ],
          ),
          const Spacer(),
        ],
      );
    }
    return GridView.count(
      crossAxisSpacing: 1,
      mainAxisSpacing: 2,
      crossAxisCount: 4,
      children: [
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'this field is required';
                  }
                  if (value == widget.product.name &&
                      _priceController.text ==
                          widget.product.price.toString() &&
                      dropdownvalue == widget.product.categoryId) {
                    return 'changes are required to save the product';
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('cancel')),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        String updatedName = _nameController.text;
                        int updatedPrice = int.parse(_priceController.text);
                        String? updatedCategoryid = dropdownvalue;
                        String? productid = widget.product.id;

                        await FireDataBase().updateProduct(productid!, {
                          'categoryId': updatedCategoryid,
                          'name': updatedName,
                          'price': updatedPrice,
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('save'))
              ],
            ),
          ],
        ),
        StreamProvider<List<CategoryModel>>(
          create: (c) => FireDataBase().getAllCategroies(),
          initialData: const [],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Consumer<List<CategoryModel>>(
                      builder: (BuildContext context, snapshot, child) {
                        List<CategoryModel> categorylist = snapshot;
                        if (snapshot.isNotEmpty) {
                          return SizedBox(
                            width: 150,
                            height: 60,
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(),
                                ),
                              ),
                              onChanged: (dynamic newvalue) {
                                setState(() {
                                  dropdownvalue = newvalue!;
                                });
                              },
                              value: dropdownvalue,
                              items: categorylist.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category.name),
                                  value: category.id,
                                );
                              }).toList(),
                            ),
                          );
                        }

                        return SizedBox(
                          width: 50,
                          child: DropdownButtonFormField(
                            value: 'nodata',
                            items: const [
                              DropdownMenuItem(
                                  value: 'nodata', child: Text('nodata'))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
