import 'package:flutter/material.dart';
import 'package:Qtz/models/qtz_model.dart';
import 'package:bloc/bloc.dart';
import 'package:Qtz/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Qtz/bloc/qtz/qtz_bloc.dart';
import 'package:Qtz/bloc/qtz/qtz_event.dart';
import 'package:Qtz/bloc/qtz/qtz_state.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:Qtz/component/flutter_swipper/flutter_swiper.dart';
import 'package:Qtz/component/raised_gradient_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:toast/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  PageController pageController;
  GlobalKey _globalKey = new GlobalKey();
  int currentIndex = 0;
  String currentPath = "";
  List<Quotes> listQuote = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getData();
  }

  void getData(){
    BlocProvider.of<QtzBloc>(context).add(
      GetQuotes(
        filter:"",
        type:""
      ),
    );
  }

  Future<void> saveImage() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      Uint8List data = byteData.buffer.asUint8List();
      String dataImagePath = await ImagePickers.saveByteDataImageToGallery(data);
      setState((){
        currentPath = dataImagePath;
      });

      Toast.show("Succesfully Save Image", _globalKey.currentContext, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    } catch (e) {
      Toast.show(e, _globalKey.currentContext, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  Future<void> shareImage() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      Uint8List data = byteData.buffer.asUint8List();
      String dataImagePath = await ImagePickers.saveByteDataImageToGallery(data);
      setState((){
        currentPath = dataImagePath;
      });

      Share.shareFiles([dataImagePath], text: "Quote From ${listQuote[currentIndex].author}");
    } catch (e) {
      Toast.show(e, _globalKey.currentContext, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        backgroundColor: colorBackground,
        body: LoaderOverlay(
          overlayWidget: Center(
            child: Container(
              padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorBackground,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 70,
                  child: LoadingIndicator(indicatorType: Indicator.ballScaleMultiple, color: colorGradientSecondary[1])
                )
            ),
          ),
          overlayColor : Colors.black.withOpacity(0.8),
          overlayOpacity: 1,
          child: Container(
            padding: EdgeInsets.all(20),
            child: BlocConsumer<QtzBloc, QtzState>(
              listener: (context, state) {
                if(state is QtzLoading)
                {
                  context.showLoaderOverlay();
                }

                else if(state is QtzFailure){
                  Toast.show("Error", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  context.hideLoaderOverlay();
                }

                else if(state is QtzSuccess)
                {
                  context.hideLoaderOverlay();
                  setState((){
                    listQuote = state.qtzModel.quotes;
                  });
                }
              },
              builder: (context, state){
                if(state is QtzSuccess){
                  var data = state.qtzModel.quotes;
                  return Container(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: new Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                var quotesData = data[index];
                                return RepaintBoundary(
                                  key: index == currentIndex ? _globalKey : Key("__${index}__"),
                                  child:  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.35),
                                          offset: Offset(0, 5),
                                          blurRadius: 15.0,
                                          spreadRadius: 0.0,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children : [
                                        CachedNetworkImage(
                                          imageUrl: urlBackground[index],
                                          imageBuilder: (context, imageProvider) =>  new Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill
                                              )
                                            ),
                                          ),
                                          placeholder: (context, url) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color:Colors.white
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                        Positioned(
                                          top:20,
                                          left:20,
                                          child: Icon(
                                            Icons.format_quote_rounded, 
                                            color: Colors.white.withOpacity(0.8),
                                            size: 150
                                          )
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(40),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Spacer(),
                                              Expanded(
                                                child:AutoSizeText(
                                                  quotesData.body, 
                                                  style: GoogleFonts.courgette(
                                                    textStyle:Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w400, color: Colors.white), 
                                                  ),
                                                  minFontSize: 20
                                                )
                                              ),
                                              SizedBox(height: 20),
                                              AutoSizeText("- ${quotesData.author}", style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white)),
                                              Spacer(),
                                            ]
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: backColor[index]
                                            ),
                                          ),
                                        ),
                                      ]
                                    )
                                  )
                                );
                              },
                              itemCount: 20,
                              itemWidth: double.infinity,
                              itemHeight: MediaQuery.of(context).size.height,
                              layout: SwiperLayout.TINDER,
                              onIndexChanged: (index){
                                setState((){
                                  currentIndex = index;
                                });
                              }
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: RaisedGradientButton(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children:[
                                        Icon(Icons.download_rounded, color: Colors.white),
                                        Expanded(
                                          child: Text("Save",textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith( fontWeight: FontWeight.w300, color: Colors.white)),
                                        )
                                      ]
                                    )
                                  ),
                                  gradient: LinearGradient(
                                    colors: colorGradientSecondary,
                                  ),
                                  onPressed: (){
                                    saveImage();
                                  }
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: RaisedGradientButton(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children:[
                                        Icon(Icons.copy, color: Colors.white),
                                        Expanded(
                                          child: Text("Copy",textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith( fontWeight: FontWeight.w300, color: Colors.white)),
                                        ) 
                                      ]
                                    )
                                  ),
                                  gradient: LinearGradient(
                                    colors: colorGradientSecondary,
                                  ),
                                  onPressed: (){
                                    var quote = "${listQuote[currentIndex].body} - ${listQuote[currentIndex].author}";
                                    FlutterClipboard.copy(quote).then(( value ) => Toast.show("Copied", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM));
                                  }
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: RaisedGradientButton(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children:[
                                        Icon(Icons.share, color: Colors.white),
                                        Expanded(
                                          child: Text("Share",textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith( fontWeight: FontWeight.w300, color: Colors.white)),
                                        )  
                                      ]
                                    )
                                  ),
                                  gradient: LinearGradient(
                                    colors: colorGradientSecondary,
                                  ),
                                  onPressed: (){
                                    shareImage();
                                  }
                                ),
                              )
                            ]
                          )
                        ),

                        SizedBox(height: 40),
                      ]
                    )
                  );
                }
                else{ 
                  return Container();
                }
              },
            )
          )
        ),
      ), 
      onWillPop: _willPopCallback
    );
  }

}


