import 'package:handyman_admin_flutter/model/Package_response.dart';
import 'package:handyman_admin_flutter/model/attachment_model.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/model/service_address_mapping_model.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

class ServiceData {
  int? id;
  String? name;
  int? categoryId;
  int? subCategoryId;
  int? providerId;
  num? price;
  var priceFormat;
  String? type;
  num? discount;
  String? duration;
  int? status;
  String? description;
  int? isFeatured;
  String? providerName;
  String? providerImage;
  int? cityId;
  String? categoryName;
  String? subCategoryName;
  List<String>? imageAttachments;
  List<Attachments>? attchments;
  num? totalReview;
  num? totalRating;
  int? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<PackageData>? servicePackage;

  //Set Values
  num? totalAmount;
  num? discountPrice;
  num? taxAmount;
  num? couponDiscountAmount;
  String? dateTimeVal;
  String? couponId;
  num? qty;
  String? address;
  int? bookingAddressId;
  CouponData? appliedCouponData;

  num? advancePaymentSetting;
  num? isEnableAdvancePayment;
  num? advancePaymentAmount;
  num? advancePaymentPercentage;
  bool? isDigitalService;
  String? visitType;

  //Local
  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;
  bool isSelected = false;

  bool get isFreeService => price.validate() == 0;

  bool get isAdvancePayment => isEnableAdvancePayment.validate() == 1;

  bool get isAdvancePaymentSetting => advancePaymentSetting.validate() == 1;

  bool get isOnlineService => visitType == VISIT_OPTION_ONLINE;

  bool get isOnSiteService => visitType == VISIT_OPTION_ON_SITE;

  ServiceData({
    this.id,
    this.name,
    this.imageAttachments,
    this.categoryId,
    this.providerId,
    this.price,
    this.priceFormat,
    this.type,
    this.discount,
    this.duration,
    this.status,
    this.description,
    this.isFeatured,
    this.providerName,
    this.providerImage,
    this.cityId,
    this.categoryName,
    this.attchments,
    this.totalReview,
    this.totalRating,
    this.isFavourite,
    this.serviceAddressMapping,
    this.totalAmount,
    this.discountPrice,
    this.taxAmount,
    this.couponDiscountAmount,
    this.dateTimeVal,
    this.couponId,
    this.qty,
    this.address,
    this.bookingAddressId,
    this.appliedCouponData,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subCategoryName,
    this.subCategoryId,
    this.servicePackage,
    this.advancePaymentSetting,
    this.isEnableAdvancePayment,
    this.advancePaymentAmount,
    this.advancePaymentPercentage,
    this.isDigitalService,
    this.visitType,
  });

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    providerImage = json['provider_image'];
    categoryId = json['category_id'];
    providerId = json['provider_id'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    discount = json['discount'];
    duration = json['duration'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    providerName = json['provider_name'];
    cityId = json['city_id'];
    categoryName = json['category_name'];
    //image_attchments = json['attchments'];
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;

    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    isFavourite = json['is_favourite'];
    if (json['service_address_mapping'] != null) {
      serviceAddressMapping = [];
      json['service_address_mapping'].forEach((v) {
        serviceAddressMapping!.add(new ServiceAddressMapping.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    subCategoryName = json['subcategory_name'];
    subCategoryId = json['subcategory_id'];
    servicePackage = json['servicePackage'] != null ? (json['servicePackage'] as List).map((i) => PackageData.fromJson(i)).toList() : null;

    advancePaymentSetting = json[AdvancePaymentKey.advancePaymentSetting];
    isEnableAdvancePayment = json[AdvancePaymentKey.isEnableAdvancePayment];
    advancePaymentAmount = json[AdvancePaymentKey.advancePaymentAmount];
    advancePaymentPercentage = json[AdvancePaymentKey.advancePaymentAmount];
    isDigitalService = json['digital_service'] == 1;
    visitType = json['visit_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['provider_image'] = this.providerImage;
    data['category_id'] = this.categoryId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['provider_name'] = this.providerName;
    data['city_id'] = this.cityId;
    data['category_name'] = this.categoryName;
    if (this.imageAttachments != null) {
      data['attchments'] = this.imageAttachments;
    }
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['is_favourite'] = this.isFavourite;
    if (this.serviceAddressMapping != null) {
      data['service_address_mapping'] = this.serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['subcategory_name'] = subCategoryName;
    data['subcategory_id'] = subCategoryId;
    if (this.servicePackage != null) {
      data['servicePackage'] = this.servicePackage!.map((v) => v.toJson()).toList();
    }
    data[AdvancePaymentKey.advancePaymentSetting] = this.advancePaymentSetting;
    data[AdvancePaymentKey.isEnableAdvancePayment] = this.isEnableAdvancePayment;
    data[AdvancePaymentKey.advancePaymentAmount] = this.advancePaymentAmount;
    data[AdvancePaymentKey.advancePaymentAmount] = this.advancePaymentPercentage;
    data['digital_service'] = this.isDigitalService;
    data['visit_type'] = this.visitType;

    return data;
  }
}
