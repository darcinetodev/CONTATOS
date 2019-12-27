import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {

  final String hintText;
  final Icon icon;
  final Function(String) onChange;
  final Stream<String> stream;
  final TextInputType input;
  final TextEditingController controller;

  InputForm({this.icon, this.hintText, this.onChange, this.input, this.stream, this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: snapshot.hasError ? Colors.red : Colors.white,
                               width: snapshot.hasError ? 2 : 0),
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: StreamBuilder<String>(
                stream: stream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        icon: icon,
                    ),
                    onChanged: onChange,
                    keyboardType: input,
                  );
                }
              ),
            ),
          ),
        );
      }
    );
  }
}
