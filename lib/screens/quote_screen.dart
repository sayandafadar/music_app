import 'package:flutter/material.dart';

class QuoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          image: DecorationImage(
            image: NetworkImage(
                'https://viveconstyle.com/wp-content/uploads/2018/06/Life-begins-mobile-wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}
