import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:onlineshop/page/category_page.dart';

//import 'package:onlineshop/page/details_page.dart';
import '../page/details_page.dart';

Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String goodsId = params['id'].first;
  //print('index--->details goodsID is ${goodsId}');
  return DetailsPage(goodsId: goodsId);
});

Handler categoryHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CategoryPage();
});
