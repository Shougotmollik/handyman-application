import 'package:handyman_admin_flutter/model/pagination_model.dart';

class CategoryResponse {
  Pagination? pagination;
  List<CategoryData>? categoryList;

  CategoryResponse({this.pagination, this.categoryList});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      categoryList = [];
      json['data'].forEach((v) {
        categoryList!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.categoryList != null) {
      data['data'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  int? id;
  int? categoryId;
  String? name;
  int? status;
  String? description;
  int? isFeatured;
  String? color;
  String? categoryImage;
  String? categoryExtension;
  String? categoryName;
  int? services;

  String? deletedAt;

  CategoryData({
    this.id,
    this.categoryId,
    this.name,
    this.status,
    this.description,
    this.isFeatured,
    this.color,
    this.categoryImage,
    this.categoryExtension,
    this.categoryName,
    this.services,
    this.deletedAt,
  });

  //CategoryData({this.id, this.name, this.status, this.description, this.isFeatured, this.color, this.categoryImage});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    color = json['color'];
    categoryImage = json['category_image'];
    categoryExtension = json['category_extension'];
    categoryName = json['category_name'];
    services = json['services'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['color'] = this.color;
    data['category_image'] = this.categoryImage;
    data['category_extension'] = this.categoryExtension;
    data['category_name'] = this.categoryName;
    data['services'] = this.services;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
