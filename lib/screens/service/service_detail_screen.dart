import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/view_all_label_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/service_address_mapping_model.dart';
import 'package:handyman_admin_flutter/model/service_detail_response.dart';
import 'package:handyman_admin_flutter/model/service_model.dart';
import 'package:handyman_admin_flutter/model/user_data.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/review/rating_view_all_screen.dart';
import 'package:handyman_admin_flutter/screens/review/review_widget.dart';
import 'package:handyman_admin_flutter/screens/service/components/provider_detail_widget.dart';
import 'package:handyman_admin_flutter/screens/service/components/service_detail_header_component.dart';
import 'package:handyman_admin_flutter/screens/service/components/service_faq_widget.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';
import '../packages/components/package_component.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int serviceId;

  ServiceDetailScreen({required this.serviceId});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> with TickerProviderStateMixin {
  Future<ServiceDetailResponse>? future;

  PageController pageController = PageController();

  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;
  bool isUpdated = true;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    init();
    setStatusBarColor(transparentColor, delayInMilliSeconds: 300.milliseconds.inMilliseconds);
  }

  void init() async {
    future = getServiceDetails(serviceId: widget.serviceId.validate());
  }

  //region Widgets
  Widget availableWidget({required ServiceData data}) {
    if (data.serviceAddressMapping.validate().isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.availableAt, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              data.serviceAddressMapping.validate().length,
              (index) {
                ServiceAddressMapping value = data.serviceAddressMapping![index];

                if (value.providerAddressMapping == null) {
                  return Offstage();
                }

                bool isSelected = selectedAddressId == index;
                if (selectedBookingAddressId == -1) {
                  selectedBookingAddressId = data.serviceAddressMapping!.first.providerAddressId.validate();
                }
                return GestureDetector(
                  onTap: () {
                    selectedAddressId = index;
                    selectedBookingAddressId = value.providerAddressId.validate();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(color: isSelected ? primaryColor : context.cardColor),
                    child: Text(
                      '${value.providerAddressMapping!.address.validate()}',
                      style: primaryTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget providerWidget({required UserData data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.aboutProvider, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        BookingDetailProviderWidget(providerData: data),
      ],
    ).paddingAll(16);
  }

  Widget serviceFaqWidget({required List<ServiceFaq> data}) {
    if (data.isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllLabel(label: locale.faqs, list: data),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) => ServiceFaqWidget(serviceFaq: data[index]),
          ),
          8.height,
        ],
      ),
    );
  }

  Widget reviewWidget({required List<RatingData> data, required ServiceDetailResponse serviceDetailResponse}) {
    return Column(
      children: [
        ViewAllLabel(
          label: '${locale.reviews} (${serviceDetailResponse.serviceDetail!.totalReview})',
          list: data,
          onTap: () async {
            await RatingViewAllScreen(serviceId: widget.serviceId).launch(context);
            setStatusBarColor(transparentColor);
          },
        ),
        8.height,
        data.isNotEmpty
            ? Wrap(
                children: List.generate(
                  data.length,
                  (index) => ReviewWidget(
                    data: data[index],
                  ),
                ),
              )
            : Text(locale.noReviewYet, style: secondaryTextStyle()).paddingBottom(16),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<ServiceDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return RefreshIndicator(
          onRefresh: () async {
            init();
            setState(() {});
            return await 2.seconds.delay;
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceDetailHeaderComponent(
                      serviceDetail: snap.data!.serviceDetail!,
                      callBack: () async {
                        isUpdated = true;
                        init();
                        setState(() {});
                        return await 2.seconds.delay;
                      },
                    ),
                    if (snap.data!.serviceDetail!.isOnlineService)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          Text(locale.serviceVisitType, style: boldTextStyle()),
                          8.height,
                          Text(locale.thisServiceIsOnlineRemote, style: secondaryTextStyle()),
                        ],
                      ).paddingAll(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.description, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        snap.data!.serviceDetail!.description.validate().isNotEmpty
                            ? ReadMoreText(snap.data!.serviceDetail!.description.validate(), style: secondaryTextStyle())
                            : Text(locale.noDescriptionAvailable, style: secondaryTextStyle()),
                      ],
                    ).paddingAll(16),
                    availableWidget(data: snap.data!.serviceDetail!),
                    PackageComponent(servicePackage: snap.data!.serviceDetail!.servicePackage.validate()),
                    providerWidget(data: snap.data!.provider!),
                    serviceFaqWidget(data: snap.data!.serviceFaq.validate()),
                    reviewWidget(data: snap.data!.ratingData!, serviceDetailResponse: snap.data!),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return LoaderWidget().center();
    }

    return WillPopScope(
      onWillPop: () {
        finish(context, isUpdated);
        return Future.value(false);
      },
      child: FutureBuilder<ServiceDetailResponse>(
        future: future,
        builder: (context, snap) {
          return Scaffold(
            body: buildBodyWidget(snap),
          );
        },
      ),
    );
  }
}
