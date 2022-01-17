

import 'package:flutter/cupertino.dart';

class SizeConfig {
  BuildContext con;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal = screenWidth / 100;
  static double blockSizeVertical = screenHeight / 100;
  SizeConfig(this.con){
    screenWidth= MediaQuery.of(con).size.width;
    screenHeight= MediaQuery.of(con).size.height;
  }

}