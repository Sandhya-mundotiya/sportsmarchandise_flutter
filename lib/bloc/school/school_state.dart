part of 'school_bloc.dart';

abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object> get props => [];
}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final List<School> schools;

  SchoolLoaded({this.schools = const <School>[]});

  @override
  List<Object> get props => [schools];
}
