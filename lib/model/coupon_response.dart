import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/model/pagination_model.dart';

class CouponResponse {
  Pagination? pagination;
  List<CouponData>? data;

  CouponResponse({
    this.pagination,
    this.data,
  });

  CouponResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CouponData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
