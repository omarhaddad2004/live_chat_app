import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final String hint;
  bool ispassword;
  Textfield({required this.hint,this.onchange,this.ispassword =false});


  Function(String)? onchange;

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  bool obscure =true;

  @override
  Widget build(BuildContext context) {

  return Padding(
        padding: EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: Colors.black12,
          )
        ),
        child: TextFormField(

          validator: (valu){
            if(valu!.isEmpty){
              return 'Field is requierd';
            }
          },

          onChanged: widget.onchange,
          obscureText: widget.ispassword?obscure:false,
          style:  TextStyle(color: Colors.black
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(widget.ispassword? Icons.lock :Icons.mail),
            suffixIcon: widget.ispassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
              ),
            )
                : null,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white)

            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.black)

            )
          ),

        ),
      ),



    );
  }
}
