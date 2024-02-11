import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/handyman_name_widget.dart';
import 'package:handyman_admin_flutter/components/image_border_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class BasicInfoComponent extends StatefulWidget {
  final UserData? handymanData;
  final UserData? customerData;
  final UserData? providerData;
  final ServiceData? service;

  /// flag == 0 = customer
  /// flag == 1 = handyman
  /// else provider
  final int flag;
  final BookingData? bookingDetail;

  BasicInfoComponent(this.flag, {this.customerData, this.handymanData, this.providerData, this.service, this.bookingDetail});

  @override
  BasicInfoComponentState createState() => BasicInfoComponentState();
}

class BasicInfoComponentState extends State<BasicInfoComponent> {
  UserData customer = UserData();
  UserData provider = UserData();
  UserData userData = UserData();
  ServiceData service = ServiceData();

  String googleUrl = '';
  String address = '';
  String name = '';
  String contactNumber = '';
  String profileUrl = '';
  String email = '';
  String designation = '';
  int? profileId;
  int? handymanRating;

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.flag == 0) {
      profileId = widget.customerData!.id.validate();
      name = widget.customerData!.displayName.validate();
      profileUrl = widget.customerData!.profileImage.validate();
      contactNumber = widget.customerData!.contactNumber.validate();
      address = widget.customerData!.address.validate();
      email = widget.customerData!.email.validate();

      userData = widget.customerData!;
      /*await userService.getUser(email: widget.customerData!.email.validate()).then((value) {
        widget.customerData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });*/
    } else if (widget.flag == 1) {
      profileId = widget.handymanData!.id.validate();
      name = widget.handymanData!.displayName.validate();
      profileUrl = widget.handymanData!.profileImage.validate();
      contactNumber = widget.handymanData!.contactNumber.validate();
      address = widget.handymanData!.address.validate();
      email = widget.handymanData!.email.validate();
      designation = widget.handymanData!.designation.validate();

      userData = widget.handymanData!;
      /*await userService.getUser(email: widget.handymanData!.email.validate()).then((value) {
        widget.handymanData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });*/
    } else {
      profileId = widget.providerData!.id.validate();
      name = widget.providerData!.displayName.validate();
      profileUrl = widget.providerData!.profileImage.validate();
      contactNumber = widget.providerData!.contactNumber.validate();
      address = widget.providerData!.address.validate();
      email = widget.providerData!.email.validate();
      provider = widget.providerData!;
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (profileUrl.validate().isNotEmpty) ImageBorder(src: profileUrl.validate(), height: 50),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Marquee(
                        child: HandymanNameWidget(name: name.validate()),
                      ),
                    ],
                  ).expand(),
                ],
              ),
              16.height,
              TextIcon(
                spacing: 10,
                onTap: () {
                  launchMail(email);
                },
                prefix: Image.asset(ic_message, width: 14, height: 14, color: appStore.isDarkMode ? Colors.white : Colors.black),
                text: email,
                expandedText: true,
              ),
              if (contactNumber.isNotEmpty)
                Column(
                  children: [
                    8.height,
                    TextIcon(
                      spacing: 10,
                      onTap: () {
                        launchCall(contactNumber);
                      },
                      prefix: Image.asset(calling, width: 14, height: 14, color: appStore.isDarkMode ? Colors.white : Colors.black),
                      text: contactNumber,
                    ),
                  ],
                ),
              if (address.isNotEmpty)
                Column(
                  children: [
                    8.height,
                    TextIcon(
                      spacing: 8,
                      onTap: () {
                        launchMap(address);
                      },
                      expandedText: true,
                      prefix: Image.asset(ic_location, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : Colors.black),
                      text: address,
                    ),
                  ],
                ),
              if (userData.createdAt != null)
                Column(
                  children: [
                    6.height,
                    TextIcon(
                      spacing: 10,
                      expandedText: true,
                      prefix: Image.asset(ic_watch, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : Colors.black),
                      text: '${DateTime.parse(userData.createdAt.validate()).year}',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
