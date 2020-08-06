import 'package:flutter/material.dart';
import 'package:onlineshop/page/index_page.dart';
import 'package:onlineshop/provide/child_category.dart';
import 'package:provide/provide.dart';

void main() {
  var childCategory = ChildCategory();
  var providers = Providers();
  providers..provide(Provider<ChildCategory>.value(childCategory));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false, //去除debug
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
