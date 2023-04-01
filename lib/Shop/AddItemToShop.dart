// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AliStore/resources/Localizations.dart';
// import 'package:AliStore/resources/Localizations_constants.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:AliStore/resources/storage_methods.dart';
// import 'package:path/path.dart';

// import '../alert.dart';
// class AddItemToShop extends StatefulWidget {

//   const AddItemToShop({Key? key}) : super(key: key);

//   @override
//   _AddItemToShopState createState() => _AddItemToShopState();

// }

// class _AddItemToShopState extends State<AddItemToShop> {

//   var email,price,passwor,ItemsProperties1,ItemsProperties2,ItemsProperties3,ItemsProperties4,ItemsProperties5,ItemsProperties6,ItemsProperties7,ItemsProperties8,ItemsProperties9,ItemsProperties10,ItemsProperties11;

//   late BuildContext _context;
//   late File file=File.fromRawPath(Uint8List(56));
//   var imageurl;
//   int Pcount=0;
//   late String done,Done,loading,PleaseWait,AddNewItem,Nameisrequired,TypeItemname,Itemname,ItemsDecisrequired,TypeItemsDec
//   ,ItemsDec,Priceisrequired,TypeItemsPrice,ItemsPrice,TypeItemsProperties,ItemsProperties,AddItemToShop,Cancel,ChoosefromGallery,Takeaphoto;
//   int RadioVal=0;
//   PageController _pageController=new PageController(initialPage: 0,viewportFraction: 1.0,keepPage: false);
//   File NullFile=File.fromRawPath(Uint8List(0001));
//    void setLocaleTranslated(BuildContext context){
//      Cancel=getTranslated(context,"Cancel");
//      ChoosefromGallery=getTranslated(context,"ChoosefromGallery");
//      Takeaphoto=getTranslated(context,"Takeaphoto");

//      done=getTranslated(context,"Choose-picture");
//      Done = DemoLocalizations.of(context).getTranslatedValue('Done');
//      loading =DemoLocalizations.of(context).getTranslatedValue( 'loading');
//      PleaseWait = DemoLocalizations.of(context).getTranslatedValue('Please-Wait');
//      AddNewItem = DemoLocalizations.of(context).getTranslatedValue('Add-New-Item');
//      Nameisrequired = DemoLocalizations.of(context).getTranslatedValue('Name-is-required');
//      TypeItemname =DemoLocalizations.of(context).getTranslatedValue( 'Type-Item-name');
//      Itemname =DemoLocalizations.of(context).getTranslatedValue( 'Item-name');
//      ItemsDecisrequired = DemoLocalizations.of(context).getTranslatedValue('ItemsDec-is-required');
//      TypeItemsDec = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Dec');
//      ItemsDec = DemoLocalizations.of(context).getTranslatedValue('ItemsDec');
//      Priceisrequired =DemoLocalizations.of(context).getTranslatedValue( 'Price-is-required');
//      TypeItemsPrice = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Price');
//      ItemsPrice = DemoLocalizations.of(context).getTranslatedValue('Items-Price');
//      TypeItemsProperties = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Properties');
//      ItemsProperties = DemoLocalizations.of(context).getTranslatedValue('Items-Properties');
//      AddItemToShop = DemoLocalizations.of(context).getTranslatedValue('Add-Item-To-Shop');
//   }

//   GlobalKey<FormState> formstate = new GlobalKey<FormState>();

//   CollectionReference userinfoRef =FirebaseFirestore.instance.collection("ShopItems") ;

//   late Reference res;

//   List<dynamic> Filesss=[null];

//   List imageUrls=[];
//   addInfo(context)async{
//     var formdata = formstate.currentState;
//     if (formdata!.validate()) {
//       formdata.save();

//       showLoading(context,"$loading",true);
//       if(Filesss.isNotEmpty) {
//         imageUrls.clear();
//         for(int f=0;f<Filesss.length-1;f++){

//           String postId =FirebaseFirestore.instance.collection("posts").doc().id;
//           var d =StorageMethods();
//           if(Filesss[f]!=null) {
//             String SUrl=await d.uploadImageGroupToStorage("ShopItems", Filesss[f], postId);
//             imageUrls.add(SUrl);

