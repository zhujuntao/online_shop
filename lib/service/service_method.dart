import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:onlineshop/config/service_url.dart';

//获取首页主题内容

Future getHomePageContent() async {
  try {
    print('开始获取首页数据........');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded").toString();
    /* dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded') as String;*/
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('ERROR:=======>${e}');
  }
}

//获取火爆区商品的方法
Future getHomePageBeloConten() async {
  try {
    print('开始获取下拉列表数据.................');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded').toString();
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'], data: page);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常,请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:=======>${e}');
  }
}

Future request(url, {formData}) async {
  try {
    print('开始获取数据.................');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded').toString();
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常,请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:=======>${e}');
  }
}
