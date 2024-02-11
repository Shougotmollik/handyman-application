import 'package:handyman_admin_flutter/model/pagination_model.dart';
import 'package:handyman_admin_flutter/model/provider_address_mapping_model.dart';

class ProviderAddressListResponse {
  List<ProviderAddressMapping>? data;
  Pagination? pagination;

  ProviderAddressListResponse({this.data, this.pagination});

  factory ProviderAddressListResponse.fromJson(Map<String, dynamic> json) {
    return ProviderAddressListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ProviderAddressMapping.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
