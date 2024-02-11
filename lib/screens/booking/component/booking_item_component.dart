import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/screens/booking/booking_detail_screen.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/color_extension.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/booking_data_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/model_keys.dart';

class BookingItemComponent extends StatelessWidget {
  final BookingData bookingData;

  BookingItemComponent({required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius()),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImageWidget(
                url: bookingData.serviceAttachments.validate().isNotEmpty ? bookingData.serviceAttachments!.first.validate() : "",
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                radius: defaultRadius,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: bookingData.status.validate().getPaymentStatusBackgroundColor.withOpacity(0.1),
                              borderRadius: radius(8),
                            ),
                            child: Marquee(
                              child: Text(
                                bookingData.status.validate().toBookingStatus(),
                                style: boldTextStyle(color: bookingData.status.validate().getPaymentStatusBackgroundColor, size: 12),
                              ),
                            ),
                          ).flexible(),
                          if (bookingData.isPostJob)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                locale.postJob,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                          if (bookingData.isPackageBooking)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                locale.package,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                        ],
                      ).flexible(),
                      Text('#${bookingData.id.validate()}', style: boldTextStyle(color: primaryColor, size: 14)),
                    ],
                  ),
                  8.height,
                  Marquee(
                    child: Text(
                      bookingData.isPackageBooking ? '${bookingData.bookingPackage!.name.validate()}' : '${bookingData.serviceName.validate()}',
                      style: boldTextStyle(size: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  8.height,
                  if (bookingData.bookingPackage != null)
                    PriceWidget(
                      price: bookingData.totalAmount.validate(),
                      color: primaryColor,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PriceWidget(
                          isFreeService: bookingData.type == SERVICE_TYPE_FREE,
                          price: bookingData.totalAmount.validate(),
                          color: primaryColor,
                        ),
                        if (bookingData.isHourlyService)
                          Row(
                            children: [
                              4.width,
                              PriceWidget(
                                price: bookingData.amount.validate(),
                                color: textSecondaryColorGlobal,
                                isBoldText: false,
                                size: textSecondarySizeGlobal,
                              ),
                              Text(locale.lblHourly, style: secondaryTextStyle()).paddingSymmetric(horizontal: 4),
                            ],
                          )
                        else
                          4.width,
                        if (bookingData.discount.validate() != 0)
                          Row(
                            children: [
                              Text('(${bookingData.discount.validate()}%', style: boldTextStyle(size: 12, color: Colors.green)),
                              Text(' ${locale.off})', style: boldTextStyle(size: 12, color: Colors.green)),
                            ],
                          ),
                      ],
                    ),
                ],
              ).expand(),
            ],
          ).paddingAll(8),
          Container(
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${locale.date} & ${locale.time}', style: secondaryTextStyle(size: 12)),
                    8.width,
                    Text(
                      "${formatDate(bookingData.date.validate(), format: DATE_FORMAT_2)} ${locale.at} ${formatDate(bookingData.date.validate(), format: HOUR_12_FORMAT)}",
                      style: boldTextStyle(size: 12),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ).expand(),
                  ],
                ).paddingAll(8),
                if (bookingData.providerName.validate().isNotEmpty)
                  Column(
                    children: [
                      Divider(height: 0, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(locale.provider, style: secondaryTextStyle(size: 12)),
                          8.width,
                          Text(bookingData.providerName.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.right).flexible(),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
                if (bookingData.handyman.validate().isNotEmpty && bookingData.providerId != bookingData.handyman!.first.handymanId!)
                  Column(
                    children: [
                      Divider(height: 0, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.handyman, style: secondaryTextStyle(size: 12)),
                          Text(bookingData.handyman!.validate().first.handyman!.displayName.validate(), style: boldTextStyle(size: 12)).flexible(),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
                if (bookingData.customerName.validate().isNotEmpty)
                  Column(
                    children: [
                      Divider(height: 0, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.customerName, style: secondaryTextStyle(size: 12)),
                          Text(bookingData.customerName.validate(), style: boldTextStyle(size: 12)).flexible(),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
                if (bookingData.paymentStatus != null && bookingData.status == BookingStatusKeys.complete)
                  Column(
                    children: [
                      Divider(height: 0, color: context.dividerColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.paymentStatus, style: secondaryTextStyle(size: 12)).expand(),
                          Text(
                            buildPaymentStatusWithMethod(bookingData.paymentStatus.validate(), bookingData.paymentMethod.validate()),
                            style: boldTextStyle(size: 12, color: bookingData.paymentStatus.validate() == SERVICE_PAYMENT_STATUS_PAID ? Colors.green : Colors.red),
                          ),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
              ],
            ).paddingAll(8),
          ),
        ],
      ),
    ).onTap(
      () async {
        CommonBookingDetailScreen(bookingId: bookingData.id).launch(context);
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
