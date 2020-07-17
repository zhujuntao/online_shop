import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onlineshop/page/adbanner.dart';
import 'package:onlineshop/page/floor_content.dart';
import 'package:onlineshop/page/floor_title.dart';
import 'package:onlineshop/page/leader_phone.dart';
import 'package:onlineshop/page/recommend.dart';
import 'package:onlineshop/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  String homePageContent = '正在获取数据';

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

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNavigator(
                      navigatorList: navgatorList,
                    ),
                    //广告组件
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(
                        leaderImage: leaderImage, leaderPhone: leaderPhone),
                    Recommend(recommendList: recommendList),
                    //楼层展示商品
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(floorGoodsList: floor3),
                  ],
                ),
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
          return Image.network(
            '${swiperDataList[index]['image']}',
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}

//

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
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
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}
