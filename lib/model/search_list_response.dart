import 'package:handyman_admin_flutter/model/pagination_model.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';

class SearchListResponse {
  List<ServiceData>? serviceList;
  int? max;
  int? min;
  Pagination? pagination;

  SearchListResponse({this.serviceList, this.max, this.min, this.pagination});

  factory SearchListResponse.fromJson(Map<String, dynamic> json) {
    return SearchListResponse(
      serviceList: json['data'] != null ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      max: json['max'],
      min: json['min'],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serviceList != null) {
      data['data'] = this.serviceList!.map((v) => v.toJson()).toList();
    }

    data['max'] = this.max;
    data['min'] = this.min;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
