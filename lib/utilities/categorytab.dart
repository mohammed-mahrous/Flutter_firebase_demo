import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/modules/categorymodel.dart';
import 'package:flutter_firebase_app/pages/categorypage.dart';
import 'package:flutter_firebase_app/services/firedatabase.dart';

class CategroyTab extends StatefulWidget {
  const CategroyTab({Key? key, this.selected = false, required this.category})
      : super(key: key);
  final bool selected;
  final CategoryModel category;
  @override
  _CategroyTabState createState() => _CategroyTabState();
}

class _CategroyTabState extends State<CategroyTab> {
  bool editingmode = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget textbuttonchild = Text(widget.category.name);
    VoidCallback? callback = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryPage(category: widget.category),
        ),
      );
    };
    if (widget.selected) {
      callback = null;
      textbuttonchild = Text(
        widget.category.name,
        style: const TextStyle(color: Colors.black),
      );
    }

    Widget categoryTab = SizedBox(
      width: 150,
      child: TextButton(
        onPressed: callback,
        child: textbuttonchild,
      ),
    );
    if (editingmode) {
      _controller.text = widget.category.name;
      categoryTab = SizedBox(
        width: 150,
        height: 50,
        child: Form(
            key: formkey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide())),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field required';
                      }
                      if (value == widget.category.name) {
                        return 'changes required';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 50,
                  child: TextButton(
                    child: const Icon(
                      Icons.save,
                    ),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        var name = _controller.text;
                        debugPrint(name);
                        await FireDataBase().updateCategory(
                            widget.category.id!, {'name': name});
                        setState(() {
                          editingmode = !editingmode;
                        });
                      }
                    },
                  ),
                )
              ],
            )),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryTab,
        const Spacer(),
        SizedBox(
          width: 50.0,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.white)),
              onPressed: () {
                setState(() {
                  editingmode = !editingmode;
                });
              },
              child: Icon(
                Icons.edit_outlined,
                color: Colors.blue[600],
                size: 25.0,
              )),
        ),
        SizedBox(
          width: 50.0,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.white)),
              onPressed: () async {
                debugPrint('trying to delete category');
                await FireDataBase().deleteCategory(widget.category.id!);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 25.0,
              )),
        ),
      ],
    );
  }
}
