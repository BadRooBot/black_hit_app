import 'package:flutter/material.dart';

getDropdownButton(List<dynamic> DropList,String? SelectedItem){
 return DropdownButtonFormField<String>(
   decoration: InputDecoration(enabledBorder: OutlineInputBorder(
     borderRadius: BorderRadius.circular(12),
         borderSide: BorderSide(width: 3,color: Colors.lightBlue)
   )),
    value: SelectedItem,
    items: DropList.map((item) => DropdownMenuItem<String>(
      value: item,
      child: Text(item,),
    )).toList(),
   onChanged: (item){

      SelectedItem=item;
   },
  );

}