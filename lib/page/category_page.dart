import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineshop/config/service_url.dart';
import 'package:onlineshop/model/category.dart';
import 'package:onlineshop/model/category_goodslist_model.dart';
import 'package:onlineshop/model/categorymodel.dart';
import 'package:onlineshop/provide/category_goods_list.dart';
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
    _getGoodsList();
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
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? 4 : categoryId,
      'categorySubId': '',
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      /*setState(() {
        list = goodsList.data;
      });*/
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data);
      print('分类商品列表：>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
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
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
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

//小类导航
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
              return _rightInkWell(
                  index, childCategory.childCategoryList[index]);
            }),
      );
    });
  }

  void _getGoodsList(categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      /*setState(() {
        list = goodsList.data;
      });*/
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(goodsList.data);
        print('分类商品列表：>>>>>>>>>>>>>${goodsList.data[0].goodsName}');
      }
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
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
//  List list = [];
  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _getMoreList() async {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      /*setState(() {
        list = goodsList.data;
      });*/
      if (goodsList.data == null) {
        Fluttertoast.showToast(
            msg: '暂无更多数据',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.pink,
            textColor: Colors.white);
        Provide.value<ChildCategory>(context).changeNoMore('没有更多数据了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreList(goodsList.data);
        print('分类商品列表：>>>>>>loadmore>>>>>>>${goodsList.data[0].goodsName}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(builder: (context, child, data) {
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          //列表位置，放到最上面
          scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('进入页面第一次初始化: ${e}');
      }

      if (data.goodsList.length > 0) {
        return Expanded(
            //继承自Flexible
            child: Container(
          width: ScreenUtil().setWidth(570),
          //height: ScreenUtil().setHeight(970),
          child: EasyRefresh(
            header: ClassicalHeader(
                bgColor: Colors.white,
                textColor: Colors.pink,
                infoColor: Colors.pink,
                noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                showInfo: true,
                infoText: '正在加载中。。。',
                refreshText: '提示刷新',
                refreshReadyText: '下拉刷新',
                refreshingText: '刷新中。。。',
                refreshedText: '刷新完成'),
            footer: ClassicalFooter(
              bgColor: Colors.white,
              textColor: Colors.pink,
              infoColor: Colors.pink,
              showInfo: true,
              noMoreText: Provide.value<ChildCategory>(context).noMoreText,
              infoText: '正在加载中。。。',
              loadText: '上拉加载更多',
              loadReadyText: '上拉加载',
            ),
            child: ListView.builder(
                controller: scrollController,
                itemCount: data.goodsList.length,
                itemBuilder: (context, index) {
                  return _ListWidget(data.goodsList, index);
                }),
            onLoad: () async {
              print('开始加载更多......');
              _getMoreList();
            },
            onRefresh: () async {
              print('开始刷新数据......');
              Provide.value<ChildCategory>(context).page = 0;
              Provide.value<CategoryGoodsListProvide>(context)
                  .goodsList
                  .clear();
              _getMoreList();
            },
          ),
        ));
      } else {
        return Text('暂时没有数据');
      }
    });
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(180),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _ListWidget(List newList, int index) {
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
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }

/*Widget _wrapListWidget() {
    if (list.length != 0) {
      print('>>>>lll>>>>>${list.length}');
      List<Widget> wrapList = newList.map((e) {
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
  }*/
}
