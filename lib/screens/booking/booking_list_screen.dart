import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/empty_error_state_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/booking/component/booking_item_component.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/images.dart';
import 'component/booking_status_filter_bottom_sheet.dart';

class BookingListScreen extends StatefulWidget {
  final String? statusType;

  BookingListScreen({this.statusType});

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  ScrollController scrollController = ScrollController();
  UniqueKey keyForList = UniqueKey();

  Future<List<BookingData>>? future;
  List<BookingData> bookings = [];

  bool isLastPage = false;

  String selectedValue = BOOKING_TYPE_ALL;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      init();
    });
    cachedBookingStatusDropdown.validate().forEach((element) {
      element.isSelected = false;
    });
  }

  void init({String status = ''}) async {

    future = getBookingList(page, status: status, bookings: bookings, lastPageCallback: (b) {
      isLastPage = b;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: locale.bookings,
      actions: [
        IconButton(
          icon: ic_filter.iconImage(color: white, size: 20),
          onPressed: () async {
            String? res = await showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
              builder: (_) {
                return BookingStatusFilterBottomSheet(scrollController: scrollController);
              },
            );

            if (res.validate().isNotEmpty) {
              page = 1;
              appStore.setLoading(true);

              selectedValue = res!;
              init(status: res);

              if (bookings.isNotEmpty) {
                scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
              } else {
                scrollController = ScrollController();
                keyForList = UniqueKey();
              }

              setState(() {});
            }
          },
        ),
      ],
      child: Stack(
        children: [
          SnapHelperWidget<List<BookingData>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (list) {
              return SizedBox(
                width: context.width(),
                height: context.height(),
                child: AnimatedListView(
                  key: keyForList,
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 60, top: 16, right: 16, left: 16),
                  itemCount: list.length,
                  shrinkWrap: true,
                  listAnimationType: ListAnimationType.Slide,
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  disposeScrollController: true,
                  itemBuilder: (_, index) {
                    BookingData? data = list[index];

                    return GestureDetector(
                      onTap: () {
                        // BookingDetailScreen(bookingId: data.id.validate()).launch(context);
                      },
                      child: BookingItemComponent(bookingData: data),
                    );
                  },
                  emptyWidget: NoDataWidget(
                    title: locale.noBookingFound,
                    subTitle: locale.noBookingSubTitle,
                    imageWidget: EmptyStateWidget(),
                  ),
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    }
                  },
                  onSwipeRefresh: () async {
                    page = 1;
                    appStore.setLoading(true);

                    init(status: selectedValue);
                    setState(() {});

                    return await 1.seconds.delay;
                  },
                ),
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: locale.reload,
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
