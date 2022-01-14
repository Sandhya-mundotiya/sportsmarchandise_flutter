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
  final double lastBought;
  final int sold;
  final String stockQty;

  const Product({
    this.name,
    this.stockQty,
    this.createdDate,
    this.uid,
    this.catId,
    this.images,
    this.price,
    this.description,
    this.lastBought,
    this.sold
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
  };

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      name: snap['name'],
      catId: snap['category'],
      images: snap['imageUrl'],
      price: snap['price'],
      description: snap['description'],
      lastBought: snap['lastBought'],
      sold: snap['sold'],
      uid: snap.id,
      stockQty:snap['stockQty']
    );
    return product;
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
        stockQty
      ];
}
