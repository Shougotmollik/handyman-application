import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/price_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/model/coupon_model.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/applied_tax_list_bottom_sheet.dart';
import '../../../model/Package_response.dart';
import '../../../model/tax_list_response.dart';
import '../../../utils/colors.dart';
import '../../payment/payment_info_component.dart';

class PriceCommonWidget extends StatelessWidget {
  const PriceCommonWidget({
    Key? key,
    required this.bookingDetail,
    required this.serviceDetail,
    required this.taxes,
    required this.couponData,
    required this.bookingPackage,
  }) : super(key: key);

  final BookingData bookingDetail;
  final ServiceData serviceDetail;
  final List<TaxData> taxes;
  final CouponData? couponData;
  final PackageData? bookingPackage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(locale.priceDetail, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        if (bookingPackage != null)
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(locale.price, style: secondaryTextStyle(size: 14)).expand(),
                    16.width,
                    PriceWidget(price: bookingPackage!.price.validate(), color: textPrimaryColorGlobal, isBoldText: true),
                  ],
                ),
                if (bookingDetail.totalExtraChargeAmount != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        children: [
                          Text(locale.totalExtraCharges, style: secondaryTextStyle(size: 14)).expand(),
                          PriceWidget(price: bookingDetail.totalExtraChargeAmount, color: textPrimaryColorGlobal),
                        ],
                      ),
                    ],
                  ),
                if (bookingDetail.finalTotalTax.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.tax, style: secondaryTextStyle(size: 14)),
                          16.width,
                          PriceWidget(price: bookingDetail.finalTotalTax.validate(), color: Colors.red, isBoldText: true),
                        ],
                      ),
                    ],
                  ),
                Column(
                  children: [
                    Divider(height: 26, color: context.dividerColor),
                    Row(
                      children: [
                        Text(locale.totalAmount, style: secondaryTextStyle(size: 14)).expand(),
                        PriceWidget(
                          price: bookingDetail.totalAmount.validate(),
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              children: [
                if (bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(locale.price, style: secondaryTextStyle(size: 14)).expand(),
                          16.width,
                          if (bookingDetail.isFixedService)
                            Marquee(
                              child: Row(
                                children: [
                                  PriceWidget(price: bookingDetail.amount.validate(), size: 12, isBoldText: false, color: appTextSecondaryColor),
                                  Text(' * ${bookingDetail.quantity != 0 ? bookingDetail.quantity : 1}  = ', style: secondaryTextStyle()),
                                  PriceWidget(price: bookingDetail.finalTotalServicePrice.validate(), isBoldText: true, color: textPrimaryColorGlobal),
                                ],
                              ),
                            )
                          else
                            PriceWidget(price: bookingDetail.finalTotalServicePrice.validate(), color: textPrimaryColorGlobal, isBoldText: true),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),
                if (bookingDetail.finalDiscountAmount != 0 && bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: locale.discount, style: secondaryTextStyle(size: 14)),
                                TextSpan(
                                  text: " (${bookingDetail.discount.validate()}% ${locale.off.toLowerCase()}) ",
                                  style: boldTextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ).expand(),
                          16.width,
                          PriceWidget(
                            price: bookingDetail.finalDiscountAmount.validate(),
                            color: Colors.green,
                            isBoldText: true,
                            isDiscountedPrice: true,
                          ),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),
                if (couponData != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(locale.coupon, style: secondaryTextStyle(size: 14)),
                          Text(" (${couponData!.code})", style: boldTextStyle(size: 14, color: primaryColor)).expand(),
                          PriceWidget(price: bookingDetail.finalCouponDiscountAmount.validate(), color: Colors.green, isBoldText: true, isDiscountedPrice: true),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),
                if ((bookingDetail.isHourlyService || bookingDetail.isFixedService) && bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.subTotal, style: secondaryTextStyle(size: 14)).flexible(fit: FlexFit.loose),
                          PriceWidget(price: bookingDetail.finalSubTotal.validate(), color: textPrimaryColorGlobal, isBoldText: true),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),
                if (bookingDetail.totalExtraChargeAmount != 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        children: [
                          Text(locale.totalExtraCharges, style: secondaryTextStyle(size: 14)).expand(),
                          PriceWidget(price: bookingDetail.totalExtraChargeAmount, color: textPrimaryColorGlobal),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),

                if (bookingDetail.finalTotalTax.validate() != 0 && bookingDetail.bookingType.validate() == BOOKING_TYPE_SERVICE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(locale.tax, style: secondaryTextStyle(size: 14)).expand(),
                              Icon(Icons.info_outline_rounded, size: 20, color: context.primaryColor).onTap(
                                () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return AppliedTaxListBottomSheet(taxes: bookingDetail.taxes.validate(), subTotal: bookingDetail.finalSubTotal.validate() + bookingDetail.totalExtraChargeAmount);
                                    },
                                  );
                                },
                              ),
                            ],
                          ).expand(),
                          //Text(language.lblTax, style: secondaryTextStyle(size: 14)),
                          16.width,
                          PriceWidget(price: bookingDetail.finalTotalTax.validate(), color: Colors.red, isBoldText: true),
                        ],
                      ),
                      Divider(height: 26, color: context.dividerColor),
                    ],
                  ),

                /// Final Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIcon(
                      text: '${locale.totalAmount}',
                      textStyle: secondaryTextStyle(size: 14),
                      edgeInsets: EdgeInsets.zero,
                      expandedText: true,
                      maxLine: 2,
                    ).expand(flex: 2),
                    Marquee(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          16.width,
                          if (bookingDetail.isHourlyService)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('(', style: secondaryTextStyle()),
                                PriceWidget(price: bookingDetail.amount.validate(), color: appTextSecondaryColor, size: 14, isBoldText: false),
                                Text('/${locale.hr})', style: secondaryTextStyle()),
                              ],
                            ),
                          8.width,
                          PriceWidget(price: bookingDetail.totalAmount.validate(), color: primaryColor)
                        ],
                      ),
                    ).flexible(flex: 3),
                  ],
                ),
                if (serviceDetail.isAdvancePayment)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(text: bookingDetail.paidAmount.validate() != 0 ? locale.advancePaid : locale.advancePayment, style: secondaryTextStyle(size: 14)),
                            TextSpan(
                              text: " (${serviceDetail.advancePaymentPercentage.validate().toString()}%)  ",
                              style: boldTextStyle(color: Colors.green),
                            ),
                          ])).expand(),
                          PriceWidget(price: getAdvancePaymentAmount, color: primaryColor),
                        ],
                      ),
                    ],
                  ),
                if (serviceDetail.isAdvancePayment && bookingDetail.paidAmount.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextIcon(
                            text: '${locale.remainingAmount}',
                            textStyle: secondaryTextStyle(size: 14),
                            edgeInsets: EdgeInsets.zero,
                            suffix: Icon(Icons.info_outline_rounded, size: 20, color: context.primaryColor),
                            expandedText: true,
                            maxLine: 3,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return PaymentInfoComponent(bookingDetail.id!);
                                },
                              );
                            },
                          ).expand(),
                          8.width,
                          bookingDetail.status == BookingStatusKeys.complete && bookingDetail.paymentStatus == SERVICE_PAYMENT_STATUS_PAID
                              ? PriceWidget(price: 0, color: primaryColor)
                              : PriceWidget(price: getRemainingAmount, color: primaryColor),
                        ],
                      ),
                    ],
                  ),
                if (bookingDetail.isHourlyService && bookingDetail.status == BookingStatusKeys.complete)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Divider(height: 26, color: context.dividerColor),
                        Text(
                          "${locale.onBasisOf} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  num get getAdvancePaymentAmount {
    if (bookingDetail.paidAmount.validate() != 0) {
      return bookingDetail.paidAmount!;
    } else {
      return bookingDetail.totalAmount.validate() * serviceDetail.advancePaymentPercentage.validate() / 100;
    }
  }

  num get getRemainingAmount {
    return bookingDetail.totalAmount.validate() - getAdvancePaymentAmount;
  }

  String getMinHour({required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return "min";
    } else {
      return "hour";
    }
  }
}
