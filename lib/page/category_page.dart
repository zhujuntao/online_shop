import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlineshop/config/service_url.dart';
import 'package:onlineshop/model/category.dart';
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
      body: Container(
        child: Row(
          children: <Widget>[
            LsftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
              ],
            )
          ],
        ),
      ),
    );
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
