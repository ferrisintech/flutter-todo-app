import 'package:flutter/material.dart';

import 'package:scrumme/models/list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';


class AddListDialog extends StatefulWidget {
  const AddListDialog({Key? key}) : super(key: key);

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}


class _AddListDialogState extends State<AddListDialog> {

 late TextEditingController _listNameTextController;
 late Box<CategoryModel> categoryModelBox = Hive.box('catBox');

 //uid uuid = const Uuid();

 late String idlist;

  @override
  void initState() {
    super.initState();
    _listNameTextController = TextEditingController();
  }

  @override
  void dispose() {
    _listNameTextController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Center(
              child: Text(
                "Create a List",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
              )),
          const SizedBox(
            height: 20,
          ),
          TextField(
            maxLength: 12,
            maxLines: 1,
            controller: _listNameTextController,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDialogCancelButton(),
              _buildDialogCreateListButton(categoryModelBox),
            ],
          ),
        ],
      );

  }

_buildDialogCancelButton() {
  return ElevatedButton(
    onPressed: () {
      _listNameTextController.clear();
      Navigator.of(context).pop();
    },
    child: const Text("Cancel"),
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      primary: Colors.red,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      textStyle: const TextStyle(
        fontSize: 15,
      ),
    ),
  );
}


_buildDialogCreateListButton(Box<CategoryModel> catBox) {
  return ElevatedButton(
    onPressed: () {
      if(_listNameTextController.text.isEmpty){

      }else{
        setState(() {
          const uuid = Uuid();
          idlist = uuid.v4();

          CategoryModel categoryModel = CategoryModel(list_id: idlist, list_title: _listNameTextController.text);
          catBox.add(categoryModel);

        });

        _listNameTextController.clear();
        Navigator.of(context).pop();
      }
    },

    child: const Text("Create"),
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      primary: Colors.green,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      textStyle: const TextStyle(
        fontSize: 17,
      ),
    ),
  );
}


}






