import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class UserNameWidget extends StatelessWidget {
  final UserData data;
  final int size;
  final MainAxisAlignment mainAxisAlignment;

  UserNameWidget({
    required this.data,
    this.size = 18,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (data.isHandymanAvailable != null && data.userType == USER_TYPE_HANDYMAN)
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: data.isHandymanAvailable == 1 ? Colors.lightGreen : redColor,
                  shape: BoxShape.circle,
                ),
              ),
              8.width,
            ],
          ),
        Marquee(child: Text(data.displayName.validate(), style: boldTextStyle(size: size), maxLines: 1)).flexible(),
      ],
    );
  }
}
