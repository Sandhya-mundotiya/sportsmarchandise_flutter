import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductHistoryModel extends Equatable {
  final String name;
  final String image;
  final String uid;
  final String price;
  final String description;
  final String productId;
  final String userId;
  final String stripePaymentId;
  final String stripeClientSecretId;
  final String stripeAmount;
  final int createdAt;
  final String adminId;
  final String catId;

  const ProductHistoryModel({
    this.name,
    this.uid,
    this.price,
    this.description,
    this.image,
    this.productId,
    this.userId,
    this.stripePaymentId,
    this.stripeClientSecretId,
    this.stripeAmount,
    this.createdAt,
    this.adminId,
    this.catId
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "price": price,
    "description": description,
    "productId" : productId,
    "userId" : userId,
    "stripePaymentId" : stripePaymentId,
    "stripeClientSecretId" : stripeClientSecretId,
    "stripeAmount" : stripeAmount,
    "createdAt" : createdAt,
    "adminId" : adminId,
    "catId" : catId,
  };

  static ProductHistoryModel fromSnapshot(DocumentSnapshot snap) {


    ProductHistoryModel product = ProductHistoryModel(
        name: snap['name'],
        image: snap['image'],
        price: snap['price'],
        description: snap['description'],
        uid: snap.id,
      productId :snap['productId'],
      userId :snap['userId'],
      stripePaymentId :snap['stripePaymentId'],
      stripeClientSecretId :snap['stripeClientSecretId'],
      stripeAmount :snap['stripeAmount'],
      createdAt :snap['createdAt'],
      adminId :snap['adminId'],
      catId :snap['catId'],
    );

    return product;
  }

  ProductHistoryModel copyWith({
    String name,
    String image,
    String uid,
    String price,
    String description,
    bool productId,
    bool userId,
    bool stripePaymentId,
    bool stripeClientSecretId,
    String stripeAmount,
    int createdAt,
    String adminId,
    String catId,
  }) {

    return ProductHistoryModel(
        name: name ?? this.name,
        image: image ?? this.image,
        uid: uid ?? this.uid,
        price: price ?? this.price,
        description: description ?? this.description,
        productId: productId ?? this.productId,
        userId: userId ?? this.userId,
        stripePaymentId: stripePaymentId ?? this.stripePaymentId,
        stripeClientSecretId: stripeClientSecretId ?? this.stripeClientSecretId,
        stripeAmount: stripeAmount ?? this.stripeAmount,
    createdAt: createdAt ?? this.createdAt,
    adminId: adminId ?? this.adminId,
      catId: catId ?? this.catId,
    );
  }

  @override
  List<Object> get props => [
    name,
    image,
    price,
    description,
    uid,
    productId,userId,stripePaymentId,stripeClientSecretId,stripeAmount,createdAt,adminId
  ];
}
