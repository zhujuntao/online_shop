import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onlineshop/page/adbanner.dart';
import 'package:onlineshop/page/floor_content.dart';
import 'package:onlineshop/page/floor_title.dart';
import 'package:onlineshop/page/hot_goods.dart';
import 'package:onlineshop/page/leader_phone.dart';
import 'package:onlineshop/page/recommend.dart';
import 'package:onlineshop/provide/child_category.dart';
import 'package:onlineshop/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provide/provide.dart';

import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  String homePageContent = '正在获取数据';
  int page = 1;
  bool _isFooter = true;
  List<Map> hotGoodsList = [];

  /*
   * 加载更多完成添加消失
   * */
  _loadingBottomControl() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isFooter = false;
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _isFooter = true;
          });
        });
      });
    });
  }

//  GlobalKey<RefreshFooterState> _footerkey=new GlobalKey<RefreshFooterState>();

  //获取火爆专区数据  begin

  Widget _warpList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((e) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, '/detail?id=${e['goodsId']}');
          },
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

  //获取火爆专区数据  end

  @override
  void initState() {
    // TODO: implement initState
    /* getHomePageContent().then((value) {
      setState(() {
        homePageContent = value.toString();
      });
    });
*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // ignore: missing_return
              var data = json.decode(snapshot.data.toString());
              // 顶部轮播组件数
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navgatorList =
                  (data['data']['category'] as List).cast();
              //广告图片
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              //店长图片
              String leaderImage = data['data']['shopInfo']['leaderImage'];
              //店长电话
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];

              //商品推荐
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();

              //商品楼层展示
              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                header: ClassicalHeader(
                    key: GlobalKey<ClassicalHeaderWidgetState>(),
//                    key:new GlobalKey<RefreshIndicatorState>() ,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    showInfo: true,
                    refreshText: '提示刷新',
                    refreshReadyText: '下拉刷新',
                    refreshedText: '刷新完成',
                    refreshingText: '刷新中。。。'),
                footer: ClassicalFooter(
//                    key: GlobalKey<refre>(),
//                    key: _footerkey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    infoColor: Colors.pink,
                    showInfo: true,
                    noMoreText: '',
                    loadReadyText: '上拉加载',
                    loadedText: '加载完成',
                    loadingText: '加载中。。。'),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNavigator(
                      navigatorList: navgatorList,
                    ),
                    //广告组件
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(
                        leaderImage: leaderImage, leaderPhone: leaderPhone),
                    //商品推荐
                    Recommend(recommendList: recommendList),
                    //楼层展示商品
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(floorGoodsList: floor3),
                    //火爆专区
                    //HomeHotGoods(),
                    _hotConWidget(),
                  ],
                ),
                onLoad: _isFooter
                    ? () async {
                        print('开始加载更多......');
                        var formPage = {'page': page};
                        await request('homePageBelowConten', formData: formPage)
                            .then((value) {
                          var data = json.decode(value.toString());
                          if (data['code'] == '0' && data['data'] != null) {
                            List<Map> newGoodsList =
                                (data['data'] as List).cast();
                            setState(() {
                              hotGoodsList.addAll(newGoodsList);
                              page++;
                            });
                          } else {
                            _loadingBottomControl();
                          }
                          print(data);
                        });
                      }
                    : null,
                onRefresh: () async {
                  print('开始刷新数据......');
                  await getHomePageContent();
                  setState(() {
                    page = 1;
                    hotGoodsList.clear();
                  });
                },
              );
            } else {
              return Center(
                child: Text(
                  '加载中...',
                  style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(24, allowFontScalingSelf: false)),
                ),
              );
            }
          }),
    );
  }

/* void getHttp() async {
    try {
      Response response;
      var data = {'name': '技术胖'};
      response = await Dio().get(
          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=大胸美女"
          //  queryParameters:data
          );
      return print(response);
    } catch (e) {
      return print(e);
    }
  }*/
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(width: 750, height: 1334);
    print('设备像素密度：${ScreenUtil.pixelRatio}');
    print('设备高度：${ScreenUtil.screenHeight}');
    print('设备宽度：${ScreenUtil.screenWidth}');

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        autoplay: true, //自动轮播
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(), //分页器
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(
                  context, '/detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network(
              '${swiperDataList[index]['image']}',
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}

//顶部导航

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
//        Provide.value<ChildCategory>(context).jumpToChangeChild(item['mallCategoryId']);
        Provide.value<ChildCategory>(context).jumpToChangeChild(item['mallCategoryName']);
        print('========mallCategoryId:${item['mallCategoryName']}');
        Application.router.navigateTo(context, '/category');


      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        //水平方向间距
//        mainAxisSpacing: 5.0,
        // 垂直方向间距
//        crossAxisSpacing: 5.0,
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}
