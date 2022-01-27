import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/admin/view/home/home_screen.dart';
import 'package:merch/admin/bloc/school/school_bloc.dart';
import 'package:merch/constants/utils/school.dart';
import 'package:merch/main.dart';
import 'package:merch/models/school_model.dart';
import 'package:merch/store/view/product_list/product_list_screen.dart';
import 'package:merch/store/view/school_list/school_list_user_controller.dart';

class SchoolsListUserScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        getIt.unregister<SchoolsListUserModel>();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
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
      ),
    );
  }
  Widget listItem(BuildContext context,School school){
    return InkWell(
      onTap: (){
        SchoolData.schoolId=school.uid;
        Navigator.push(context,MaterialPageRoute(builder: (context) => ProductListScreen()));
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