import 'package:realhome/services/googleAds_service.dart';
import 'package:realhome/locator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';



class BigImageView extends StatefulWidget {
  
  final dynamic data;
  BigImageView({this.data});

  @override
  _BigImageViewState createState() => _BigImageViewState();
}

class _BigImageViewState extends State<BigImageView> {
  List imgList;
  final CarouselController _carouselSlider = CarouselController();
  int _current = 0;
   
  List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}
    
   final GoogleAdsService _googleAdsService = locator<GoogleAdsService>();

  @override
  void initState() {
       imgList = widget.data;
       
   if(!_googleAdsService.onBanner) {
    _googleAdsService.bottomBanner();
    }
    super.initState();
  }

  @override
  void dispose() {
    _googleAdsService.disposeGoogleAds();
    imgList.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {  
  return SafeArea(
         child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                height: 350.0,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                //pauseAutoPlayOnTouch: Duration(seconds: 10),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                     _current = index;
                  });
                }                  
                ),
                carouselController: _carouselSlider,
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          child: imgList.length < 3 ?
                          Image.network(imgUrl,
                          fit: BoxFit.cover,
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ? 
                                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                                  ),
                                );
                              },
                            ) :
                          Hero(
                          tag: imgUrl,
                          child: Image.network(imgUrl,
                          fit: BoxFit.cover,
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ? 
                                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                                  ),
                                );
                              },
                            ) ,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgList, (index, url) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.blueGrey : Colors.black.withOpacity(0.2),
                    ),
                  );
                }),
              ),
              // SizedBox(
              //   height: 20.0,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed:() {
                     _carouselSlider.previousPage( duration: Duration(milliseconds: 300), curve: Curves.ease);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 50,),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                     _carouselSlider.nextPage(duration: Duration(milliseconds: 300), curve: Curves.decelerate);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
  );
  }
}
