import 'package:flutter/material.dart';
import 'package:onlineshop/provide/details_info.dart';
import 'package:provide/provide.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;

  DetailsPage({Key key, this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('商品详情页'),
      ),
      body: FutureBuilder(
          future: _getBackInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Text('商品id:${goodsId}'),
                  ],
                ),
              );
            } else {
              return Text('加载中...');
            }
          }),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
