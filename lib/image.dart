import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _assetPath;
  
  ImageBanner(this._assetPath,);

  @override
  Widget build(BuildContext context){
    return Container(
      
      height: 120.0,
      width: 120.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/unistuff_logo.png'),
          
        ),
        shape: BoxShape.rectangle,
      ),
     
    );//Container
  }//Widget
}//stateless widget