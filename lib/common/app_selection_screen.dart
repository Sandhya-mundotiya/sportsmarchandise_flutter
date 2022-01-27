import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/admin/view/schools_list/schools_list_controller.dart';
import 'package:merch/admin/view/schools_list/schools_list_screen.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';
import 'package:merch/store/view/product_list/product_list_screen.dart';
import 'package:merch/store/view/school_list/school_list_user_controller.dart';
import 'package:merch/store/view/school_list/school_list_user_screen.dart';

class AppSelectionScreen extends StatelessWidget {
  const AppSelectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select App'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                getIt.registerSingleton<SchoolsListModel>(SchoolsListController());
                Navigator.push(context,MaterialPageRoute(builder: (context) => SchoolsListScreen()));

             },
              child: const Text('Admin'),
            ),
            ElevatedButton(
              onPressed:(){
                getIt.registerSingleton<SchoolsListUserModel>(SchoolsListUserController());
                Navigator.push(context,MaterialPageRoute(builder: (context) => SchoolsListUserScreen()));
              },
              child: const Text('Store'),
            )
          ],
        ),
      ),
    );
  }
}
