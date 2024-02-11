import 'package:handyman_admin_flutter/model/provider_address_mapping_model.dart';

class ServiceAddressMapping {
  String? createdAt;
  int? id;
  int? providerAddressId;
  ProviderAddressMapping? providerAddressMapping;
  int? serviceId;
  String? updatedAt;

  ServiceAddressMapping({this.createdAt, this.id, this.providerAddressId, this.providerAddressMapping, this.serviceId, this.updatedAt});

  factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    return ServiceAddressMapping(
      createdAt: json['created_at'],
      id: json['id'],
      providerAddressId: json['provider_address_id'],
      providerAddressMapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null,
      serviceId: json['service_id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_address_id'] = this.providerAddressId;
    data['service_id'] = this.serviceId;
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt;
    }
    if (this.providerAddressMapping != null) {
      data['provider_address_mapping'] = this.providerAddressMapping!.toJson();
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt;
    }
    return data;
  }
}
