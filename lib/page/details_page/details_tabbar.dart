import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../provide/details_info.dart';
import 'package:provide/provide.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(builder: (context, child, val) {
      var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
      var isRight = Provide.value<DetailsInfoProvide>(context).isRight;
      return Container(
        margin: EdgeInsets.only(top: 15.0),
        child: Row(
          children: <Widget>[
            _myTabBarLeft(context, isLeft),
            _myTabBarRight(context, isRight),
          ],
        ),
//        _sysTabbar(),
      );
    });
  }

  Widget _myTabBarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 1.0, color: isLeft ? Colors.pink : Colors.black12))),
        child: Text(
          '详情',
          style: TextStyle(color: isLeft ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  //右侧
  Widget _myTabBarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: isRight ? Colors.pink : Colors.black12))),
        child: Text(
          '评论',
          style: TextStyle(color: isRight ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  //使用系统自带tabbar
  /* const TabBar({
    Key key,
    @required this.tabs,//必须实现的，设置需要展示的tabs，最少需要两个
    this.controller,
    this.isScrollable = false,//是否需要滚动，true为需要
    this.indicatorColor,//选中下划线的颜色
    this.indicatorWeight = 2.0,//选中下划线的高度，值越大高度越高，默认为2
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,//用于设定选中状态下的展示样式
    this.indicatorSize,//选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
    this.labelColor,//设置选中时的字体颜色，tabs里面的字体样式优先级最高
    this.labelStyle,//设置选中时的字体样式，tabs里面的字体样式优先级最高
    this.labelPadding,
    this.unselectedLabelColor,//设置未选中时的字体颜色，tabs里面的字体样式优先级最高
    this.unselectedLabelStyle,//设置未选中时的字体样式，tabs里面的字体样式优先级最高
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,//点击事件
  })
  */

  /* @override
  void initState() {
    //生命周期函数
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      print(_tabController.index);
    });
  }
  TabController _tabController;*/
  Widget _sysTabbar() {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: ScreenUtil().setHeight(120),
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: TabBar(
          isScrollable: false,
          //是否需要滚动，true为需要
          // indicator: BoxDecoration(),//用于设定选中状态下的展示样式
          indicatorColor: Colors.pink,
          //选中下划线的颜色
          indicatorWeight: 3.0,
          //选中下划线的高度，值越大高度越高，默认为2
          indicatorSize: TabBarIndicatorSize.tab,
          //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
          labelColor: Colors.pink,
          //设置选中时的字体颜色，tabs里面的字体样式优先级最高
          labelStyle: TextStyle(fontSize: 20),
          //设置选中时的字体样式，tabs里面的字体样式优先级最高
          unselectedLabelColor: Colors.black,
          //设置未选中时的字体颜色，tabs里面的字体样式优先级最高
          unselectedLabelStyle: TextStyle(fontSize: 20),
          //设置未选中时的字体样式，tabs里面的字体样式优先级最高

          onTap: (index) {
            print('index====${index}');
          },
          tabs: <Widget>[
            Tab(
              text: '查看详情',
            ),
            Tab(
              text: '查看评论',
            ),
          ],
        ),
      ),
    );
  }
}
