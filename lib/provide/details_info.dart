import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;

  //从后台获取商品信息

  getGoodsInfo(String id) {
    var fromData = {'goodId': id};
    request('getGoodDetailById', formData: fromData).then((value) {
      var responseData = json.decode(value.toString());
      print(responseData);

      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}
