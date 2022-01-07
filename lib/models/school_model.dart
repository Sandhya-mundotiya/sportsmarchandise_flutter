import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class School extends Equatable {
  final String name;
  final String uid;

  const School({
    this.name,
    this.uid
  });

  @override
  List<Object> get props => [
        name,
        uid
      ];

  static School fromSnapshot(DocumentSnapshot snap) {
    School school = School(
        name: snap['name'],
        uid: snap['uid']
    );
    return school;
  }
}
