import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/models/category_model.dart';

class Filters extends Equatable{

  Category category;
  Category subCategory;
  TextEditingController createdDateController;
  String createdDate;

  Filters({this.category,this.subCategory,this.createdDateController,this.createdDate}){
    createdDateController.text = createdDate;
  }

  @override
  List<Object> get props => [category,subCategory,createdDateController,createdDate];
}