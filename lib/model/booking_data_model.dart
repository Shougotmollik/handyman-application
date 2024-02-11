import 'package:handyman_admin_flutter/model/tax_list_response.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';
import 'Package_response.dart';
import 'booking_list_response.dart';
import 'coupon_model.dart';
import 'extra_charges_model.dart';

class BookingData {
  int? id;
  String? address;
  int? customerId;
  String? customerName;
  int? serviceId;
  int? providerId;
  int? quantity;
  int? price;
  String? type;
  num? discount;
  num? amount;

  String? statusLabel;
  String? description;
  String? providerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  String? date;
  String? durationDiff;
  int? paymentId;
  int? bookingAddressId;
  String? durationDiffHour;
  num? totalAmount;

  CouponData? couponData;
  List<Handyman>? handyman;
  List<String>? serviceAttachments;
  String? status;
  List<TaxData>? taxes;
  List<ExtraChargesModel>? extraCharges;
  String? bookingType;

  String? reason;
  int? totalReview;
  num? totalRating;
  String? startAt;
  String? endAt;

  PackageData? bookingPackage;

  num? paidAmount;

  num? finalTotalServicePrice;
  num? finalTotalTax;
  num? finalSubTotal;
  num? finalDiscountAmount;
  num? finalCouponDiscountAmount;

  //Local
  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isFreeService => type.validate() == SERVICE_TYPE_FREE;

  double get totalAmountWithExtraCharges => totalAmount.validate() + extraCharges.validate().sumByDouble((e) => e.qty.validate() * e.price.validate());

  bool get isPostJob => bookingType == BOOKING_TYPE_USER_POST_JOB;

  bool get isPackageBooking => bookingPackage != null;

  bool get isFixedService => type.validate() == SERVICE_TYPE_FIXED;

  num get totalExtraChargeAmount => extraCharges.validate().sumByDouble((e) => e.total.validate());

  BookingData({
    this.address,
    this.bookingAddressId,
    this.couponData,
    this.customerId,
    this.customerName,
    this.date,
    this.description,
    this.discount,
    this.amount,
    this.durationDiff,
    this.durationDiffHour,
    this.handyman,
    this.id,
    this.paymentId,
    this.paymentMethod,
    this.paymentStatus,
    this.price,
    this.providerId,
    this.providerName,
    this.quantity,
    this.serviceAttachments,
    this.serviceId,
    this.serviceName,
    this.status,
    this.statusLabel,
    this.taxes,
    this.totalAmount,
    this.type,
    this.reason,
    this.totalReview,
    this.totalRating,
    this.startAt,
    this.endAt,
    this.extraCharges,
    this.bookingType,
    this.bookingPackage,
    this.paidAmount,
    this.finalTotalServicePrice,
    this.finalTotalTax,
    this.finalSubTotal,
    this.finalDiscountAmount,
    this.finalCouponDiscountAmount,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      address: json['address'],
      totalAmount: json['total_amount'],
      bookingAddressId: json['booking_address_id'],
      couponData: json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null,
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: json['discount'],
      amount: json['amount'],
      durationDiff: json['duration_diff'],
      durationDiffHour: json['duration_diff_hour'],
      handyman: json['handyman'] != null ? (json['handyman'] as List).map((i) => Handyman.fromJson(i)).toList() : null,
      id: json['id'],
      paymentId: json['payment_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      price: json['price'],
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      quantity: json['quantity'],
      serviceAttachments: json['service_attchments'] != null ? new List<String>.from(json['service_attchments']) : null,
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      status: json['status'],
      statusLabel: json['status_label'],
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      type: json['type'],
      reason: json['reason'],
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      extraCharges: json['extra_charges'] != null ? (json['extra_charges'] as List).map((i) => ExtraChargesModel.fromJson(i)).toList() : null,
      bookingType: json['booking_type'],
      bookingPackage: json['booking_package'] != null ? PackageData.fromJson(json['booking_package']) : null,
      paidAmount: json[AdvancePaymentKey.advancePaidAmount],
      finalTotalServicePrice: json['final_total_service_price'],
      finalTotalTax: json['final_total_tax'],
      finalSubTotal: json['final_sub_total'],
      finalDiscountAmount: json['final_discount_amount'],
      finalCouponDiscountAmount: json['final_coupon_discount_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['booking_address_id'] = this.bookingAddressId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['total_amount'] = this.totalAmount;
    data['date'] = this.date;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['duration_diff'] = this.durationDiff;
    data['duration_diff_hour'] = this.durationDiffHour;
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['price'] = this.price;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['quantity'] = this.quantity;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['final_total_service_price'] = this.finalTotalServicePrice;
    data['final_total_tax'] = this.finalTotalTax;
    data['final_sub_total'] = this.finalSubTotal;
    data['final_discount_amount'] = this.finalDiscountAmount;
    data['final_coupon_discount_amount'] = this.finalCouponDiscountAmount;
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.map((v) => v.toJson()).toList();
    }
    if (this.serviceAttachments != null) {
      data['service_attchments'] = this.serviceAttachments;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (this.extraCharges != null) {
      data['extra_charges'] = this.extraCharges!.map((v) => v.toJson()).toList();
    }
    data['booking_type'] = this.bookingType;
    if (bookingPackage != null) {
      data['booking_package'] = this.bookingPackage!.toJson();
    }
    data[AdvancePaymentKey.advancePaidAmount] = this.amount;

    return data;
  }
}
