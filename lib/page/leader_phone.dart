import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* 拨打电话
*
* github地址：https://github.com/flutter/plugins/tree/master/packages/url_launcher
*
* */
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone;

  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key); //店长图片
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}
