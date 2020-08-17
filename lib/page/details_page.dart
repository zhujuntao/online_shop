import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;

  DetailsPage({Key key, this.goodsId}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('商品ID：${goodsId}'),
      ),
    );
  }
}
