import 'package:flutter/material.dart';
import 'package:onlineshop/page/index_page.dart';
import 'package:onlineshop/provide/category_goods_list.dart';
import 'package:onlineshop/provide/child_category.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';

import 'provide/details_info.dart';
import 'routers/routes.dart';
import 'routers/application.dart';



void main() {
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide=DetailsInfoProvide();
  var providers = Providers();


  providers
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(
        Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router=Router();
    Routes.configureRoutes(router);
    Application.router=router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false, //去除debug
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
