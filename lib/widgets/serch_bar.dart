import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerchBar extends StatelessWidget {
  SerchBar({required this.onChanged, required this.hintText, super.key});
  final void Function(String)? onChanged;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: hintText,
      backgroundColor: Colors.white,
      onChanged: onChanged,
    );
  }
}
