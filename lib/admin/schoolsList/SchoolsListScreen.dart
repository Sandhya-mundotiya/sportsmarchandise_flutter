import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/home/HomeScreen.dart';
import 'package:merch/bloc/school/school_bloc.dart';
import 'package:merch/main.dart';
import 'package:merch/models/school_model.dart';

import 'SchoolsListController.dart';

class SchoolsListScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select School")),
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SchoolLoaded) {
            return ListView(
              children: state.schools
                  .map((school) => listItem(context,school))
                  .toList(),
            );
          } else {
            return const Text('Something went wrong.');
          }
        },
      ),
    );
  }
  Widget listItem(BuildContext context,School school){
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(schoolId: school.uid)));
      },
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 15,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(school.name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}