import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/admin/schools_list/schools_list_controller.dart';
import 'package:merch/admin/schools_list/schools_list_screen.dart';
import 'package:merch/constants/utils/size_config.dart';
import 'package:merch/main.dart';

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
              onPressed:(){},
              child: const Text('Store'),
            )
          ],
        ),
      ),
    );
  }
}
