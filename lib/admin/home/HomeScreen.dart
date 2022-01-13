import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/admin/addItem/AddProduct.dart';
import 'package:merch/admin/addItem/AddProductController.dart';
import 'package:merch/main.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({Key key,this.schoolId}) : super(key: key);
  String schoolId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed:(){
        getIt.registerSingleton<AddProductModel>(AddProductController());
        Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen(schoolId: schoolId)));
      },child: const Icon(Icons.add,color: Colors.white)),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(),
    );
  }
}
