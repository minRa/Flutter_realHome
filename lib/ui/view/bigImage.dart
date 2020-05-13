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
     _googleAdsService.bottomBanner();
    super.initState();
  }

  @override
  void dispose() {
     imgList.clear();
    _googleAdsService.disposeGoogleAds();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {  
   imgList = widget.data;
  return SafeArea(
         child: Scaffold(
        // appBar: AppBar(
        //     automaticallyImplyLeading: false,
        //     title: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[       
        //       Hero(
        //         tag: 'logo',
        //         child: Image.asset('assets/images/logo.png',
        //         scale: 4,),
        //       ),
        //       SizedBox(width: 5,),
        //       Text('Rent House Phto'),
        //     ],
        //   ),
        // ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                height: 420.0,
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
                          color: Colors.green,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Hero(
                            tag: imgUrl,
                            child: Image.network(
                            imgUrl,
                            fit: BoxFit.fill,
                              ),
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
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed:() {
                     _carouselSlider.previousPage( duration: Duration(milliseconds: 300), curve: Curves.ease);
                    },
                    child: Text("<"),
                  ),
                  OutlineButton(
                    onPressed: () {
                     _carouselSlider.nextPage(duration: Duration(milliseconds: 300), curve: Curves.decelerate);
                    },
                    child: Text(">"),
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

    //        return GestureDetector(
    //           onTap: (){
    //             Navigator.of(context).pop();
    //           },
    //           child: Hero(
    //           tag:widget.data[0][widget.data[1]],
    //           child: Container(
    //             width: 64.0,
    //             height: 64.0,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.rectangle,
    //               image:  DecorationImage(
    //                   fit: BoxFit.cover,
    //                   image: NetworkImage(widget.data[0][widget.data[1]])
    //               )
    //     )),
    // ),
    //        );
  






// class CarouselDemo extends StatefulWidget {
//   CarouselDemo() : super();

//   final String title = "Carousel Demo";

//   @override
//   CarouselDemoState createState() => CarouselDemoState();
// }

// class CarouselDemoState extends State<CarouselDemo> {
//   //

//   List imgList = [
//     'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
//     'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
//     'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
//     'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
//     'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
//   ];

//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             carouselSlider = CarouselSlider(
//               height: 400.0,
//               initialPage: 0,
//               enlargeCenterPage: true,
//               autoPlay: true,
//               reverse: false,
//               enableInfiniteScroll: true,
//               autoPlayInterval: Duration(seconds: 2),
//               autoPlayAnimationDuration: Duration(milliseconds: 2000),
//               pauseAutoPlayOnTouch: Duration(seconds: 10),
//               scrollDirection: Axis.horizontal,
//               onPageChanged: (index) {
//                 setState(() {
//                   _current = index;
//                 });
//               },
//               items: imgList.map((imgUrl) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.symmetric(horizontal: 10.0),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                       ),
//                       child: Image.network(
//                         imgUrl,
//                         fit: BoxFit.fill,
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: map<Widget>(imgList, (index, url) {
//                 return Container(
//                   width: 10.0,
//                   height: 10.0,
//                   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _current == index ? Colors.redAccent : Colors.green,
//                   ),
//                 );
//               }),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 OutlineButton(
//                   onPressed: goToPrevious,
//                   child: Text("<"),
//                 ),
//                 OutlineButton(
//                   onPressed: goToNext,
//                   child: Text(">"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   goToPrevious() {
//     carouselSlider.previousPage(
//         duration: Duration(milliseconds: 300), curve: Curves.ease);
//   }

//   goToNext() {
//     carouselSlider.nextPage(
//         duration: Duration(milliseconds: 300), curve: Curves.decelerate);
//   }
// }