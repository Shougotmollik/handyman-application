import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/base_scaffold_widget.dart';
import '../../components/cached_image_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../model/bidder_data.dart';
import '../../model/post_job_data.dart';
import '../../model/post_job_detail_response.dart';
import '../../model/service_model.dart';
import '../../model/user_data.dart';
import '../../networks/rest_apis.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';

class JobPostDetailScreen extends StatefulWidget {
  final PostJobData postJobData;

  JobPostDetailScreen({required this.postJobData});

  @override
  _JobPostDetailScreenState createState() => _JobPostDetailScreenState();
}

class _JobPostDetailScreenState extends State<JobPostDetailScreen> {
  late Future<PostJobDetailResponse> future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPostJobDetail({PostJob.postRequestId: widget.postJobData.id.validate()});
  }

  Widget titleWidget({required String title, required String detail, bool isReadMore = false, required TextStyle detailTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.validate(), style: secondaryTextStyle()),
        4.height,
        if (isReadMore) ReadMoreText(detail.validate(), style: detailTextStyle) else Text(detail.validate(), style: boldTextStyle(size: 12)),
        20.height,
      ],
    );
  }

  Widget postJobDetailWidget({required PostJobData data}) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 16),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.title.validate().isNotEmpty)
            titleWidget(
              title: locale.postJobTitle,
              detail: data.title.validate(),
              detailTextStyle: boldTextStyle(),
            ),
          if (data.description.validate().isNotEmpty)
            titleWidget(
              title: locale.postJobDescription,
              detail: data.description.validate(),
              detailTextStyle: primaryTextStyle(),
              isReadMore: true,
            ),
        ],
      ),
    );
  }

  Widget postJobServiceWidget({required List<ServiceData> serviceList}) {
    if (serviceList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(locale.services, style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingOnly(left: 16, right: 16),
        AnimatedListView(
          itemCount: serviceList.length,
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            ServiceData data = serviceList[i];

            return Container(
              width: context.width(),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
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
    );
  }
  Widget customerWidget(PostJobData? postJobData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(locale.aboutCustomer, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: [
              CachedImageWidget(
                url: postJobData!.customerProfile.validate(),
                fit: BoxFit.cover,
                height: 60,
                width: 60,
                circle: true,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Marquee(
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(
                      postJobData.customerName.validate(),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  4.height,
                  Text(postJobData.status.validate() == JOB_REQUEST_STATUS_ACCEPTED ? locale.jobPrice : locale.estimatedPrice, style: secondaryTextStyle()),
                  4.height,
                  PriceWidget(price: postJobData.price.validate()),
                ],
              ).expand(),
            ],
          ),
        ),
        16.height,
      ],
    ).paddingOnly(left: 16, right: 16);

    return Offstage();
  }
  Widget providerWidget(List<BidderData> bidderList, num providerId) {
    try {
      BidderData? bidderData = bidderList.firstWhere((element) => element.providerId == providerId);
      UserData? user = bidderData.provider;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(locale.providerDetails, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CachedImageWidget(
                      url: user!.profileImage.validate(),
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                      circle: true,
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName.validate(),
                          style: boldTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.height,
                        PriceWidget(price: bidderData.price.validate()),
                      ],
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
          16.height,
        ],
      ).paddingOnly(left: 16, right: 16);
    } catch (e) {
      print(e);
    }

    return Offstage();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: '${widget.postJobData.title}',
      child: SnapHelperWidget<PostJobDetailResponse>(
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (data) {
          return AnimatedScrollView(
            padding: EdgeInsets.only(bottom: 60),
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  postJobDetailWidget(data: data.postRequestDetail!).paddingAll(16),
                  customerWidget(data.postRequestDetail!),
                  providerWidget(data.bidderData.validate(), data.postRequestDetail!.providerId.validate()),
                  postJobServiceWidget(serviceList: data.postRequestDetail!.service.validate()),
                ],
              ),
            ],
            onSwipeRefresh: () async {
              init();
              setState(() {});

              return await 2.seconds.delay;
            },
          );
        },
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: locale.reload,
            onRetry: () {
              appStore.setLoading(true);

              init();
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
