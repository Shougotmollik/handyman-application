class ProviderAddressMapping {
  String? address;
  String? createdAt;
  int? id;
  String? latitude;
  String? longitude;
  int? providerId;
  int? status;
  String? updatedAt;
  String? providerName;

  bool? isSelected;
  String? deletedAt;

  ProviderAddressMapping({
    this.address,
    this.createdAt,
    this.id,
    this.latitude,
    this.longitude,
    this.providerId,
    this.status,
    this.updatedAt,
    this.providerName,
    this.isSelected,
    this.deletedAt,
  });

  factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    return ProviderAddressMapping(
      address: json['address'],
      createdAt: json['created_at'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      providerId: json['provider_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
      providerName: json['provider_name'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['provider_name'] = this.providerName;
    data['deleted_at'] = this.deletedAt;

    return data;
  }
}
