// import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:AliStore/Dashbord/home.dart';
// import 'package:AliStore/resources/Localizations_constants.dart';
// import 'package:AliStore/resources/firestore_methods.dart';


// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   _AddPostScreenState createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   Uint8List d=new Uint8List(0);


//   final TextEditingController _descriptionController = TextEditingController();

//   _selectImage(BuildContext parentContext) async {
//    String Cancel=getTranslated(context,"Cancel");
//    String CreateaPost=getTranslated(context,"CreateaPost");
//    String Takeaphoto=getTranslated(context,"Takeaphoto");
//    String ChoosefromGallery=getTranslated(context,"ChoosefromGallery");

//     return showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title:  Text('$CreateaPost'),
//           children: <Widget>[
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child:  Text('$Takeaphoto'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   var file = await pickImage(ImageSource.camera);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child:  Text('$ChoosefromGallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   var file = await pickImage(ImageSource.gallery);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child:  Text("$Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }


//   void postImage(String uid, String username, String profImage) async {
//     String Posted=getTranslated(context,"Posted");
//     setState(() {
//       isLoading = true;
//     });
//     // start the loading
//     try {
//       // upload to storage and db
//       String res = await FireStoreMethods().uploadPost(
//         _descriptionController.text,
//         _file != null?_file!:d,
//         uid,
//         username,
//         profImage,_file==null?"Text":"Image"
//       );
//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });
//         showSnackBar(
//           context,
//           '$Posted!',
//         );
//         Navigator.pushNamed(context, "home");
//        // clearImage();
//       } else {
//         showSnackBar(context, res);
//       }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       showSnackBar(
//         context,
//         err.toString(),
//       );
//     }
//   }

//  /* void clearImage() {
//     setState(() {
//       _file = null;
//     });
//     Navigator.pushNamed(context, "AddPostScreen");

//   }*/

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String Postto=getTranslated(context,"Postto");
//     String Post=getTranslated(context,"Post");
//     String Writeacaption=getTranslated(context,"Writeacaption");
//     return UserInfoList[UserInfoList.length - 1]["VIP"]&&_file==null
//         ? Scaffold(
//           body: Center(
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.upload,
//                 ),
//                 onPressed: () => _selectImage(context),
//               ),
//             ),
//         )
//         :
//     Scaffold(
//             appBar: AppBar(

//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed:(){ Navigator.pushNamed(context, "home");
//                 } ,
//               ),
//               title:  Text(
//                 '$Postto',
//               ),
//               centerTitle: false,
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => postImage(
//                    FirebaseAuth.instance.currentUser!.uid,
//                     "${UserInfoList[UserInfoList.length - 1]["name"]}",
//                     UserInfoList[0]["VIP"]? "${UserInfoList[UserInfoList.length - 1]["imageProFile"]}":"NoImage",
//                   ),
//                   child:  Text(
//                     "$Post",
//                     style: TextStyle(
//                       color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0),
//                   ),
//                 )
//               ],
//             ),
//             // POST FORM
//             body: Column(
//               children: <Widget>[
//                 isLoading
//                     ? const LinearProgressIndicator()
//                     : const Padding(padding: EdgeInsets.only(top: 0.0)),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     UserInfoList[0]['VIP']?CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         "${UserInfoList[UserInfoList.length - 1]["imageProFile"]}",
//                       ),
//                     )
//                     :CircleAvatar(backgroundImage: AssetImage(img),
//                       child: Text("${UserInfoList[0]["name"].toString().substring(0,1).toUpperCase()}",
//                         style:
//                         TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: TextField(
//                         controller: _descriptionController,
//                         decoration:  InputDecoration(
//                             hintText: "$Writeacaption",
//                             border: InputBorder.none),
//                         maxLines: 8,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 45.0,
//                       width: 45.0,
//                       child: AspectRatio(
//                         aspectRatio: 487 / 451,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage( UserInfoList[0]['VIP']?_file!:d),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//               ],
//             ),
//           );
//   }
// }
