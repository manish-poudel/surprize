import 'package:flutter/material.dart';
import 'AppColor.dart';
import 'CustomWidgets/CustomLabelTextFieldWidget.dart';
import 'CustomWidgets/CustomTextButtonWidget.dart';

/*
Login page template
 */
class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return new MaterialApp(
     home:Scaffold(
       backgroundColor: AppColor.colorPrimary,
       body: Container(
         child: Column(
           children: <Widget>[
               Container(
                 child: Image.asset('assets/images/gift_colorful.png'),
                 padding: EdgeInsets.only(top:48.0),
                 alignment: FractionalOffset.center
               ),
             Text("Surprize !",
             style: TextStyle(color:Colors.white, fontSize: 32.0, fontFamily: 'Roboto')
             ),
             Padding(
               padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
               child: Container(
                 child: Column(children: <Widget>[
                   Text("Enter your login information",
                       style: TextStyle(color:Colors.white, fontSize: 24.0, fontFamily: 'Roboto', fontWeight: FontWeight.bold )
                   ),
                  CustomLabelTextFieldWidget("Enter email", Colors.white),
                   Padding(
                     padding: const EdgeInsets.only(top:8.0),
                     child: CustomLabelTextFieldWidget("Enter password", Colors.white),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 1.0,top:8.0,right:1.0),
                     child: SizedBox(
                       width: double.infinity,
                       height: 48.0,
                       child:CustomTextButtonWidget("Login", AppColor.colorPrimaryLight, ()=> {}),
                     ),
                   ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:16.0),
                          child: Text("Are you new?",
                              style: TextStyle(color:Colors.white, fontSize: 18.0, fontFamily: 'Roboto')
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:32.0),
                          child: SizedBox(
                            height: 32.0,
                            child:CustomTextButtonWidget("Register", Colors.green, ()=> {}),
                          ),
                        )
                      ],),
                    ),
                  )
                 ],),
               ),
             )
           ],
         ),
       ),
     )
   );
  }

}