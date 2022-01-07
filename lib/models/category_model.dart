import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String uId;
  final String description;
  final bool isEnabled;
  final bool isSubCategory;
  final String catId;

  const Category({
    this.name,
    this.description,
    this.isEnabled,
    this.isSubCategory,
    this.catId,
    this.uId
  });

  @override
  List<Object> get props => [
        name,
        description,
        isEnabled,
        isSubCategory,
        catId,
        uId
      ];

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
        name: snap['name'],
        description: snap['description'],
        isEnabled: snap['isEnabled'],
        isSubCategory: snap['isSubCategory'],
        catId: snap['catId'],
        uId: snap['uId']
    );
    return category;
  }
}
