import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/base_scaffold_widget.dart';
import '../../components/cached_image_widget.dart';
import '../../components/disabled_rating_bar_widget.dart';
import '../../components/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/service_detail_response.dart';
import '../../networks/rest_apis.dart';
import '../../utils/common.dart';
import '../service/service_detail_screen.dart';

enum RatingType { UserServiceRating, HandymanRating }

class RatingsListScreen extends StatefulWidget {
  final RatingType ratingType;

  const RatingsListScreen({Key? key, required this.ratingType}) : super(key: key);

  @override
  State<RatingsListScreen> createState() => _RatingsListScreenState();
}

class _RatingsListScreenState extends State<RatingsListScreen> {
  Future<List<RatingData>>? future;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = ratings(page, ratingType: widget.ratingType);
  }

  /// Delete Ratings
  Future<void> deleteRatings(int? id) async {
    appStore.setLoading(true);
    await removeRatings(id.validate(), ratingType: widget.ratingType).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
      log(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: widget.ratingType == RatingType.UserServiceRating ? locale.userServiceRatings : locale.handymanRatings,
      child: Stack(
        children: [
          SnapHelperWidget<List<RatingData>>(
            future: future,
            onSuccess: (snap) {
              return AnimatedListView(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 50),
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: snap.length,
                onSwipeRefresh: () async {
                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                itemBuilder: (context, index) {
                  RatingData data = snap[index];

                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Column(
                      children: [
                        if (widget.ratingType == RatingType.HandymanRating)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CachedImageWidget(
                                url: data.handymanProfileImage.validate(),
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                circle: true,
                              ),
                              8.width,
                              Text(data.handymanName.validate(), style: boldTextStyle()).expand(),
                            ],
                          ),
                        if (widget.ratingType == RatingType.HandymanRating) 12.height,
                        Container(
                          decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.ratingType == RatingType.UserServiceRating) Text(data.serviceName.validate(), style: boldTextStyle()),
                              if (widget.ratingType == RatingType.UserServiceRating) 8.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DisabledRatingBarWidget(rating: data.rating.validate().toDouble(), size: 16),
                                  Icon(Icons.delete_forever, color: Colors.red.shade400, size: 18).onTap(() {
                                    showConfirmDialogCustom(
                                      context,
                                      dialogType: DialogType.DELETE,
                                      title: locale.doYouWantToDelete,
                                      positiveText: locale.delete,
                                      negativeText: locale.cancel,
                                      onAccept: (_) {
                                        ifNotTester(context, () {
                                          deleteRatings(data.id.validate());
                                        });
                                      },
                                    );
                                  }),
                                ],
                              ),
                              8.height,
                              ReadMoreText(data.review.validate(), style: secondaryTextStyle()),
                              12.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CachedImageWidget(
                                    url: data.customerProfileImage.validate(),
                                    height: 25,
                                    width: 25,
                                    circle: true,
                                    fit: BoxFit.cover,
                                  ),
                                  8.width,
                                  Text(
                                    data.customerName.validate(),
                                    style: secondaryTextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                  ).flexible(),
                                ],
                              ),
                            ],
                          ),
                        ).onTap(() {
                          ServiceDetailScreen(serviceId: data.serviceId.validate()).launch(context);
                        }),
                      ],
                    ),
                  );
                },
                emptyWidget: NoDataWidget(
                  title: locale.noRatingFoundYet,
                  imageWidget: EmptyStateWidget(),
                ),
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
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
