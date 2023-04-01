

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/Shop/ItemsProperties.dart';
import 'package:AliStore/Shop/ShopCar.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../Dashbord/search_screen.dart';

List ShopItemsList = [];
List CarItemsList = [];
class ShopItem extends StatefulWidget {
  const ShopItem({Key? key}) : super(key: key);

  @override
  _ShopItemState createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {

  var user = FirebaseAuth.instance.currentUser;


  CollectionReference Shopref = FirebaseFirestore.instance.collection("ShopItems");

  getShopItemsInfo() async {
    CarItemsList.clear();
    ShopItemsList.clear();
    var ItemsInfo = await Shopref.get();
    ItemsInfo.docs.forEach((element) {
      setState(() {
        ShopItemsList.add(element.data());

      });
    });
  }

  @override
  void initState() {
    getShopItemsInfo();
    ImageCache();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String AddToCar =getTranslated(context, 'Add-To-Car');
    String CarEmpty =getTranslated(context, 'Car-Empty');
    return Scaffold(
      appBar: AppBar(actions: [InkWell(onTap:() {

       CarItemsList.isNotEmpty? Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShopCar(carList: CarItemsList,),
            )):showLoading(context, "$CarEmpty", false);
      },child: Stack(alignment: Alignment.center, children: [const Icon(Icons.shopping_cart_outlined)
        ,Positioned(
      bottom: 1,
      child: Text("${CarItemsList.length}",style: const TextStyle(fontWeight: FontWeight.bold),),)]
      )
      ),
        InkWell(onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ));
        },child: const Icon(Icons.search),)
      ]),
      body:
      Card(margin: const EdgeInsets.all(5),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),child:  GridView.builder(itemCount: ShopItemsList.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 180,
           // childAspectRatio: 1,
          ),
          itemBuilder: (context, index){
            var ItemsName=ShopItemsList[index]["ItemsName"];
            var ItemsImage=ShopItemsList[index]["ItemsImage"];
            var ItemsPrice=ShopItemsList[index]["ItemsPrice"];
            var ItemsDec=ShopItemsList[index]["ItemsDec"];
            var ItemsPropertiesCount=ShopItemsList[index]["ItemsProperties"];

            var ItemsProperties1=ShopItemsList[index]["ItemsProperties1"];
            var ItemsProperties2=ShopItemsList[index]["ItemsProperties2"];
            var ItemsProperties3=ShopItemsList[index]["ItemsProperties3"];
            var ItemsProperties4=ShopItemsList[index]["ItemsProperties4"];
            var ItemsProperties5=ShopItemsList[index]["ItemsProperties5"];
            var ItemsProperties6=ShopItemsList[index]["ItemsProperties6"];
            var ItemsProperties7=ShopItemsList[index]["ItemsProperties7"];
            var ItemsProperties8=ShopItemsList[index]["ItemsProperties8"];
            var ItemsProperties9=ShopItemsList[index]["ItemsProperties9"];
            var ItemsProperties10=ShopItemsList[index]["ItemsProperties10"];
            var ItemsProperties11=ShopItemsList[index]["ItemsProperties11"];

            return Card(elevation: 0,
              child: Column(children: [
                Container(child:
                GestureDetector(child: ClipRRect(borderRadius:  BorderRadius.circular(6),
                  child: HtmlWidget(
                    '<img width="80" height="80" src="${ItemsImage}" '
                        '/>',
                    factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                  ),
                ),onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ItemsProperties(ImageCount: ShopItemsList[index]['ImageCount'],ItemName: ItemsName, ItemsImage:ItemsImage,ItemPrice: ItemsPrice, ItemDec: ItemsDec, ItemsPropertiesCount: ItemsPropertiesCount, ItemsProperties1: ItemsProperties1, ItemsProperties2: ItemsProperties2, ItemsProperties3: ItemsProperties3, ItemsProperties4: ItemsProperties4, ItemsProperties5: ItemsProperties5, ItemsProperties6: ItemsProperties6, ItemsProperties7: ItemsProperties7, ItemsProperties8: ItemsProperties8, ItemsProperties9: ItemsProperties9, ItemsProperties10: ItemsProperties10, ItemsProperties11: ItemsProperties11,ItemsImage1:ShopItemsList[index]['ItemsImage1'],ItemsImage2:ShopItemsList[index]['ItemsImage2'],ItemsImage3:ShopItemsList[index]['ItemsImage3'],ItemsImage4:ShopItemsList[index]['ItemsImage4'],ItemsImage5:ShopItemsList[index]['ItemsImage5'],ItemsImage6:ShopItemsList[index]['ItemsImage6'],ItemsImage7:ShopItemsList[index]['ItemsImage7'],ItemsImage8:ShopItemsList[index]['ItemsImage8'],ItemsImage9:ShopItemsList[index]['ItemsImage9'],ItemsImage10:ShopItemsList[index]['ItemsImage10']),
                      ));
                },)),
                Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [Container(width: 90,child: Text("$ItemsName",maxLines: 1)),Text("$ItemsPrice",maxLines: 1)],),
                Container(child: Text("$ItemsDec" ,maxLines: 1,overflow: TextOverflow.clip ),),

              MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(5),side: BorderSide(width: 1.5,color: Colors.blueGrey)),
                    splashColor: Colors.lightBlue,

                    color:   Theme.of(context).cardColor,
                    onPressed: (){
                    setState(() {
                      CarItemsList.length;
                      CarItemsList.add(ShopItemsList[index]);
                    });
                  },
                    child: Visibility(
                      visible: true,
                      child:Container(alignment: Alignment.center,width: 90,child: Text( "$AddToCar",style: TextStyle(fontSize: 10),)),
                    ),
                  ),


              ],),
            );
          }))
    );
  }
}
