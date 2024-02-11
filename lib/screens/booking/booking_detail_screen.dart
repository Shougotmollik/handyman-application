import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/basic_info_component.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/components/view_all_label_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/model/booking_detail_response.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/booking/component/booking_detail_provider_widget.dart';
import 'package:handyman_admin_flutter/screens/booking/component/booking_history_bottom_sheet.dart';
import 'package:handyman_admin_flutter/screens/booking/component/countdown_widget.dart';
import 'package:handyman_admin_flutter/screens/booking/component/price_common_widget.dart';
import 'package:handyman_admin_flutter/screens/booking/component/review_list_view_component.dart';
import 'package:handyman_admin_flutter/screens/booking/component/service_proof_list_widget.dart';
import 'package:handyman_admin_flutter/screens/review/rating_view_all_screen.dart';
import 'package:handyman_admin_flutter/screens/service/service_detail_screen.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/price_widget.dart';
import '../../model/Package_response.dart';
import '../../model/extra_charges_model.dart';

class CommonBookingDetailScreen extends StatefulWidget {
  final int? bookingId;

  CommonBookingDetailScreen({required this.bookingId});

  @override
  CommonBookingDetailScreenState createState() => CommonBookingDetailScreenState();
}

class CommonBookingDetailScreenState extends State<CommonBookingDetailScreen> {
  late Future<BookingDetailResponse> future;

  GlobalKey countDownKey = GlobalKey();
  String? startDateTime = '';
  String? endDateTime = '';
  String? timeInterval = '0';
  String? paymentStatus = '';

