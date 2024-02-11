import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/earning_list_response.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/price_widget.dart';
import '../../../utils/constant.dart';

class EarningDetailBottomSheet extends StatelessWidget {
  final EarningModel earningModel;

  const EarningDetailBottomSheet(this.earningModel);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(defaultRadius), backgroundColor: context.cardColor),
        padding: EdgeInsets.all(16),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          width: context.width(),
          decoration: cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.earningDetails, style: boldTextStyle()).paddingAll(16),
              if (earningModel.adminEarning != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.adminEarning, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.adminEarning.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.providerName != null)
                Row(
                  children: [
                    Text(locale.providerName, style: secondaryTextStyle(), textAlign: TextAlign.left).expand(),
                    8.width,
                    Text(earningModel.providerName.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.right).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.commission != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.commission, style: secondaryTextStyle()).expand(),
                    8.width,
                    if (earningModel.commissionType.validate().toLowerCase() == PERCENTAGE.toLowerCase())
                      Text(
                        '${earningModel.commission}%',
                        style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE),
                        textAlign: TextAlign.right,
                      ).expand(),
                    if (earningModel.commissionType.validate().toLowerCase() == FIXED.toLowerCase())
                      Text(
                        "${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${earningModel.commission}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
                        style: boldTextStyle(size: CARD_BOLD_TEXT_STYLE_SIZE),
                        textAlign: TextAlign.right,
                      ).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.totalBookings != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.totalBookings, style: secondaryTextStyle()).expand(),
                    8.width,
                    Text(earningModel.totalBookings.validate().toString(), style: boldTextStyle(size: 12), textAlign: TextAlign.right).expand(),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.totalEarning != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.totalEarnings, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.totalEarning.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.taxes != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.taxes, style: secondaryTextStyle()).expand(),
                    8.width,
                    PriceWidget(
                      price: earningModel.taxes.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              if (earningModel.providerEarning != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.providerEarning, style: secondaryTextStyle()).expand(),
                    PriceWidget(
                      price: earningModel.providerEarning.validate(),
                      color: context.primaryColor,
                      isBoldText: true,
                      size: 14,
                    ),
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 16),
              8.height,
            ],
          ),
        ),
      ),
    );
  }
}
