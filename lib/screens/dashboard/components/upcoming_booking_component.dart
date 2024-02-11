import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/view_all_label_component.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/booking_data_model.dart';
import 'package:handyman_admin_flutter/screens/booking/booking_detail_screen.dart';
import 'package:handyman_admin_flutter/screens/booking/booking_list_screen.dart';
import 'package:handyman_admin_flutter/screens/booking/component/booking_item_component.dart';
import 'package:nb_utils/nb_utils.dart';

class UpcomingBookingComponent extends StatelessWidget {
  final List<BookingData> bookingList;

  UpcomingBookingComponent({required this.bookingList});

  @override
  Widget build(BuildContext context) {
    if (bookingList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        ViewAllLabel(
          label: locale.newBooking,
          list: bookingList,
          onTap: () {
            BookingListScreen().launch(context);
          },
        ).paddingSymmetric(horizontal: 16),
        AnimatedListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 8, right: 16, left: 16),
          itemCount: bookingList.length,
          shrinkWrap: true,
          listAnimationType: ListAnimationType.Slide,
          slideConfiguration: SlideConfiguration(verticalOffset: 400),
          itemBuilder: (_, index) {
            BookingData? data = bookingList[index];

            return GestureDetector(
              onTap: () {
                CommonBookingDetailScreen(bookingId: data.id.validate()).launch(context);
              },
              child: BookingItemComponent(bookingData: data),
            );
          },
        )
      ],
    );
  }
}
