import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
              List<Map> swiper =
                  (data['data']['slides'] as List).cast(); // 顶部轮播组件数
              return Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiper),
                ],
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
    ScreenUtil.init(width: 750, height: 1334);
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
