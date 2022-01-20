import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';

class Filters extends Equatable{

  Category catagory;
  Category subCategory;
  TextEditingController createdDateController;
  String createdDate;

  Filters({this.catagory,this.subCategory,this.createdDateController,this.createdDate}){
    createdDateController.text = createdDate;
  }

  @override
  // TODO: implement props
  List<Object> get props => [this.catagory,this.subCategory,this.createdDateController,this.createdDate];
}