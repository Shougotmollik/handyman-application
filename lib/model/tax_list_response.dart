import 'package:handyman_admin_flutter/model/pagination_model.dart';

class TaxListResponse {
  List<TaxData>? taxData;
  Pagination? pagination;

  TaxListResponse({this.taxData, this.pagination});

  factory TaxListResponse.fromJson(Map<String, dynamic> json) {
    return TaxListResponse(
      taxData: json['data'] != null ? (json['data'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.taxData != null) {
      data['data'] = this.taxData!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class TaxData {
  int? id;
  int? providerId;
  String? title;
  String? type;

  // Value should be in Double. Now, Sometimes get Double in String and Sometimes in Int
  num? value;
  int? status;
  num? totalCalculatedValue;

  TaxData({
    this.id,
    this.providerId,
    this.title,
    this.type,
    this.value,
    this.status,
    this.totalCalculatedValue,
  });

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      providerId: json['provider_id'],
      title: json['title'],
      type: json['type'],
      value: json['value'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['value'] = this.value;
    data['status'] = this.status;
    return data;
  }
}
