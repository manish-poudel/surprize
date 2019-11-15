import 'package:Surprize/Models/Facts.dart';
import 'package:Surprize/Resources/ImageResources.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomDidYouKnowWidget extends StatefulWidget {
  List<Facts> facts;
  CustomDidYouKnowWidget(this.facts);

  @override
  _CustomDidYouKnowWidgetState createState() => _CustomDidYouKnowWidgetState();
}

class _CustomDidYouKnowWidgetState extends State<CustomDidYouKnowWidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      height: 280,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 10),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      items: widget.facts.map((facts) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.black12),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: facts.imageUrl != null
                              ? FadeInImage.assetNetwork(
                                  image: facts.imageUrl,
                                  placeholder: ImageResources
                                      .emptyImageLoadingUrlPlaceholder,
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill)
                              : Container(height: 0, width: 0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(facts.body,
                            style: TextStyle(
                                fontFamily: 'Ralway',
                                fontSize: 16,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ));
          },
        );
      }).toList(),
    );
  }
}
