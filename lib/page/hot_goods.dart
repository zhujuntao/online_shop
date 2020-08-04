import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlineshop/service/service_method.dart';

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  int page = 1;
  List<Map> hotGoodsList = [];

  void _getHotGoods() {
    var formPage = {'page': page};
    request('homePageBelowConten', formData: formPage).then((value) {
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
      print(data);
    });
  }

  Widget _warpList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((e) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  e['image'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  e['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${e['mallPrice']}'),
                    Text(
                      '￥${e['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
//    color: Colors.transparent,  不能同时添加color  decoration中使用了color
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 10,
            ),
            Text(
              '火',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '火爆专区',
        ),
      ],
    ),
  );

  Widget _hotConWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _warpList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* request('homePageBelowConten', formData: 1).then((value) {
      print(value);
    });*/
    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    return _hotConWidget();
  }
}
