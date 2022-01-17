
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/constants/utils/size_config.dart';

 Widget loader(){
   return Stack(
     children: const [
       Opacity(
         opacity: 0.4,
         child: ModalBarrier(dismissible: false, color: Colors.grey),
       ),
       Center(
         child: CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
         ),
       ),
     ],
   );
 }
Widget appSpinner(String label, TextEditingController controller,Function click){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: InkWell(
        onTap: click,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      //margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*0.5),
                      child: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color:primaryColor,
                      ),
                    ),
                    labelText: label,
                    contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2,horizontal: SizeConfig.blockSizeHorizontal*6),
                    labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            color: primaryColor),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: primaryColor)),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color:primaryColor)),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction:TextInputAction.next,
                ),
              ),
            ),
          ],),
      ),
    ),
  );
}
Widget appSearchBar(String hint,TextEditingController controller,{Icon icon}){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4,horizontal: 5),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: Container(
        padding: EdgeInsets.only(left:icon!=null?10:30,right: 15,top:15,bottom:15),
        decoration: BoxDecoration(
          border: Border.all(color:primaryColor,width: 1),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
      hintText: hint,
      isDense: true,
        contentPadding: EdgeInsets.only(right: 50),
        prefixIcon: icon!=null?icon:null,
      prefixIconConstraints: BoxConstraints.tightFor(width: 30,height: 20),
      hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
      cursorColor: primaryColor,
      ))),
    );

}

Widget appBar(String title){
  return AppBar(
    title: Text(title,style: TextStyle(color: appWhite),),
    automaticallyImplyLeading: true,
    iconTheme: IconThemeData(color: appWhite),
  );
}
bottomSheet(BuildContext context,String title, List<String> list, TextEditingController controller){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration:const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: Text(title,style:const TextStyle(color: appWhite)),
              automaticallyImplyLeading: false,
              actions: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding:EdgeInsets.all(8.0),
                    child: Icon(Icons.close,color: appWhite,size: 25),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding:const  EdgeInsets.all(0),
                separatorBuilder: (context, index) {
                  return const Divider(height: 1);
                },
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical*1.5,
                          horizontal: SizeConfig.blockSizeHorizontal*2),
                      child: Center(child: Text(list[index],style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5,fontWeight: FontWeight.w500,color: appBlack))),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ),
  );
}
 Widget formTextField({String hint,TextEditingController controller,FocusNode focus,FocusNode focusNext,String validation,int minLines}){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Padding(
       padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2+2,top: SizeConfig.blockSizeVertical*1),
       child: Text(hint),
     ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black38,width: 1),
            color: iconBGGrey
        ),
        child: TextFormField(
             autovalidateMode: AutovalidateMode.onUserInteraction,
             controller: controller,
             focusNode: focus,
             minLines: minLines ?? 1,
             maxLines: minLines!=null?minLines+3:1,
             decoration: InputDecoration(
             hintText: hint,
               isDense: true,
             contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             border: InputBorder.none,
         ),
         onSaved: (String value) {
         // This optional block of code can be used to run
         // code when the user saves the form.
         },
         validator: (String value) {
         return validation!=null? value.contains('') ? validation : null:null;
         },
         ),
      ),
    ],
  );
}

snac(String message,{bool error,bool success}){
  ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext).showSnackBar(SnackBar(content: Text(message,style: TextStyle(color: error!=null && error?Colors.red:success!=null && success?Colors.green:Colors.white),)));
}
Widget spinnerField(Function onClick,{String hint,TextEditingController controller,String validation,int minLines}){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2+2,top: SizeConfig.blockSizeVertical*1),
        child: Text(hint),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.5),
        child:  InkWell(
          onTap: onClick,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black38,width: 1),
                color: iconBGGrey
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller,
                    enabled: false,
                    minLines: minLines ?? 1,
                    maxLines: minLines!=null? minLines+3:1,
                    decoration: InputDecoration(
                      hintText: hint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      border: InputBorder.none,
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return validation!=null? value.contains('') ? validation : null:null;
                    },
                  ),
                ),
                const Padding(
                  padding:EdgeInsets.only(right: 8),
                  child:Icon(Icons.arrow_drop_down,color: appBlack),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget appButton(Function onClick,{int fontSize,FontWeight weight,String text,bool isExpanded,bool isCenter}){
  return Container(
    margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1,horizontal: SizeConfig.blockSizeHorizontal*2),
    child: Row(
      mainAxisAlignment: isCenter!=null && isCenter?MainAxisAlignment.center:MainAxisAlignment.start,
      children: [
        Flexible(
         fit: isExpanded!=null && isExpanded?FlexFit.tight:FlexFit.loose,
          child: ElevatedButton(
            child: Text(text!=null?text:"Submit", style: TextStyle(
                color: appWhite,
                fontSize: fontSize!=null?fontSize:SizeConfig.blockSizeHorizontal*4,
                fontWeight: weight!=null?weight:FontWeight.bold)),
            onPressed:onClick,
            style: ElevatedButton.styleFrom(
                primary: primaryColor,
                padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1,horizontal: SizeConfig.blockSizeHorizontal*3),
               ),
          ),
        ),
      ],
    ),
  );
}