//           }
//         }
//       }else{
//         await res.putFile(file);
//         imageurl = await res.getDownloadURL();
//       }
//       String ItemsKey=TimeOfDay.now().toString().replaceAll(":", " ").replaceAll("/", " ").replaceAll("\\", " ").replaceAll("-", " ").trim();

//       await userinfoRef.doc(ItemsKey).set({
//         "ItemsKey":ItemsKey,
//         "ItemsName": email,
//         "ItemsDec": passwor,
//         "ImageCount":imageUrls.length,
//         "ItemsImage":imageUrls[0],
//         "ItemsPrice": price,
//         "ItemsProperties":Pcount,
//         "ItemsProperties1":ItemsProperties1,
//         "ItemsProperties2":ItemsProperties2,
//         "ItemsProperties3":ItemsProperties3,
//         "ItemsProperties4":ItemsProperties4,
//         "ItemsProperties5":ItemsProperties5,
//         "ItemsProperties6":ItemsProperties6,
//         "ItemsProperties7":ItemsProperties7,
//         "ItemsProperties8":ItemsProperties8,
//         "ItemsProperties9":ItemsProperties9,
//         "ItemsProperties10":ItemsProperties10,
//         "ItemsProperties11":ItemsProperties11,
//       },SetOptions(merge: true),);
//       for(int d=1;d<imageUrls.length;d++) {
//         await userinfoRef.doc(ItemsKey).set({'ItemsImage${d}':imageUrls[d]},SetOptions(merge: true));
//       }
//       Navigator.pushNamed(context, "home");

//     }
//   }



//   @override
//   Widget build(BuildContext context) {

//     setLocaleTranslated(context);
//     return Scaffold(
//       appBar: AppBar(title: Text('$AddNewItem')),
//       body:
//       Card(margin: EdgeInsets.all(5),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: ListView(children: [
//             Stack(alignment: Alignment.bottomCenter,children: [
//               Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*.30,child:ShowAllImage()),
//               Positioned(child:getAllInkWell(Filesss.length-1,false,context),bottom:10)]),
//           //هنا نهايه الصوره
//           Form( key: formstate,
//               child: Column(children: [
//                 SizedBox(height: 30,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "$Nameisrequired";
//                       }
//                       return null;
//                     },

//                     onSaved: (val){
//                       email=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemname",
//                         label: Text("$Itemname"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 30,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "$ItemsDecisrequired";
//                       }
//                       return null;
//                     },
//                     onSaved: (val){
//                       passwor=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsDec",
//                         label: Text("$ItemsDec"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "$Priceisrequired";
//                       }
//                       return null;
//                     },
//                     onSaved: (val){
//                       price=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsPrice",
//                         label: Text("$ItemsPrice"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                   setState(() {
//                     Pcount++;
//                   });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties1=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 1"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),

//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties2=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 2"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties3=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 3"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties4=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 4"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties5=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 5"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties6=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 6"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties7=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 7"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties8=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 8"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties9=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 9"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties10=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 10"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return null;
//                       }
//                       setState(() {
//                         Pcount++;
//                       });
//                       return null;
//                     },
//                     onSaved: (val){
//                       ItemsProperties11=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "$TypeItemsProperties",
//                         label: Text("$ItemsProperties 11"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),

//                 SizedBox(height: 35,),
//                 MaterialButton(onPressed: ()async{
//                   await addInfo(context);
//                 },
//                   child: Text("$AddItemToShop",style: TextStyle(fontSize: 18,color: Colors.white,letterSpacing: 1.1

//                   ))
//                   ,color: Colors.black,padding: EdgeInsets.symmetric(horizontal:120),
//                   splashColor: Colors.green,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),height: 52,),
//               ],
//               )

//           ),
//         ],),
//       ),
//     );
//   }
//   void onPageChanged(int page) {
//     setState(() {
//       RadioVal = page;

//     });
//   }
//   getAllInkWell(int Count,bool PageChanged,context){
//     if(PageChanged){
//       setState(() {
//         RadioVal=0;

