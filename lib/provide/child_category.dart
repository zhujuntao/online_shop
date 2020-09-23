import 'package:flutter/material.dart';
import 'package:onlineshop/model/categorymodel.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '4';
  String subId = ''; //小类id

  int page = 1; //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的标识 没有更多数据

  String mallCategoryId;
  String mallCategoryName="";

  //大类切换逻辑
  getChildCategory(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = '';
    childIndex = 0;
    categoryId = id;
    subId = ''; //点击大类时，把子类ID清空
    //childCategoryList = list;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(int index, String id) {
    //传递两个参数，使用新传递的参数给状态赋值
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  // 增加Page的方法

  addPage() {
    page++;
  }

  //改变noMoreText数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  //跳转到分类页
  jumpToChangeChild(String name) {
//    mallCategoryId = mallCategoryId;
    mallCategoryName = name;
    notifyListeners();
  }
}
