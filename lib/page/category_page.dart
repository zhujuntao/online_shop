import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlineshop/config/service_url.dart';
import 'package:onlineshop/model/category.dart';
import 'package:onlineshop/model/category_goodslist_model.dart';
import 'package:onlineshop/model/categorymodel.dart';
import 'package:onlineshop/provide/child_category.dart';
import 'package:onlineshop/service/service_method.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('商品分类'),
        ),
        body: Row(
          children: <Widget>[
            LsftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ],
        ));
  }
}

//左侧大类导航
class LsftCategoryNav extends StatefulWidget {
  @override
  _LsftCategoryNavState createState() => _LsftCategoryNavState();
}

class _LsftCategoryNavState extends State<LsftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      //CategoryBigListModel list = CategoryBigListModel.fromJson(data['data']);
//      CategoryModel list = CategoryModel.fromJson(data['data']);
      CategoryModel categoryModel = CategoryModel.fromJson(data);
      //categoryModel.data.forEach((element) => print(element.mallCategoryName));
      setState(() {
        list = categoryModel.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto);
    });
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (listIndex == index) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
//        padding: EdgeInsets.only(left: 10, top: 15),

        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(242, 240, 240, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
        itemCount: list.length,
      ),
    );
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  //List list = ['名酒', '宝丰', '北京二锅头', '茅台', '五粮液', '汾酒', '泸州老窖'];

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(builder: (context, child, childCategory) {
      return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
            //使用横向布局时需要添加宽高限制
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategoryList[index]);
            }),
      );
    });
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

//商品列表 可以上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  List list = [];

  @override
  void initState() {
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(570),
      height: ScreenUtil().setHeight(970),
//      child: _wrapListWidget(),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _ListWidget(index);
          }),
    );
  }

  void _getGoodsList() async {
    var data = {'categoryId': '4', 'categorySubId': '', 'page': 1};
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      setState(() {
        list = goodsList.data;
      });
      print('分类商品列表：>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
    });
  }

  Widget _goodsImage(index) {
    return Container(
      width: ScreenUtil().setWidth(180),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${list[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _ListWidget(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(index),
            Column(
              children: <Widget>[_goodsName(index), _goodsPrice(index)],
            )
          ],
        ),
      ),
    );
  }

  Widget _wrapListWidget() {
    if (list.length != 0) {
      print('>>>>lll>>>>>${list.length}');
      List<Widget> wrapList = list.map((e) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(280),
            height: ScreenUtil().setHeight(380),
            padding: EdgeInsets.all(5.0),
//            margin: EdgeInsets.only(bottom: 3.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Image.network(
                  e.image,
                  width: ScreenUtil().setWidth(275),
                ),
                 Text(
                  e.goodsName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
                Text(
                  '价格：￥${e.presentPrice}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24), color: Colors.pink),
                ),
              ],
            ),
          ),
        );
      }).toList();
      print('>>>>rrr>>>>>${wrapList.length}');
      return ListView(
        children: <Widget>[
          Wrap(
            spacing: 2,
            runSpacing: 2,
            children: wrapList,
          )
        ],
      );
    } else {
      return Text('');
    }
  }
}
