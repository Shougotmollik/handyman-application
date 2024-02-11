import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';

import '../constant.dart';

extension intExt on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : appTextSecondaryColor),
      errorBuilder: (context, error, stackTrace) => placeHolderWidget(height: size ?? 24, width: size ?? 24, fit: fit ?? BoxFit.cover),
    );
  }

  String toBookingStatus({String? method}) {
    String temp = this.toLowerCase();

    if (temp == BOOKING_PAYMENT_STATUS_ALL) {
      return locale.all;
    } else if (temp == BOOKING_STATUS_PENDING) {
      return locale.pending;
    } else if (temp == BOOKING_STATUS_ACCEPT) {
      return locale.accepted;
    } else if (temp == BOOKING_STATUS_ON_GOING) {
      return locale.onGoing;
    } else if (temp == BOOKING_STATUS_IN_PROGRESS) {
      return locale.inProgress;
    } else if (temp == BOOKING_STATUS_HOLD) {
      return locale.hold;
    } else if (temp == BOOKING_STATUS_CANCELLED) {
      return locale.cancelled;
    } else if (temp == BOOKING_STATUS_REJECTED) {
      return locale.rejected;
    } else if (temp == BOOKING_STATUS_FAILED) {
      return locale.failed;
    } else if (temp == BOOKING_STATUS_COMPLETED) {
      return locale.completed;
    } else if (temp == BOOKING_STATUS_PENDING_APPROVAL) {
      return locale.pendingApproval;
    } else if (temp == BOOKING_STATUS_WAITING_ADVANCED_PAYMENT) {
      return locale.waiting;
    }

    return this;
  }

  String toPostJobStatus({String? method}) {
    String temp = this.toLowerCase();
    if (temp == JOB_REQUEST_STATUS_REQUESTED) {
      return locale.requested;
    } else if (temp == JOB_REQUEST_STATUS_ACCEPTED) {
      return locale.accepted;
    } else if (temp == JOB_REQUEST_STATUS_ASSIGNED) {
      return locale.assigned;
    }

    return this;
  }
}
