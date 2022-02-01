import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String catId;
  final List<String> images;
  final String uid;
  final String price;
  final int createdDate;
  final String description;
  final int lastBought;
  final int sold;
  final String stockQty;
  final bool isEnabled;

  const Product({
    this.name = "",
    this.stockQty = "",
    this.createdDate = 0,
    this.uid = "",
    this.catId = "",
    this.images,
    this.price = "",
    this.description = "",
    this.lastBought = 0,
    this.sold = 0,
    this.isEnabled = true
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "category": catId,
    "images": images,
    "price": price,
    "createdDate": createdDate,
    "description": description,
    "lastBought": lastBought,
    "sold": sold,
    "stockQty": stockQty,
    "isEnabled" : isEnabled
  };

  static Product fromSnapshot(DocumentSnapshot snap) {


    Product product = Product(
      name: snap['name'],
      catId: snap['category'],
      images: snap['images'] != null ? snap['images'].cast<String>() : [],
      createdDate: snap['createdDate'],
      price: snap['price'],
      description: snap['description'],
      lastBought: snap['lastBought'],
      sold: snap['sold'],
      uid: snap.id,
      stockQty:snap['stockQty'],
        isEnabled :snap['isEnabled']
    );

    return product;
  }

  Product copyWith({
     String name,
     String catId,
     List<String> images,
     String uid,
     String price,
     int createdDate,
     String description,
    int lastBought,
     int sold,
     String stockQty,
    bool isEnabled
  }) {


    List<String> tempImages = [];
    if(images == null){
      if(this.images != null) tempImages.addAll(this.images);
    }else if(images != null){
      tempImages.addAll(images);
    }

    return Product(
      name: name ?? this.name,
      catId: catId ?? this.catId,
      images: tempImages,
      uid: uid ?? this.uid,
      price: price ?? this.price,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
      lastBought: lastBought ?? this.lastBought,
      sold: sold ?? this.sold,
      stockQty: stockQty ?? this.stockQty,
      isEnabled: isEnabled ?? this.isEnabled
    );
  }

  @override
  List<Object> get props => [
        name,
        catId,
        images,
        price,
        description,
        lastBought,
        sold,
        uid,
        stockQty,isEnabled
      ];
}
