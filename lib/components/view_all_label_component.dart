import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllLabel extends StatelessWidget {
  final String label;
  final String? subLabel;
  final List? list;
  final VoidCallback? onTap;
  final int? labelSize;

  ViewAllLabel({required this.label, this.onTap, this.labelSize, this.subLabel, this.list});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: boldTextStyle(size: labelSize ?? LABEL_TEXT_SIZE)),
            if (subLabel.validate().isNotEmpty) Text(subLabel!, style: secondaryTextStyle(size: 12)).paddingTop(4),
          ],
        ),
        TextButton(
          onPressed: (list == null ? true : isViewAllVisible(list!))
              ? () {
                  onTap?.call();
                }
              : null,
          child: (list == null ? true : isViewAllVisible(list!)) ? Text(locale.viewAll, style: secondaryTextStyle()) : SizedBox(),
        ),
      ],
    );
  }
}

bool isViewAllVisible(List list) => list.length >= 4;