  bool? confirmPaymentBtn = false;
  bool isCompleted = false;
  bool showBottomActionBar = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    future = bookingDetail({CommonKeys.bookingId: widget.bookingId.toString()});
    setState(() {});
  }

  Widget _serviceDetailWidget({required BookingData bookingDetail, required ServiceData serviceDetail}) {
    return GestureDetector(
      onTap: () {
        ServiceDetailScreen(
          serviceId: bookingDetail.serviceId.validate(),
        ).launch(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookingDetail.isPackageBooking)
                Text(
                  bookingDetail.bookingPackage!.name.validate(),
                  style: boldTextStyle(size: LABEL_TEXT_SIZE),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  bookingDetail.serviceName.validate(),
                  style: boldTextStyle(size: LABEL_TEXT_SIZE),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              16.height,
              if ((bookingDetail.date.validate().isNotEmpty))
                Row(
                  children: [
                    Text('${locale.date}: ', style: secondaryTextStyle()),
                    Text(
                      formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_2),
                      style: boldTextStyle(size: 14),
                    ),
                  ],
                ),
              8.height,
              if ((bookingDetail.date.validate().isNotEmpty))
                Row(
                  children: [
                    Text("${locale.time}: ", style: secondaryTextStyle()),
                    Text(
                      formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_3),
                      style: boldTextStyle(size: 14),
                    ),
                  ],
                ),
            ],
          ).expand(),
          if (serviceDetail.attchments!.isNotEmpty && !bookingDetail.isPackageBooking)
            CachedImageWidget(
              url: serviceDetail.attchments!.isNotEmpty ? serviceDetail.attchments!.first.url.validate() : "",
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              radius: 8,
            )
          else
            CachedImageWidget(
              url: bookingDetail.bookingPackage != null
                  ? bookingDetail.bookingPackage!.imageAttachments.validate().isNotEmpty
                      ? bookingDetail.bookingPackage!.imageAttachments.validate().first.validate().isNotEmpty
                          ? bookingDetail.bookingPackage!.imageAttachments.validate().first.validate()
                          : ''
                      : ''
                  : '',
              height: 90,
              width: 90,
              fit: BoxFit.cover,
              radius: 8,
            ),
        ],
      ),
    );
  }

  Widget _buildCounterWidget({required BookingDetailResponse value}) {
    if (value.bookingDetail!.isHourlyService &&
        (value.bookingDetail!.status == BookingStatusKeys.inProgress ||
            value.bookingDetail!.status == BookingStatusKeys.hold ||
            value.bookingDetail!.status == BookingStatusKeys.complete ||
            value.bookingDetail!.status == BookingStatusKeys.onGoing))
      return CountdownWidget(bookingDetailResponse: value, key: countDownKey).paddingSymmetric(horizontal: 16);
    else
      return Offstage();
  }

  Widget _buildReasonWidget({required BookingDetailResponse snap}) {
    if ((snap.bookingDetail!.status == BookingStatusKeys.cancelled || snap.bookingDetail!.status == BookingStatusKeys.rejected || snap.bookingDetail!.status == BookingStatusKeys.failed) &&
        ((snap.bookingDetail!.reason != null && snap.bookingDetail!.reason!.isNotEmpty)))
      return Container(
        padding: EdgeInsets.all(16),
        color: redColor.withOpacity(0.1),
        width: context.width(),
        child: Text(
          '${locale.reason}: ${snap.bookingDetail!.reason.validate()}',
          style: primaryTextStyle(color: redColor, size: 18),
        ),
      );

    return SizedBox();
  }

  Widget _customerReviewWidget({required BookingDetailResponse bookingDetailResponse}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bookingDetailResponse.ratingData!.isNotEmpty)
          ViewAllLabel(
            label: '${locale.reviews} (${bookingDetailResponse.bookingDetail!.totalReview})',
            list: bookingDetailResponse.ratingData!,
            onTap: () {
              RatingViewAllScreen(serviceId: bookingDetailResponse.service!.id!).launch(context);
            },
          ),
        8.height,
        ReviewListViewComponent(
          ratings: bookingDetailResponse.ratingData!,
          padding: EdgeInsets.symmetric(vertical: 6),
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    ).paddingSymmetric(horizontal: 16).visible(bookingDetailResponse.service!.totalRating != null);
  }

  Widget descriptionWidget({required BookingDetailResponse value}) {
    if (value.bookingDetail!.description.validate().isNotEmpty)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.height,
            Text("${locale.booking} ${locale.description}", style: boldTextStyle(size: LABEL_TEXT_SIZE)),
            8.height,
            ReadMoreText(
              value.bookingDetail!.description.validate(),
              style: secondaryTextStyle(),
              colorClickableText: context.primaryColor,
            ),
            8.height,
          ],
        ),
      );
    else
      return Offstage();
  }

  Widget customerServiceList({required List<ServiceData> serviceList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.height,
        Text(locale.services, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        8.height,
        AnimatedListView(
          itemCount: serviceList.length,
          shrinkWrap: true,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, i) {
            ServiceData data = serviceList[i];

            return Container(
              width: context.width(),
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Text(data.name.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                ],
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget packageWidget({required PackageData package}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(locale.includedInThisPackage, style: boldTextStyle()).paddingSymmetric(horizontal: 16, vertical: 8),
        AnimatedListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          itemCount: package.serviceList!.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, i) {
            ServiceData data = package.serviceList![i];

            return Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    radius: 8,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name.validate(), style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      4.height,
                      if (data.subCategoryName.validate().isNotEmpty)
                        Marquee(
                          child: Row(
                            children: [
                              Text('${data.categoryName}', style: boldTextStyle(color: textSecondaryColorGlobal)),
                              Text('  >  ', style: boldTextStyle(color: textSecondaryColorGlobal)),
                              Text('${data.subCategoryName}', style: boldTextStyle(color: context.primaryColor)),
                            ],
                          ),
                        )
                      else
                        Text('${data.categoryName}', style: secondaryTextStyle()),
                      4.height,
                      PriceWidget(
                        price: data.price.validate(),
                        hourlyTextColor: Colors.white,
                      ),
                    ],
                  ).flexible()
                ],
              ),
            ).onTap(() {
              ServiceDetailScreen(serviceId: data.id!).launch(context);
            });
          },
        )
      ],
    );
  }

  Widget providerWidget({required UserData? providerData, required ServiceData serviceDetail}) {
    if (providerData == null) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(locale.aboutProvider, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        BookingDetailProviderWidget(providerData: providerData),
      ],
    ).paddingOnly(left: 16, right: 16, bottom: 16);
  }

  Widget extraChargesWidget({required List<ExtraChargesModel> extraChargesList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(locale.extraCharges, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        Container(
          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: extraChargesList.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              ExtraChargesModel data = extraChargesList[i];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data.title.validate(), style: secondaryTextStyle(size: 14)).expand(),
                      16.width,
                      Row(
                        children: [
                          Text('${data.qty} * ${data.price.validate()} = ', style: secondaryTextStyle()),
                          4.width,
                          PriceWidget(price: '${data.price.validate() * data.qty.validate()}'.toDouble(), color: textPrimaryColorGlobal, isBoldText: true),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<BookingDetailResponse> res) {
      if (res.hasError) {
        return Text(res.error.toString()).center();
      } else if (res.hasData) {
        countDownKey = GlobalKey();
        return Stack(
          children: [
            Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Show Reason if booking is canceled
                      _buildReasonWidget(snap: res.data!),

                      /// Booking & Service Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.bookingId,
                                style: boldTextStyle(size: LABEL_TEXT_SIZE, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                              ),
                              Text('#' + res.data!.bookingDetail!.id.toString().validate(), style: boldTextStyle(color: primaryColor, size: LABEL_TEXT_SIZE)),
                            ],
                          ),
                          16.height,
                          Divider(height: 0, color: context.dividerColor),
                          24.height,
                          _serviceDetailWidget(serviceDetail: res.data!.service!, bookingDetail: res.data!.bookingDetail!)
                        ],
                      ).paddingAll(16),

                      /// Total Service Time
                      _buildCounterWidget(value: res.data!),

                      ///Description Widget
                      descriptionWidget(value: res.data!),

                      /// My Service List
                      if (res.data!.postRequestDetail != null && res.data!.postRequestDetail!.service != null) customerServiceList(serviceList: res.data!.postRequestDetail!.service!),

                      /// Package Info if User selected any Package
                      if (res.data!.bookingDetail!.bookingPackage != null) packageWidget(package: res.data!.bookingDetail!.bookingPackage!),

                      /// Service Proof Images
                      ServiceProofListWidget(serviceProofList: res.data!.serviceProof!),

                      /// About Provider Card
                      providerWidget(providerData: res.data!.providerData, serviceDetail: res.data!.service!),

                      /// About Handyman Card
                      if (res.data!.handymanData!.isNotEmpty && appStore.userType != USER_TYPE_HANDYMAN)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Text(locale.aboutHandyman, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                            16.height,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: context.cardColor,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: res.data!.handymanData!.map((e) {
                                  return BasicInfoComponent(1, handymanData: e, service: res.data!.service);
                                }).toList(),
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 16, right: 16, bottom: 16),

                      /// About Customer Card
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text(locale.aboutCustomer, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                          16.height,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BasicInfoComponent(
                                  0,
                                  customerData: res.data!.customer,
                                  service: res.data!.service,
                                  bookingDetail: res.data!.bookingDetail,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 16, right: 16, bottom: 16),

                      /// Price Detail Card
                      if (res.data!.bookingDetail != null && !res.data!.bookingDetail!.isFreeService)
                        PriceCommonWidget(
                          bookingDetail: res.data!.bookingDetail!,
                          serviceDetail: res.data!.service!,
                          taxes: res.data!.bookingDetail!.taxes.validate(),
                          couponData: res.data!.couponData != null ? res.data!.couponData! : null,
                          bookingPackage: res.data!.bookingDetail!.bookingPackage != null ? res.data!.bookingDetail!.bookingPackage : null,
                        ).paddingOnly(bottom: 16, left: 16, right: 16),

                      /// Extra Charges
                      if (res.data!.bookingDetail!.extraCharges.validate().isNotEmpty)
                        extraChargesWidget(
                          extraChargesList: res.data!.bookingDetail!.extraCharges.validate(),
                        ).paddingOnly(left: 16, right: 16, bottom: 16),

                      /// Payment Detail Card
                      if (res.data!.bookingDetail!.paymentId != null && res.data!.bookingDetail!.paymentStatus != null && !res.data!.bookingDetail!.isFreeService)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewAllLabel(
                              label: locale.paymentDetail,
                              list: [],
                            ),
                            8.height,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: context.cardColor,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(locale.id, style: secondaryTextStyle(size: 14)),
                                      Text("#" + res.data!.bookingDetail!.paymentId.toString(), style: boldTextStyle()),
                                    ],
                                  ),
                                  4.height,
                                  Divider(color: context.dividerColor),
                                  4.height,
                                  if (res.data!.bookingDetail!.paymentMethod.validate().isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(locale.method, style: secondaryTextStyle(size: 14)),
                                        Text(
                                          (res.data!.bookingDetail!.paymentMethod != null ? res.data!.bookingDetail!.paymentMethod.toString() : locale.notAvailable).capitalizeFirstLetter(),
                                          style: boldTextStyle(),
                                        ),
                                      ],
                                    ),
                                  4.height,
                                  Divider(color: context.dividerColor).visible(res.data!.bookingDetail!.paymentMethod != null),
                                  8.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(locale.status, style: secondaryTextStyle(size: 14)),
                                      Text(
                                        getPaymentStatusText(res.data!.bookingDetail!.paymentStatus.validate(value: locale.pending), res.data!.bookingDetail!.paymentMethod),
                                        style: boldTextStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 16, right: 16, bottom: 16),

                      /// Customer Review Widget
                      if (res.data!.ratingData.validate().isNotEmpty) _customerReviewWidget(bookingDetailResponse: res.data!),
                    ],
                  ),
                ),
              ],
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
          ],
        );
      }
      return LoaderWidget().center();
    }

    return FutureBuilder<BookingDetailResponse>(
      future: future,
      builder: (context, snap) {
        return RefreshIndicator(
          onRefresh: () async {
            init();
            return await 2.seconds.delay;
          },
          child: AppScaffold(
            appBarTitle: snap.hasData ? snap.data!.bookingDetail!.status.validate().toBookingStatus() : "",
            actions: [
              TextButton(
                onPressed: () {
                  if (snap.data != null)
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      builder: (_) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.50,
                          minChildSize: 0.2,
                          maxChildSize: 1,
                          builder: (context, scrollController) => BookingHistoryBottomSheet(
                            data: snap.data!.bookingActivity!.reversed.toList(),
                            scrollController: scrollController,
                          ),
                        );
                      },
                    );
                },
                child: Text(locale.checkStatus, style: boldTextStyle(color: white)),
              ).paddingRight(8),
            ],
            child: buildBodyWidget(snap),
          ),
        );
      },
    );
  }
}
