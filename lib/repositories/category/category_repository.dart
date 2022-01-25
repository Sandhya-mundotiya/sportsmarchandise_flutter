import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:merch/bloc/add_category/add_category_bloc.dart';
import 'package:merch/bloc/edit_category/edit_category_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/firestore_constants.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/models/category_model.dart';
import 'package:merch/repositories/category/base_category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({
    FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Category>> getAllCategories() {
    return _firebaseFirestore
        .collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(CATEGORY_TABLE)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }

  @override
  addCategories({Category categoryOb,BuildContext context}) {
    CollectionReference reference = _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(CATEGORY_TABLE);

     reference
        .add(categoryOb.toJson())
        .then((value){
         context.read<AddCategoryBloc>().add(CategoryAddedSuccessfully());

         if(categoryOb.catId != ""){
           snac("Sub Category Created",success: true);
         }else{
           snac("Category Created",success: true);
         }

    })
        .catchError((error) => print("Failed to add Category: $error"));
  }

  @override
  updateCategoryOrSubCategory({Category category,EditCategoryBloc bloc}) {
    print(category.description);
   _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(CATEGORY_TABLE).doc(category.uId).update(
       {
         'description': category.description,
         "catId": category.catId,
         "name": category.name,
       },
       )
       .then((value){
           print("Category Updated");
          bloc.add(HideLoader());

          if(category.isSubCategory) snac("Category Updated Successfully",success: true);
          else snac("Sub Category Updated Successfully",success: true);

       })
       .catchError((error) => print("Failed to update category: $error"));


  }

  @override
  enableOrDisableCategory({String uid, EditCategoryBloc bloc, bool isEnable, String type}) {
     _firebaseFirestore.collection(SCHOOL_TABLE).doc(SchoolData.schoolId).collection(CATEGORY_TABLE).doc(uid).update(
      {
        'isEnabled': isEnable,
      },
    )
        .then((value){
      bloc.add(HideLoader());
      if(isEnable) snac("$type Enabled Successfully",success: true);
      else snac("$type Disabled Successfully",success: true);
    })
        .catchError((error) => print("Failed to update category: $error"));

  }


}












