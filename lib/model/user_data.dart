class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  num? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;
  String? uid;
  String? loginType;
  int? serviceAddressId;
  num? providersServiceRating;
  num? handymanRating;
  int? isVerifyProvider;
  int? isHandymanAvailable;
  String? designation;
  String? apiToken;
  String? emailVerifiedAt;
  String? playerId;
  List<String>? userRole;
  int? isUserExist;
  int? handymanTypeId;
  String? password;

  String? verificationId;
  String? otpCode;

  //Local
  bool isActive = false;
  bool isSelected = false;

  UserData({
    this.apiToken,
    this.emailVerifiedAt,
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.providerId,
    this.status,
    this.description,
    this.userType,
    this.email,
    this.contactNumber,
    this.countryId,
    this.stateId,
    this.cityId,
    this.cityName,
    this.address,
    this.providertypeId,
    this.providertype,
    this.isFeatured,
    this.displayName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.profileImage,
    this.timeZone,
    this.uid,
    this.loginType,
    this.serviceAddressId,
    this.lastNotificationSeen,
    this.providersServiceRating,
    this.handymanRating,
    this.isVerifyProvider,
    this.isHandymanAvailable,
    this.designation,
    this.verificationId,
    this.otpCode,
    this.password,
    this.handymanTypeId,
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    isActive = status == 1;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    uid = json['uid'];
    loginType = json['login_type'];
    serviceAddressId = json['service_address_id'];
    lastNotificationSeen = json['last_notification_seen'];
    providersServiceRating = json['providers_service_rating'];
    handymanRating = json['handyman_rating'];
    isVerifyProvider = json['is_verify_provider'];
    isHandymanAvailable = json['isHandymanAvailable'];
    designation = json['designation'];
    apiToken = json['api_token'];
    password = json['password'];
    handymanTypeId = json['handymantype_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['username'] = username;
    map['provider_id'] = providerId;
    map['status'] = status;
    map['description'] = description;
    map['user_type'] = userType;
    map['email'] = email;
    map['contact_number'] = contactNumber;
    map['country_id'] = countryId;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['address'] = address;
    map['providertype_id'] = providertypeId;
    map['providertype'] = providertype;
    map['is_featured'] = isFeatured;
    map['display_name'] = displayName;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['profile_image'] = profileImage;
    map['time_zone'] = timeZone;
    map['uid'] = uid;
    map['login_type'] = loginType;
    map['service_address_id'] = serviceAddressId;
    map['last_notification_seen'] = lastNotificationSeen;
    map['providers_service_rating'] = providersServiceRating;
    map['handyman_rating'] = handymanRating;
    map['is_verify_provider'] = isVerifyProvider;
    map['isHandymanAvailable'] = isHandymanAvailable;
    map['designation'] = designation;
    map['api_token'] = this.apiToken;
    map['password'] = this.password;
    map['handymantype_id'] = this.handymanTypeId;
    return map;
  }
}
