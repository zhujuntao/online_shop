import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onlineshop/config/service_url.dart';
import 'package:onlineshop/model/category.dart';
import 'package:onlineshop/model/categorymodel.dart';
import 'package:onlineshop/service/service_method.dart';

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
    });
  }

  Widget _leftInkWell(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
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
