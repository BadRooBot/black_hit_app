import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class ImageViewS extends StatefulWidget {
  final imageUrl;
  const ImageViewS({Key? key,required this.imageUrl}) : super(key: key);

  @override
  _ImageViewSState createState() => _ImageViewSState();
}

class _ImageViewSState extends State<ImageViewS>  with SingleTickerProviderStateMixin{
  late final TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  double minScale=1;
  double maxScale=5;
  double scale=1;
  OverlayEntry? entry;
  @override
  void initState() {
    super.initState();
    controller =TransformationController();
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 200))..addListener(() {
      controller.value=animation!.value;
    })
    ..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        removeOverlay();
      }
    });
  }
  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
        child: buildImage()
      ) ;

  }
  buildImage(){
    var size=MediaQuery.of(context).size;

    return Builder(builder: (context)=> InteractiveViewer(
        transformationController: controller,
        minScale: minScale,
        maxScale: maxScale,
        panEnabled: false,
        clipBehavior: Clip.none,
        onInteractionStart: (details){
          if(details.pointerCount<2)return;
          if(entry==null) {
            showOverlay(context);
          }
        },onInteractionUpdate: (details){
          if(entry==null)return;
          this.scale=details.scale;
          entry!.markNeedsBuild();
          },
        onInteractionEnd: (details){
          if(details.pointerCount!=1)return;
          restAnimation();
        },
        child: AspectRatio(aspectRatio: 1,child: HtmlWidget(
          '<img width="${size.width-25}" height="250" src="${widget.imageUrl}" '
              '/>',
          factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
        ),)));
  }

  void restAnimation() {
    animation=Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity()
    ).animate(CurvedAnimation(parent:animationController,curve: Curves.easeInOutBack ));
    animationController.forward(from: 0);
  }

  void showOverlay(BuildContext context) {
    var size=MediaQuery.of(context).size;
    final renderBox=context.findRenderObject()! as RenderBox;
    final offset=renderBox.localToGlobal(Offset.zero);
    final opacity=((scale-1)/(maxScale-1).clamp(1, 6));
    entry=OverlayEntry(builder: (context){
      return Stack(
        children: [
          Positioned.fill(
              child:Opacity(opacity:opacity ,child: Container(color: Colors.black,))),
          Positioned(child: buildImage(),left: offset.dx,top: offset.dy
            ,width: size.width,),
        ],
      );
    });
    final overlay=Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void removeOverlay() {
    entry?.remove();
    entry=null;
  }
}
