import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/services/firedatabase.dart';
import 'package:flutter_firebase_app/utilities/categorytab.dart';

import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
    required this.screen,
    this.id,
  }) : super(key: key);

  final Orientation screen;
  final String? id;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  // late Animation _animation;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CategoryModel>>(
      create: (context) => FireDataBase().getAllCategroies(),
      initialData: const [],
      child: Drawer(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: DrawerBody(
                widget: widget,
                focusNode: _focusNode,
              ),
            ),
          )),
    );
  }
}

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key? key,
    required this.widget,
    required FocusNode focusNode,
    // required this.widget,
  })  : _focusNode = focusNode,
        super(key: key);

  final MyDrawer widget;
  final FocusNode _focusNode;
  // final MyDrawer widget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          children: [
            const DrawerHeader(
              child: Center(child: Text('image here')),
            ),
            const SizedBox(height: 30),
            Consumer<List<CategoryModel>>(builder: (context, snapshot, child) {
              TextEditingController editingController = TextEditingController();
              double hight = widget.screen == Orientation.landscape ? 200 : 300;
              List<CategoryModel> categorylist = snapshot;
              return ExpansionTile(
                initiallyExpanded: false,
                title: const Text('categories'),
                leading: const Icon(Icons.category_rounded),
                children: [
                  SizedBox(
                      height: hight,
                      child: Builder(
                        builder: (BuildContext context) {
                          if (categorylist.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Spacer(),
                                  Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                          'no categories created yet')),
                                  const Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // height: _animation.value,
                                        width: 150,
                                        margin: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                          focusNode: _focusNode,
                                          // key: _thisformkey,
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            fillColor: const Color(0xFFFFFFFF),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                color: Colors.blue[200]!,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                          ),
                                          controller: editingController,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          if (editingController.text != '' ||
                                              editingController
                                                  .text.isNotEmpty) {
                                            var name = editingController.text;
                                            await FireDataBase().addCategory(
                                                CategoryModel(name: name));
                                          }
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text('add '),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: hight - 100,
                                child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: categorylist.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Widget categoryTab = CategroyTab(
                                        category: categorylist[index]);

                                    // ignore: unrelated_type_equality_checks
                                    if (categorylist[index].id == widget.id) {
                                      categoryTab = CategroyTab(
                                        category: categorylist[index],
                                        selected: true,
                                      );
                                    }
                                    return categoryTab;
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: TextFormField(
                                      focusNode: _focusNode,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        fillColor: const Color(0xFFFFFFFF),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.blue[200]!,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      controller: editingController,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        if (editingController.text != '' ||
                                            editingController.text.isNotEmpty) {
                                          var name = editingController.text;
                                          await FireDataBase().addCategory(
                                              CategoryModel(name: name));
                                        }
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('add '),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      )),
                ],
              );
            }),
          ],
        ));
  }
}
