// import 'dart:typed_data';
// import 'package:AliStore/Dashbord/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:AliStore/alert.dart';
// import 'package:AliStore/resources/Localizations_constants.dart';
// import 'package:AliStore/resources/storage_methods.dart';

// class addNewGroup extends StatefulWidget {
//   const addNewGroup({Key? key}) : super(key: key);

//   @override
//   _addNewGroupState createState() => _addNewGroupState();
// }

// class _addNewGroupState extends State<addNewGroup> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   Uint8List? _image;
//   var _imageURL;
//   var _privet;
//   int val=-1;

//   @override
//   void dispose() {
//     super.dispose();
//     _bioController.dispose();
//     _usernameController.dispose();
//   }
//   pickImage(ImageSource source) async {
//     final ImagePicker _imagePicker = ImagePicker();
//     PickedFile? _file = await _imagePicker.getImage(source: source);
//     if (_file != null) {
//       return await _file.readAsBytes();
//     }

//   }

//   selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     // set state because we need to display the image we selected on the circle avatar
//     setState(() {
//       _image = im;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     bool  VIP=UserInfoList[0]["VIP"];

//     String  Add=getTranslated(context,"Add");
//     String  GroupName=getTranslated(context,"GroupName");
//     String  GroupDesc=getTranslated(context,"GroupDesc");
//     String  Privet=getTranslated(context,"Privet");
//     String  Public=getTranslated(context,"Public");
//     String  loading=getTranslated(context,"loading");
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(

//             children: [
//               const SizedBox(
//                 height: 64,
//               ),
//               Visibility(visible: VIP,
//                 child: Stack(
//                   children: [
//                     _image != null
//                         ? CircleAvatar(
//                       radius: 64,
//                       backgroundImage: MemoryImage(_image!),
//                       backgroundColor: Colors.red,
//                     )
//                         : const CircleAvatar(
//                       radius: 64,
//                       backgroundImage: NetworkImage(
//                           'https://i.stack.imgur.com/l60Hf.png'),
//                       backgroundColor: Colors.red,
//                     ),
//                     Positioned(
//                       bottom: -10,
//                       left: 80,
//                       child: IconButton(
//                         onPressed: selectImage,
//                         icon: const Icon(Icons.add_a_photo),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   hintText: '$GroupName',
//                   hintStyle: TextStyle(color: Colors.white54),
//                   border: InputBorder.none,
//                 ),
//               ),

//               const SizedBox(
//                 height: 24,
//               ),
//               TextField(
//                 controller: _bioController,
//                 decoration: InputDecoration(
//                   hintText: '$GroupDesc',
//                   hintStyle: TextStyle(color: Colors.white54),
//                   border: InputBorder.none,
//                 ),
//               ),
//                          const SizedBox(
//                 height: 12,
//               ),

//               Row(mainAxisAlignment:MainAxisAlignment.spaceAround  ,
//                 children: [Text("$Privet"),
//                    Radio(value:1, groupValue:_privet, onChanged:(value){
//                       setState(() {
//                         _privet=value;

//                       });
//                     }),
//           Text("$Public"),
//                   Radio(value:2, groupValue:_privet, onChanged:(value){
//                     setState(() {
//                       _privet=value;


//                     });
//                   })
//                 ],
//               ),

//               ElevatedButton(onPressed: ()async{
//                 showLoading(context, "$loading", true);
//                 String GroupId =FirebaseFirestore.instance.collection("Group").doc().id ;

//                 VIP?_imageURL=  await StorageMethods().uploadImageGroupToStorage("GroupImage",_image,GroupId):_imageURL="No Image";

//                 FirebaseFirestore.instance
//                     .collection('Group')
//                     .doc(GroupId)
//                     .set({
//                   'profilePic':"${_imageURL}",
//                   'name': _usernameController.text,
//                   'GroupId': GroupId,
//                   'bio': _bioController.text,
//                   'member':[],
//                   'request':[],
//                   'Type':_privet,
//                   'VIP':VIP,
//                   'Online':0,
//                   'adminId':FirebaseAuth.instance.currentUser!.uid
//                     }).whenComplete(() => Navigator.of(context).pop());
//                 Navigator.of(context).pop();
//               }, child: Text("$Add"))


//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