//       });
//     }
//     Color? clr1=Theme.of(context).appBarTheme.backgroundColor;
//     Color? clr2=Colors.teal;
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Visibility(visible: Count>=0,
//           child: InkWell(child: RadioVal==0?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=0;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=1,
//           child: InkWell(child: RadioVal==1?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=1;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=2,
//           child: InkWell(child:RadioVal==2?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=2;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=3,
//           child: InkWell(child: RadioVal==3?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=3;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=4,
//           child: InkWell(child:RadioVal==4?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=4;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=5,
//           child: InkWell(child: RadioVal==5?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=5;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=6,
//           child: InkWell(child: RadioVal==6?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=6;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=7,
//           child: InkWell(child: RadioVal==7?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=7;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=8,
//           child: InkWell(child: RadioVal==8?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=8;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=9,
//           child: InkWell(child: RadioVal==9?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=9;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//       ],
//     );
//   }
//   _selectImage(BuildContext parentContext,index)  {
//     late File Files;
//     return showDialog(
//         context: parentContext,
//         builder: (BuildContext context) {
//           return SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             children: <Widget>[
//               SimpleDialogOption(
//                   padding: const EdgeInsets.all(20),
//                   child: Text('$Takeaphoto'),
//                   onPressed: () async {
//                     var picked = await ImagePicker()
//                         .getImage(source: ImageSource.camera);
//                     if (picked != null) {

//                       setState(() {
//                         Files = File(picked.path);
//                         Filesss.insert(index,Files);

//                       });

//                       var nameImage = basename(picked.path);
//                       res = FirebaseStorage.instance.ref("ShopItems").child(
//                           "$nameImage");
//                       Navigator.pop(parentContext);
//                     }
//                   }),
//               SimpleDialogOption(
//                   padding: const EdgeInsets.all(20),
//                   child: Text('$ChoosefromGallery'),
//                   onPressed: () async {
//                     var picked = await ImagePicker()
//                         .getImage(source: ImageSource.gallery);
//                     if (picked != null) {
//                       setState(() {
//                         Files = File(picked.path);
//                         Filesss.insert(index,Files);
//                       });

//                       var nameImage = basename(picked.path);
//                       res = FirebaseStorage.instance.ref("ShopItems").child(
//                           "$nameImage");
//                       Navigator.pop(parentContext);
//                     }
//                   }),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: Text("$Cancel"),
//                 onPressed: () {
//                   Navigator.pop(parentContext);
//                 },
//               )
//             ],

//           );
//         });
//     }

//   ShowAllImage(){
//     return
//       PageView.builder(itemBuilder:  (context, index){
//        if(index==0){
//          return Center(
//              child: Container( decoration: BoxDecoration(color:Colors.blueGrey,borderRadius: BorderRadiusDirectional.all(Radius.circular(180))),
//                width: 180,
//                height: 180,
//                margin: EdgeInsets.only(left: 85,right: 85,top: 25),
//                child: InkWell(focusColor: Colors.black,borderRadius: BorderRadius.circular(180),splashColor: Colors.blue,child:Filesss[index]==null?Center(child: Text('$done 1',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)):Image(image: FileImage(Filesss[index]),fit: BoxFit.fill)
//                    ,  onTap: ()async{
//                      var picked= await ImagePicker()
//                          .getImage(source: ImageSource.gallery);
//                      if (picked != null) {
//                        setState(() {
//                          done="$Done";
//                          file=File(picked.path);
//                          Filesss.insert(index,file);

//                        });
//                        file=File(picked.path);
//                        var nameImage=basename(picked.path);


//                      }
//                    }),
//              ));

//        }
//        else{
//          return Center(
//            child: Container( decoration: BoxDecoration(color:Colors.blueGrey,borderRadius: BorderRadiusDirectional.all(Radius.circular(180))),
//              width: 180,
//              height:180,
//              margin:EdgeInsets.only(left: 85,right: 85,top: 25),
//              child: InkWell(focusColor: Colors.black,borderRadius: BorderRadius.circular(180),splashColor: Colors.blue,child:Filesss[index]==null?Center(child: Text('$done'+' ${index+1}',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)):Image(image: FileImage(Filesss[index]),fit: BoxFit.fill,width: MediaQuery.of(context).size.width)
//                  ,  onTap: (){setState(() {
//                    _selectImage(context,index);
//                  });

//                }),
//            ),
//          );

//        }


//       },itemCount:Filesss.length<11?Filesss.length:10,controller:_pageController, onPageChanged: onPageChanged,);
//   }
// }
