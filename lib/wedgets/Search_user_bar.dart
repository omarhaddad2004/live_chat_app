import 'dart:async';
import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  final Function(String)? onSearch;

  Searchbar({Key? key, this.onSearch}) : super(key: key);

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final TextEditingController _controller = TextEditingController();//  هاض فايدته فعليا بعمل كونترول للتيكست الي جوا التيكست فيلد راح تقول متى؟ يعني حطيته عمبدأ انو في كبسة معينة بالتيكست فيلد بتشطب كل الكلام مرة وحدة فاهم؟ بتحتاج controller. clear  عشان تعمله هاي فايدته
  Timer? _debounce;// مهم ليه لأنه هاض فعليا تايمر من فئة async بس استعملته هون عشان اتحكم بمتى يبعث ال api call  تمام؟

  @override
  void dispose() {//مهم ليه؟ لأنه راح يتنفذ بس تخلص تطبيقك و يمسح كلشي بالمتغيرين الي فوق الي همو التايمر و التيكست ايديتور كونترولر
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {// هون عشان كل حرف بنكتب يعمل تغير عال api call ويجيب المدينة لو موجودة هاض الاصل يعني اول اشي بتأكد هل المستخدم بكتب ولا موقف بعدين بعمل متغير جديد انو يعمل api call بعد نص ثانية من توقف الانسان
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      if (widget.onSearch != null) {
        widget.onSearch!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white24,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onTextChanged,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search for place..",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(//حطيته بس للعلم فيه وهو هدفه الاساسي انو يوضحلك انك بتقدر تكتب حاليا فاهم؟
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(//when u press to search
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}