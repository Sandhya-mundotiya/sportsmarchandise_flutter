import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String catId;
  final List<String> imageUrl;
  final String uid;
  final double price;
  final String description;
  final double lastBought;
  final int sold;
  final String stockQty;


  const Product({
    this.name,
    this.stockQty,
    this.uid,
    this.catId,
    this.imageUrl,
    this.price,
    this.description,
    this.lastBought,
    this.sold
  });

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      name: snap['name'],
      catId: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      description: snap['description'],
      lastBought: snap['lastBought'],
      sold: snap['sold'],
      uid: snap['uid'],
      stockQty:snap['stockQty']
    );
    return product;
  }

  @override
  List<Object> get props => [
        name,
        catId,
        imageUrl,
        price,
        description,
        lastBought,
        sold,
        uid,
        stockQty
      ];
}
