import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'router_handler.dart';

class Routes {
  static String root = '/';
  static String detailsPage = '/detail';
  static String categoryPage = '/category';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ERROR===>ROUTE WAS NOT FONUND');
      return;
    });

    router.define(detailsPage, handler: detailsHandler);//详情页
    router.define(categoryPage, handler: categoryHandler);//分类页
  }
}
