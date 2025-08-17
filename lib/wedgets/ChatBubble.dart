import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  Chatbubble( this.text,this.isme);
  final String text;
  bool isme;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 14,left: 10,right: 10),
      child: Align(
        alignment: isme?Alignment.centerRight:Alignment.centerLeft,
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints:  BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),


          decoration: BoxDecoration(
              color:  isme
                  ?Color(0xFF2A2A44)
                  :Colors.white.withOpacity(0.12),
              borderRadius:isme?BorderRadius.only(topLeft: Radius.circular(20),bottomLeft:Radius.circular(20) ,topRight: Radius.circular(20)): BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),topRight: Radius.circular(20))
          ),
          child: Text(text,style: TextStyle(color: Colors.white
              ,fontSize: 15),),

        ),
      ),
    );
  }
}
