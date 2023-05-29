import 'package:flutter/material.dart';

class AutoAddress extends StatelessWidget {
  AutoAddress({Key? key, required this.controllerAddress, required this.valueChange})
      : super(key: key);
  final TextEditingController controllerAddress;
  Function valueChange;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return TextField(
      controller: controllerAddress,
      onChanged: (value) {
        if(value.length>4){
          // valueChange(value);
        }
      },
      style: TextStyle(fontSize: screenHeight * 0.02),
      decoration: InputDecoration(
        labelText: 'Adresse',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
