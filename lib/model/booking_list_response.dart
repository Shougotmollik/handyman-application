import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/model/pagination_model.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';

class BookingListResponse {
  List<BookingData>? data;
  Pagination? pagination;

  BookingListResponse({required this.data, required this.pagination});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => BookingData.fromJson(i)).toList() : null,
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

class Handyman {
  int? id;
  int? bookingId;
  int? handymanId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  UserData? handyman;

  Handyman({this.id, this.bookingId, this.handymanId, this.createdAt, this.updatedAt, this.deletedAt, this.handyman});

  Handyman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    handyman = json['handyman'] != null ? new UserData.fromJson(json['handyman']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['handyman_id'] = this.handymanId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.toJson();
    }
    return data;
  }
}
