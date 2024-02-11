class WalletListResponse {
  List<WalletData>? walletListData;

  WalletListResponse({this.walletListData});

  factory WalletListResponse.fromJson(Map<String, dynamic> json) {
    return WalletListResponse(
      walletListData: json['data'] != null ? (json['data'] as List).map((i) => WalletData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.walletListData != null) {
      data['data'] = this.walletListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletData {
  num? amount;
  int? id;
  int? status;
  String? title;
  String? name;
  int? userId;

  WalletData({this.amount, this.id, this.status, this.title, this.name, this.userId});

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      amount: json['amount'],
      id: json['id'],
      status: json['status'],
      title: json['title'],
      name: json['name'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['id'] = this.id;
    data['status'] = this.status;
    data['title'] = this.title;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    return data;
  }
}
