import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/add_item/add_product.dart';
import 'package:merch/admin/add_item/add_product_controller.dart';
import 'package:merch/bloc/product/product_bloc.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/models/product_model.dart';

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
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return state.products.isNotEmpty? ListView(
                    children: state.products.map((product) => productListItem(context,product))
                        .toList(),
                  ):const Center(child: Text('No Product Found',style: TextStyle(color: Colors.black),));
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
          )
        ],
      ),
    );
  }


  Widget productListItem(context, Product product){
    return InkWell(
      onTap: (){
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical*1.5,
            horizontal: SizeConfig.blockSizeHorizontal*2),
        child: Center(child: Text(product.name,style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5,fontWeight: FontWeight.w500,color: appBlack))),
      ),
    );
  }
}
