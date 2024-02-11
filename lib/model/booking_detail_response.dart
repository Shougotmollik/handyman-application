import 'package:handyman_admin_flutter/model/post_job_data.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/model/tax_list_response.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';

import 'booking_data_model.dart';
import 'coupon_model.dart';
import 'service_detail_response.dart';

class BookingDetailResponse {
  BookingData? bookingDetail;
  ServiceData? service;
  UserData? customer;
  List<BookingActivity>? bookingActivity;

  List<RatingData>? ratingData;
  UserData? providerData;
  List<UserData>? handymanData;
  CouponData? couponData;
  List<TaxData>? taxes;
  List<ServiceProof>? serviceProof;
  PostJobData? postRequestDetail;

  BookingDetailResponse({
    this.bookingDetail,
    this.service,
    this.customer,
    this.bookingActivity,
    this.ratingData,
    this.providerData,
    this.handymanData,
    this.couponData,
    this.taxes,
    this.postRequestDetail,
    this.serviceProof,
  });

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? new BookingData.fromJson(json['booking_detail']) : null;
    service = json['service'] != null ? new ServiceData.fromJson(json['service']) : null;
    customer = json['customer'] != null ? new UserData.fromJson(json['customer']) : null;
    if (json['booking_activity'] != null) {
      bookingActivity = [];
      json['booking_activity'].forEach((v) {
        bookingActivity!.add(new BookingActivity.fromJson(v));
      });
    }
    providerData = json['provider_data'] != null ? new UserData.fromJson(json['provider_data']) : null;
    if (json['rating_data'] != null) {
      ratingData = [];
      json['rating_data'].forEach((v) {
        ratingData!.add(new RatingData.fromJson(v));
      });
    }
    couponData = json['coupon_data'] != null ? new CouponData.fromJson(json['coupon_data']) : null;
    postRequestDetail = json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null;

    if (json['handyman_data'] != null) {
      handymanData = [];
      json['handyman_data'].forEach((v) {
        handymanData!.add(new UserData.fromJson(v));
      });
    }
    if (json['service_proof'] != null) {
      serviceProof = [];
      json['service_proof'].forEach((v) {
        serviceProof!.add(new ServiceProof.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingDetail != null) {
      data['booking_detail'] = this.bookingDetail!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.bookingActivity != null) {
      data['booking_activity'] = this.bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.providerData != null) {
      data['provider_data'] = this.providerData!.toJson();
    }
    if (this.handymanData != null) {
      data['handyman_data'] = this.handymanData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceProof != null) {
      data['service_proof'] = this.serviceProof!.map((v) => v.toJson()).toList();
    }
    if (postRequestDetail != null) {
      data['post_request_detail'] = postRequestDetail?.toJson();
    }
    return data;
  }
}

class BookingActivity {
  int? id;
  int? bookingId;
  String? datetime;
  String? activityType;
  String? activityMessage;
  String? activityData;
  String? createdAt;
  String? updatedAt;

  BookingActivity({this.id, this.bookingId, this.datetime, this.activityType, this.activityMessage, this.activityData, this.createdAt, this.updatedAt});

  BookingActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    datetime = json['datetime'];
    activityType = json['activity_type'];
    activityMessage = json['activity_message'];
    activityData = json['activity_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['datetime'] = this.datetime;
    data['activity_type'] = this.activityType;
    data['activity_message'] = this.activityMessage;
    data['activity_data'] = this.activityData;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ServiceProof {
  int? id;
  String? title;
  String? description;
  int? serviceId;
  int? bookingId;
  int? userId;
  String? handymanName;
  String? serviceName;
  List<String>? attachments;

  ServiceProof({
    this.id,
    this.title,
    this.description,
    this.serviceId,
    this.bookingId,
    this.userId,
    this.handymanName,
    this.serviceName,
    this.attachments,
  });

  ServiceProof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    handymanName = json['handyman_name'];
    serviceName = json['service_name'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['handyman_name'] = this.handymanName;
    data['service_name'] = this.serviceName;
    data['attachments'] = this.attachments;
    return data;
  }
}
