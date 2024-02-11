class TypeListResponse {
  List<TypeDataModel>? data;

  TypeListResponse({this.data});

  factory TypeListResponse.fromJson(Map<String, dynamic> json) {
    return TypeListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => TypeDataModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeDataModel {
  int? id;
  String? name;
  int? commission;
  String? type;
  int? status;
  String? updatedAt;
  String? createdAt;
  String? deletedAt;

  TypeDataModel({
    this.id,
    this.name,
    this.commission,
    this.type,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
  });

  factory TypeDataModel.fromJson(Map<String, dynamic> json) {
    return TypeDataModel(
      id: json['id'],
      name: json['name'],
      commission: json['commission'],
      type: json['type'],
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['commission'] = this.commission;
    data['type'] = this.type;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;

    return data;
  }
}
