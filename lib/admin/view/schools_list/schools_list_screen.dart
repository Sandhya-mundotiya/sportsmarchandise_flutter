import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/view/home/home_screen.dart';
import 'package:merch/admin/view/schools_list/schools_list_controller.dart';
import 'package:merch/admin/bloc/school/school_bloc.dart';
import 'package:merch/common/common_widgets.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/main.dart';
import 'package:merch/models/school_model.dart';

class SchoolsListScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        getIt.unregister<SchoolsListModel>();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Select School")),
        body: BlocBuilder<SchoolBloc, SchoolState>(
          builder: (context, state) {
            if (state is SchoolLoading) {
              return loaderAdmin();
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
      ),
    );
  }
  Widget listItem(BuildContext context,School school){
    return InkWell(
      onTap: (){
        SchoolData.schoolId=school.uid;
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(schoolId: school.uid)));
      },
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 5,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(school.name,textAlign: TextAlign.center,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}