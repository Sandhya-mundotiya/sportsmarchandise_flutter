import 'package:equatable/equatable.dart';
import 'package:merch/constants/string_constant.dart';
import 'package:merch/models/category_model.dart';

class Filters extends Equatable{

  Category catagory;
  Category subCategory;

  Filters({this.catagory,this.subCategory});

  @override
  // TODO: implement props
  List<Object> get props => [this.catagory,this.subCategory];
}