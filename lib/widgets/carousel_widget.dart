import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CarouselWidget extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/test1.png', // Replace with your actual asset paths
    'assets/images/test2.png',
    'assets/images/test3.jpg',
    'assets/images/test4.png',
    'assets/images/test5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Set the height of the carousel
      child: FlutterCarousel(
        options: FlutterCarouselOptions(
          height: 180, // Ensure the height matches the SizedBox
          autoPlay: true, // Enable auto-slideshow
          autoPlayInterval: const Duration(seconds: 6), // Set slideshow interval to 6 seconds
          showIndicator: true, // Show the indicator
          enableInfiniteScroll: true, // Enable looping of slides
          slideIndicator:  CircularSlideIndicator(),
        ),
        items: imageUrls.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // Use AssetImage for local images
                    fit: BoxFit.cover, // Ensure the image covers the entire container
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}