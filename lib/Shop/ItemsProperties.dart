
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class ItemsProperties extends StatefulWidget {
  final ImageCount, ItemName,ItemsImage,ItemPrice,ItemDec,ItemsPropertiesCount,ItemsProperties1,ItemsProperties2,ItemsProperties3,ItemsProperties4,ItemsProperties5,ItemsProperties6,ItemsProperties7,ItemsProperties8,ItemsProperties9,ItemsProperties10,ItemsProperties11,ItemsImage1,ItemsImage2,ItemsImage3,ItemsImage4,ItemsImage5,ItemsImage6,ItemsImage7,ItemsImage8,ItemsImage9,ItemsImage10;

  const ItemsProperties({Key? key,required this.ItemName, required this.ItemsImage,
    required this.ItemPrice,
    required this.ImageCount,
    required this.ItemDec,
    required this.ItemsPropertiesCount,
     this.ItemsProperties1,
     this.ItemsProperties2,
     this.ItemsProperties3,
     this.ItemsProperties4,
     this.ItemsProperties5,
     this.ItemsProperties6,
     this.ItemsProperties7,
     this.ItemsProperties8,
     this.ItemsProperties9,
     this.ItemsProperties10,
     this.ItemsProperties11,
     this.ItemsImage1,
     this.ItemsImage2,
     this.ItemsImage3,
     this.ItemsImage4,
     this.ItemsImage5,
     this.ItemsImage6,
     this.ItemsImage7,
     this.ItemsImage8,
     this.ItemsImage9,
     this.ItemsImage10,
  }) : super(key: key);

  @override
  _ItemsPropertiesState createState() => _ItemsPropertiesState();
}
int RadioVal=0;
PageController _pageController=new PageController(initialPage: 0,viewportFraction: 1.0,keepPage: false);
class _ItemsPropertiesState extends State<ItemsProperties> {
  void onPageChanged(int page) {
    setState(() {
      RadioVal = page;

    });
  }
   getAllInkWell(int Count,bool PageChanged){
if(PageChanged){
  setState(() {
    RadioVal=0;

  });
}
Color? clr1=Theme.of(context).appBarTheme.backgroundColor;
Color? clr2=Colors.teal;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(visible: Count>=0,
          child: InkWell(child: RadioVal==0?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=0;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=1,
          child: InkWell(child: RadioVal==1?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=1;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=2,
          child: InkWell(child:RadioVal==2?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=2;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=3,
          child: InkWell(child: RadioVal==3?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=3;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=4,
          child: InkWell(child:RadioVal==4?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=4;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=5,
          child: InkWell(child: RadioVal==5?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=5;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=6,
          child: InkWell(child: RadioVal==6?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=6;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=7,
          child: InkWell(child: RadioVal==7?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=7;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=8,
          child: InkWell(child: RadioVal==8?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=8;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=9,
          child: InkWell(child: RadioVal==9?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal=9;
              _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    String loading =getTranslated(context, 'loading');
    String Properties = getTranslated(context,'Properties');
    String ItemName = getTranslated(context,'ItemName');
    String Price =getTranslated(context, 'Price');
    String Type =getTranslated(context, 'Type');
    return Scaffold(
      appBar: AppBar(title: Text('$Properties '+'${widget.ItemName}'),),
      body: ListView(children: [
      Stack(alignment: Alignment.bottomCenter,children: [
        Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*.60,child: getAllItmeImage(widget.ImageCount, context, widget.ItemsImage,widget.ItemsImage1, widget.ItemsImage2, widget.ItemsImage3, widget.ItemsImage4, widget.ItemsImage5, widget.ItemsImage6,widget.ItemsImage7, widget.ItemsImage8, widget.ItemsImage9)),
        Positioned(child:getAllInkWell(widget.ImageCount-1,false),bottom:10)]),
        Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: Text('$ItemName'+'${widget.ItemName}'),),
        Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: Text('$Price'+'${widget.ItemPrice}'),),
        Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: Text('$Type'+' ${widget.ItemDec}'),)
        ,Container(child: Visibility(visible: widget.ItemsPropertiesCount>=1?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties1}'))],))))
        ,Container(child: Visibility(visible: widget.ItemsPropertiesCount>=2?true:false,child: Card(elevation: 2,child: Row(children: [Text('*  '),Expanded(child: Text('${widget.ItemsProperties2}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=3?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties3}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=4?true:false,child: Card(elevation: 2,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties4}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=5?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties5}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=6?true:false,child: Card(elevation: 2,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties6}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=7?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties7}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=8?true:false,child: Card(elevation: 2,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties8}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=9?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child:Text('${widget.ItemsProperties9}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=10?true:false,child: Card(elevation: 2,child: Row(children: [Text('*  '),Expanded(child: Text('${widget.ItemsProperties10}'))],)))),
        Container(child: Visibility(visible: widget.ItemsPropertiesCount>=11?true:false,child: Card(elevation: 3,child: Row(children: [Text('*  '),Expanded(child: Text('${widget.ItemsProperties11}'))],)))),


      ],),
    );
  }
  getAllItmeImage(int Count,context,img1,img2,img3,img4,img5,img6,img7,img8,img9,img10){
    List imags=[img1,img2,img3,img4,img5,img6,img7,img8,img9,img10];

    return
      PageView.builder(itemBuilder:  (context, index){
        return ClipRRect(borderRadius:  BorderRadius.circular(0),
          child: HtmlWidget(
            '<img width="${ MediaQuery.of(context).size.width}" height="${ MediaQuery.of(context).size.height*.60}" src="${imags[index]}" '
                '/>',
            factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
          ),
        );

      },itemCount: Count,controller:_pageController, onPageChanged: onPageChanged,);
  }
}





