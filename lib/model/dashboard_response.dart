import 'package:handyman_admin_flutter/model/post_job_data.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';

import 'booking_data_model.dart';

class DashboardResponse {
  bool? status;
  int? totalBooking;
  int? totalService;
  int? totalProvider;
  var totalRevenue;
  List<int>? monthlyRevenue;
  List<UserData>? provider;
  List<UserData>? user;
  List<BookingData>? upcomingBooking;
  List<Configurations>? configurations;
  int? notificationUnreadCount;
  String? helplineNumber;
  String? inquiryEmail;
  String? earningType;
  PrivacyPolicy? privacyPolicy;
  TermConditions? termConditions;
  List<LanguageOption>? languageOption;
  List<PostJobData>? myPostJobData;
  String? isAdvancedPaymentAllowed;

  DashboardResponse({
    this.status,
    this.totalBooking,
    this.totalService,
    this.totalProvider,
    this.totalRevenue,
    this.monthlyRevenue,
    this.provider,
    this.user,
    this.upcomingBooking,
    this.configurations,
    this.notificationUnreadCount,
    this.helplineNumber,
    this.inquiryEmail,
    this.privacyPolicy,
    this.termConditions,
    this.languageOption,
    this.earningType,
    this.myPostJobData,
    this.isAdvancedPaymentAllowed,
  });

  DashboardResponse.fromJson(dynamic json) {
    status = json['status'];
    totalBooking = json['total_booking'];
    totalService = json['total_service'];
    totalProvider = json['total_provider'];
    totalRevenue = json['total_revenue'] ?? 0;
    monthlyRevenue = json['monthly_revenue'] != null ? json['monthly_revenue'].cast<int>() : [];
    if (json['provider'] != null) {
      provider = [];
      json['provider'].forEach((v) {
        provider?.add(UserData.fromJson(v));
      });
    }
    if (json['user'] != null) {
      user = [];
      json['user'].forEach((v) {
        user?.add(UserData.fromJson(v));
      });
    }
    if (json['upcomming_booking'] != null) {
      upcomingBooking = [];
      json['upcomming_booking'].forEach((v) {
        upcomingBooking?.add(BookingData.fromJson(v));
      });
    }
    if (json['configurations'] != null) {
      configurations = [];
      json['configurations'].forEach((v) {
        configurations?.add(Configurations.fromJson(v));
      });
    }
    notificationUnreadCount = json['notification_unread_count'];
    helplineNumber = json['helpline_number'];
    inquiryEmail = json['inquriy_email'];
    earningType = json['earning_type'];
    privacyPolicy = json['privacy_policy'] != null ? PrivacyPolicy.fromJson(json['privacy_policy']) : null;
    termConditions = json['term_conditions'] != null ? TermConditions.fromJson(json['term_conditions']) : null;
    myPostJobData = json['post_requests'] != null ? (json['post_requests'] as List).map((i) => PostJobData.fromJson(i)).toList() : null;
    if (json['language_option'] != null) {
      languageOption = [];
      json['language_option'].forEach((v) {
        languageOption?.add(LanguageOption.fromJson(v));
      });
    }
    isAdvancedPaymentAllowed = json['is_advanced_payment_allowed'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['total_booking'] = totalBooking;
    map['total_service'] = totalService;
    map['total_provider'] = totalProvider;
    map['total_revenue'] = totalRevenue;
    map['monthly_revenue'] = monthlyRevenue;
    if (provider != null) {
      map['provider'] = provider?.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['user'] = user?.map((v) => v.toJson()).toList();
    }
    if (upcomingBooking != null) {
      map['upcomming_booking'] = upcomingBooking?.map((v) => v.toJson()).toList();
    }
    if (configurations != null) {
      map['configurations'] = configurations?.map((v) => v.toJson()).toList();
    }
    map['notification_unread_count'] = notificationUnreadCount;
    map['helpline_number'] = helplineNumber;
    map['inquriy_email'] = inquiryEmail;
    map['earning_type'] = earningType;
    if (privacyPolicy != null) {
      map['privacy_policy'] = privacyPolicy?.toJson();
    }
    if (termConditions != null) {
      map['term_conditions'] = termConditions?.toJson();
    }
    if (languageOption != null) {
      map['language_option'] = languageOption?.map((v) => v.toJson()).toList();
    }
    if (this.myPostJobData != null) {
      map['post_requests'] = this.myPostJobData!.map((v) => v.toJson()).toList();
    }
    map['is_advanced_payment_allowed'] = this.isAdvancedPaymentAllowed;

    return map;
  }
}

class LanguageOption {
  LanguageOption({
    this.title,
    this.id,
    this.flagImage,
  });

  LanguageOption.fromJson(dynamic json) {
    title = json['title'];
    id = json['id'];
    flagImage = json['flag_image'];
  }

  String? title;
  String? id;
  String? flagImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['id'] = id;
    map['flag_image'] = flagImage;
    return map;
  }
}

class TermConditions {
  TermConditions({
    this.id,
    this.type,
    this.key,
    this.value,
  });

  TermConditions.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    key = json['key'];
    value = json['value'];
  }

  int? id;
  String? type;
  String? key;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}

class PrivacyPolicy {
  PrivacyPolicy({
    this.id,
    this.type,
    this.key,
    this.value,
  });

  PrivacyPolicy.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    key = json['key'];
    value = json['value'];
  }

  int? id;
  String? type;
  String? key;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}

class Configurations {
  Configurations({
    this.id,
    this.type,
    this.key,
    this.value,
    this.country,
  });

  Configurations.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    key = json['key'];
    value = json['value'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  int? id;
  String? type;
  String? key;
  String? value;
  Country? country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['key'] = key;
    map['value'] = value;
    if (country != null) {
      map['country'] = country?.toJson();
    }
    return map;
  }
}

class Country {
  Country({
    this.id,
    this.code,
    this.name,
    this.dialCode,
    this.currencyName,
    this.symbol,
    this.currencyCode,
  });

  Country.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    dialCode = json['dial_code'];
    currencyName = json['currency_name'];
    symbol = json['symbol'];
    currencyCode = json['currency_code'];
  }

  int? id;
  String? code;
  String? name;
  int? dialCode;
  String? currencyName;
  String? symbol;
  String? currencyCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['name'] = name;
    map['dial_code'] = dialCode;
    map['currency_name'] = currencyName;
    map['symbol'] = symbol;
    map['currency_code'] = currencyCode;
    return map;
  }
}
