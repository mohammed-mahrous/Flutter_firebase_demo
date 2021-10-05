import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/services/firedatabase.dart';

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add category'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Form(
            key: _formkey,
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty || value == '') {
                          return 'name field is required';
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true)),
                ),
                const Spacer(),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        String name = nameController.text;
                        try {
                          await FireDataBase()
                              .addCategory(CategoryModel(name: name));
                          Navigator.pop(context);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }
                    },
                    child: const Text('Add'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
