class EarningModel {
  int? providerId;
  String? providerName;
  num? commission;
  String? commissionType;
  num? totalBookings;
  num? totalEarning;
  num? taxes;
  num? adminEarning;
  num? providerEarning;
  num? providerEarningFormate;

  EarningModel({this.adminEarning, this.commission, this.commissionType, this.providerEarning, this.providerEarningFormate, this.providerId, this.providerName, this.taxes, this.totalBookings, this.totalEarning});

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      commission: json['commission'],
      providerEarning: json['provider_earning'],
      providerEarningFormate: json['provider_earning_formate'],
      providerId: json['provider_id'],
      commissionType: json['commission_type'],
      providerName: json['provider_name'],
      taxes: json['taxes'],
      adminEarning: json['admin_earning'],
      totalBookings: json['total_bookings'],
      totalEarning: json['total_earning'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_earning'] = this.adminEarning;
    data['commission'] = this.commission;
    data['provider_earning'] = this.providerEarning;
    data['provider_earning_formate'] = this.providerEarningFormate;
    data['commission_type'] = this.commissionType;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['taxes'] = this.taxes;
    data['total_bookings'] = this.totalBookings;
    data['total_earning'] = this.totalEarning;
    return data;
  }
}
