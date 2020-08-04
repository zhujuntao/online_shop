
//https://javiercbk.github.io/json_to_dart/
class CategoryBigModel {
  String mallCategoryId; //类别编号
  String mallCategoryName; //类别名称
  List<dynamic> bxMallSubDto; //小类列表
  String image;
  Null comments;

  CategoryBigModel(
      {this.mallCategoryId,
      this.mallCategoryName,
      this.bxMallSubDto,
      this.image,
      this.comments}); //图片

  //工厂模式-用这种模式可以省略New关键字

  factory CategoryBigModel.fromJson(dynamic json) {
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      bxMallSubDto: json['bxMallSubDto'],
      image: json['image'],
      comments: json['comments'],
    );
  }
}

class CategoryBigListModel {
  List<CategoryBigModel> data;

  CategoryBigListModel(this.data);

  factory CategoryBigListModel.fromJson(List json) {
    return CategoryBigListModel(
        json.map((e) => CategoryBigModel.fromJson(e)).toList());
  }
}
