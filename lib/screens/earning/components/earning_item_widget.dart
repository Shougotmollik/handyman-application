import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/screens/earning/add_provider_payout.dart';
import 'package:handyman_admin_flutter/screens/earning/components/earning_detail_bottomsheet.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/earning_list_response.dart';
import '../../../utils/colors.dart';

class EarningItemWidget extends StatelessWidget {
  final EarningModel earningModel;
  final VoidCallback? onUpdate;

  const EarningItemWidget(this.earningModel, {this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: context.width(),
      decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(), color: context.cardColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(ic_profile, height: 18, color: context.primaryColor),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locale.providerName, style: secondaryTextStyle()),
                      4.height,
                      Text(earningModel.providerName.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.right),
                    ],
                  ).expand(),
                ],
              ).expand(),
              IconButton(
                icon: Icon(Icons.info_outline_rounded, size: 22),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return EarningDetailBottomSheet(earningModel);
                    },
                  );
                },
              ),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Image.asset(ic_wallet, height: 16, color: context.primaryColor),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.totalEarnings, style: secondaryTextStyle()),
                  4.height,
                  PriceWidget(
                    price: earningModel.totalEarning.validate(),
                    color: context.primaryColor,
                    isBoldText: true,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Image.asset(ic_wallet, height: 16, color: context.primaryColor),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.myEarning, style: secondaryTextStyle()),
                  4.height,
                  PriceWidget(
                    price: earningModel.adminEarning.validate(),
                    color: context.primaryColor,
                    isBoldText: true,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          Divider(color: context.dividerColor, thickness: 1.0, height: 20),
          Row(
            children: [
              Image.asset(ic_wallet, height: 16, color: context.primaryColor),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.providerEarning, style: secondaryTextStyle()),
                  4.height,
                  PriceWidget(
                    price: earningModel.providerEarning.validate(),
                    color: context.primaryColor,
                    isBoldText: true,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          if (earningModel.providerEarningFormate.validate() > 0)
            AppButton(
              text: locale.payout,
              color: primaryColor,
              width: context.width(),
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.zero,
              onTap: () {
                ifNotTester(context, () async {
                  bool? res = await AddProviderPayout(earningModel: earningModel).launch(context);

                  if (res ?? false) {
                    onUpdate?.call();
                  }
                });
              },
            ),
        ],
      ),
    ).onTap(
      () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) {
            return EarningDetailBottomSheet(earningModel);
          },
        );
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
