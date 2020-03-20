import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmeringBox({double height, double width}){
  return Shimmer.fromColors(
    baseColor: Colors.grey[200],
    highlightColor: Colors.grey[100],
    child: Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      height: height,
      width: width,
  ),
);
}


Widget buildShimmeringParagraph(BuildContext context){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width* 0.8 ),
      buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width* 0.8 ),
      buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width* 0.8 ),
      buildShimmeringBox(height: 20.0, width: MediaQuery.of(context).size.width* 0.4 ),
  ],);
}

Widget buildShimmeringCircle(double radius){
  return ClipOval(
    child: buildShimmeringBox(height: radius*2, width: radius*2)
  );

}
