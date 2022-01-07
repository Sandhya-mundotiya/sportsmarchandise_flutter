part of 'school_bloc.dart';

abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object> get props => [];
}

class LoadSchools extends SchoolEvent {}

class UpdateSchools extends SchoolEvent {
  final List<School> schools;

  UpdateSchools(this.schools);

  @override
  List<Object> get props => [schools];
}
