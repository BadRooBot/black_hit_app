import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/Shop/ItemsView.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:pay/pay.dart';
class ShopCar extends StatefulWidget {
  final   carList;
  const ShopCar({Key? key,required this.carList}) : super(key: key);

  @override
  _ShopCarState createState() => _ShopCarState();
}

class _ShopCarState extends State<ShopCar> {
  @override
  Widget build(BuildContext context) {
    int p=0;
    String TotalPrice =getTranslated(context, 'Total-Price');
    String Paymentconfirmation =getTranslated(context, 'Payment-confirmation');
      for(int i =0;i<=widget.carList.length-1;i++){
        try{
        p+= int.parse(widget.carList[i]["ItemsPrice"]);

        }catch(e){}
      }
    final _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount:'$p',
        status: PaymentItemStatus.final_price,
      )
    ];
     FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String postId =FirebaseFirestore.instance.collection("payment").doc().id;
    return Scaffold(
      appBar: AppBar(title:  Text('$Paymentconfirmation'),),
      body:getShopItems(widget.carList,widget.carList,widget.carList.length)
        ,
     // bottomSheet:Text('$p'),
      bottomSheet:BottomSheet(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight:Radius.circular(5))) ,backgroundColor: AppBarTheme.of(context).backgroundColor,onClosing: () {  }, builder: (BuildContext context) {
        return Container(height: 80,padding: const EdgeInsets.all(4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
           /* ApplePayButton(
            paymentConfigurationAsset: 'apple_pay.json',
            width: 200,
            paymentItems: _paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,

            onPaymentResult: (result){},
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),*/

            GooglePayButton(
              paymentConfigurationAsset: 'google_pay.json',
              paymentItems: _paymentItems,
              width: 200,
              height: 40,

              type: GooglePayButtonType.checkout,
              onPaymentResult: (result){
                _firestore.collection('payment').doc(postId).set(widget.carList,SetOptions(merge: true));
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
              Container(margin: const EdgeInsets.only(left: 5,right: 5),child: Text("$TotalPrice"+"$p",style: const TextStyle(color: Colors.white ),),)
            ]),
        );

      },)

    );
  }
}
/*MaterialButton(shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15)),splashColor: Colors.lightBlue, child:Container(width: 75,child: Container(width: 200,child: const Text( "Conufirm"))), textColor: Colors.white ,
            color:   Colors.blueGrey,
              onPressed: () {  },)*/