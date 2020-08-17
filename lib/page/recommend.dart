import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlineshop/routers/application.dart';

/*
* 推荐商品
* */
class Recommend extends StatelessWidget {
  final List recommendList;

  const Recommend({Key key, this.recommendList}) : super(key: key);

  //推荐商品标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项子view方法

  Widget _item(BuildContext context,int index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 1, color: Colors.black12),
            )),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey
                  //decorationStyle: TextDecorationStyle.solid,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(340),
      margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(context,index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(425),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}
