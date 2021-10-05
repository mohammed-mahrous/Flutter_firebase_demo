// import 'dart:io';

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/modules/productmodel.dart';
import 'package:flutter_firebase_app/pages/product_edit_page.dart';
import 'package:flutter_firebase_app/services/firedatabase.dart';
import 'package:flutter_firebase_app/utilities/drawer.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);
  final CategoryModel category;
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late bool addproduct = false;
  final productNamecontoller = TextEditingController();
  final productPricecontoller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // final _picker = ImagePicker();
  // var _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    productNamecontoller.dispose();
    productPricecontoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).orientation;
    bool mainaxis = screen == Orientation.landscape;
    String? categoryid = widget.category.id;
    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        if (addproduct) {
          return const SizedBox();
        }
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              addproduct = true;
            });
          },
          tooltip: 'add a new product',
          child: const Icon(
            Icons.add,
          ),
        );
      }),
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      drawer: MyDrawer(
        screen: screen,
        id: categoryid,
      ),
      body: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamProvider<List<ProductModel>>(
          create: (context) => FireDataBase().getAllProducts(categoryid),
          initialData: const [],
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Consumer<List<ProductModel>>(
              builder: (context, snapshot, child) {
                List<ProductModel> productlist = snapshot;
                if (addproduct == false) {
                  return Builder(
                    builder: (context) {
                      if (productlist.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('no products was found on this category'),
                              Text('add products to this category so that'),
                              Text('you can view them here'),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          mainAxisExtent: 400,
                          crossAxisCount: mainaxis ? 2 : 1,
                        ),
                        itemCount: productlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('name: ${productlist[index].name}'),
                                    Text("price: \$${productlist[index].price}")
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 5,
                              ),
                              SizedBox(
                                child: const Center(
                                  child: Text('photo here'),
                                ),
                                height: mainaxis ? 200 : 250,
                                width: mainaxis ? 200 : 200,
                              ),
                              const Divider(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 5),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductEditPage(
                                                            product:
                                                                productlist[
                                                                    index])));
                                          },
                                          child: const Icon(Icons.edit)),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: TextButton(
                                          onPressed: () async {
                                            var productId =
                                                productlist[index].id;

                                            await FireDataBase()
                                                .deleteProduct(productId!);
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ));
                        },
                      );
                    },
                  );
                }
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  return SingleChildScrollView(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Add Product',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue[800]),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Form(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 50,
                                        child: Text('Name: '),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: productNamecontoller,
                                          decoration: InputDecoration(
                                              fillColor:
                                                  const Color(0xFFFFFFFF),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(),
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'name field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 50,
                                        child: Text('Price: '),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: productPricecontoller,
                                          decoration: InputDecoration(
                                              fillColor:
                                                  const Color(0xFFFFFFFF),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(),
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'price field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     SizedBox(
                                  //       height: 100,
                                  //       width: 80,
                                  //       child: _image != null
                                  //           ? Image.file(
                                  //               _image,
                                  //               height: 100,
                                  //               width: 100,
                                  //             )
                                  //           : Container(),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 20,
                                  //     ),
                                  //     ElevatedButton(
                                  //       onPressed: () async {
                                  //         XFile? image = await _picker.pickImage(
                                  //             source: ImageSource.gallery,
                                  //             imageQuality: 50,
                                  //             preferredCameraDevice:
                                  //                 CameraDevice.front);
                                  //         if (image != null) {
                                  //           setState(() {
                                  //             _image = File(image.path);
                                  //           });
                                  //         }
                                  //       },
                                  //       child: Icon(Icons.filter),
                                  //     ),
                                  //     SizedBox(width: 10),
                                  //     ElevatedButton(
                                  //       onPressed: () async {
                                  //         XFile? image = await _picker.pickImage(
                                  //             source: ImageSource.camera,
                                  //             imageQuality: 50,
                                  //             preferredCameraDevice:
                                  //                 CameraDevice.front);
                                  //         if (image != null) {
                                  //           setState(() {
                                  //             _image = File(image.path);
                                  //           });
                                  //         }
                                  //       },
                                  //       child: Icon(Icons.camera_alt),
                                  //     )
                                  //   ],
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            addproduct = false;
                                            productNamecontoller.text = '';
                                            productPricecontoller.text = '';
                                            // _image = null;
                                          });
                                        },
                                        child: const Text('cancel'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            var name =
                                                productNamecontoller.text;
                                            var price = int.parse(
                                                productPricecontoller.text);

                                            FireDataBase().addProduct(
                                                categoryid,
                                                ProductModel(
                                                    name: name,
                                                    categoryId: categoryid!,
                                                    price: price));

                                            setState(() {
                                              productNamecontoller.text = '';
                                              productPricecontoller.text = '';
                                              addproduct = false;
                                            });
                                          }
                                        },
                                        child: const Text('submit'),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              key: _formkey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Add Product',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.blue[800]),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                  child: Text('Name: '),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: productNamecontoller,
                                    decoration: InputDecoration(
                                        fillColor: const Color(0xFFFFFFFF),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(),
                                        )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'name field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                const SizedBox(
                                  width: 50,
                                  child: Text('Price: '),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: productPricecontoller,
                                    decoration: InputDecoration(
                                        fillColor: const Color(0xFFFFFFFF),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(),
                                        )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'price field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Spacer(
                                  flex: 8,
                                )
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SizedBox(
                            //       height: 50,
                            //       width: 50,
                            //       child: Container(),
                            //     ),
                            //     MaterialButton(
                            //       onPressed: () {},
                            //       child: Text('pick an image'),
                            //     )
                            //   ],
                            // ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      productNamecontoller.text = '';
                                      productPricecontoller.text = '';
                                      addproduct = false;
                                    });
                                  },
                                  child: const Text('cancel'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      var name = productNamecontoller.text;
                                      var price =
                                          int.parse(productPricecontoller.text);

                                      FireDataBase().addProduct(
                                          categoryid,
                                          ProductModel(
                                              name: name,
                                              categoryId: categoryid!,
                                              price: price));

                                      setState(() {
                                        productNamecontoller.text = '';
                                        productPricecontoller.text = '';
                                        addproduct = false;
                                      });
                                    }
                                  },
                                  child: const Text('submit'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
