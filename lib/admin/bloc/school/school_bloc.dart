import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:merch/models/school_model.dart';
import 'package:merch/repositories/school/school_repository.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository _schoolRepository;
  StreamSubscription _schoolSubscription;

  SchoolBloc({SchoolRepository SchoolRepository})
      : _schoolRepository = SchoolRepository,
        super(SchoolLoading());

  @override
  Stream<SchoolState> mapEventToState(
    SchoolEvent event,
  ) async* {
    if (event is LoadSchools) {
      yield* _mapLoadSchoolsToState();
    }
    if (event is UpdateSchools) {
      yield* _mapUpdateSchoolsToState(event);
    }
  }

  Stream<SchoolState> _mapLoadSchoolsToState() async* {
    _schoolSubscription?.cancel();
    _schoolSubscription = _schoolRepository.getAllSchools().listen(
          (schools) => add(
            UpdateSchools(schools),
          ),
        );
  }

  Stream<SchoolState> _mapUpdateSchoolsToState(
      UpdateSchools event) async* {
    yield SchoolLoaded(schools: event.schools);
  }
}
