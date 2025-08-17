import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Custombutton extends StatelessWidget {
  VoidCallback? ontap;
  String type;
  Custombutton(this.ontap,this.type);




  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return


      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: ontap
          ,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.15),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.013,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: Text(
            type,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
            ),
          ),
        ),

    );
  }
}
