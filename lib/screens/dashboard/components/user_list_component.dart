import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/components/view_all_label_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/screens/user/user_list_screen.dart';
import 'package:handyman_admin_flutter/screens/user/user_widget.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class UserListComponent extends StatelessWidget {
  final List<UserData> list;
  final String userType;

  UserListComponent({required this.list, required this.userType});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();
    return Container(
      color: context.cardColor,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          ViewAllLabel(
            label: userType == USER_TYPE_PROVIDER ? locale.newProvider : locale.newUser,
            list: list,
            onTap: () {
              UserListScreen(type: userType, status: userType == USER_TYPE_PROVIDER ? USER_STATUS_ACTIVE : null).launch(context);
            },
          ).paddingSymmetric(horizontal: 16),
          8.height,
          Stack(
            children: [
              HorizontalList(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (_, index) => UserWidget(data: list[index], width: context.width() * 0.45, onUpdate: () {}).paddingRight(4),
                physics: AlwaysScrollableScrollPhysics(),
              ),
              Observer(
                  builder: (context) => NoDataWidget(
                        title: locale.noDataFound,
                        imageWidget: EmptyStateWidget(),
                      ).center().visible(!appStore.isLoading && list.validate().isEmpty)),
            ],
          ),
        ],
      ),
    );
  }
}
