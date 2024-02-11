import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/category_response.dart';
import 'package:handyman_admin_flutter/screens/category/add_category_screen.dart';
import 'package:handyman_admin_flutter/screens/subCategory/add_sub_category_screen.dart';
import 'package:handyman_admin_flutter/screens/subCategory/sub_category_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/cached_image_widget.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool isFromCategory;
  final bool isMainCategoryDeleted;
  final VoidCallback? onUpdate;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory = true, this.isMainCategoryDeleted = false, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: categoryData.deletedAt.validate().isEmpty ? 1 : 0.4,
      child: Container(
        width: width ?? context.width() / 3 - 24,
        decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: radius(),
        ),
        child: Column(
          children: [
            Container(
              width: context.width(),
              decoration: boxDecorationDefault(
                boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
                color: context.cardColor,
                borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
              ),
              child: categoryData.categoryImage.validate().endsWith('.svg')
                  ? SvgPicture.network(
                      categoryData.categoryImage.validate(),
                      height: 60,
                      width: 60,
                      //color: appStore.isDarkMode ? Colors.white : categoryData.color.toColor(),
                      color: context.iconColor,
                      placeholderBuilder: (context) => PlaceHolderWidget(height: 60, width: 60, color: Colors.transparent),
                    ).paddingAll(16.0)
                  : CachedImageWidget(
                      url: categoryData.categoryImage.validate(),
                      width: context.width(),
                      height: 60,
                      fit: BoxFit.fitHeight,
                      circle: false,
                    ).cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt()).paddingAll(16.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(categoryData.name.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.center).flexible(),
                if (isFromCategory)
                  IconButton(
                    onPressed: () {
                      if (categoryData.deletedAt == null) {
                        SubCategoryListScreen(categoryData).launch(context);
                      } else {
                        toast(locale.youCanTUpdateDeleted);
                      }
                    },
                    icon: Icon(Icons.more_horiz_rounded, color: context.iconColor),
                  ),
                if (!isFromCategory) 40.height,
              ],
            ).paddingOnly(left: 16),
          ],
        ),
      ).onTap(
        () async {
          if (isFromCategory) {
            await AddCategoryScreen(categoryData: categoryData).launch(context);
          } else {
            await AddSubCategoryScreen(categoryData, subCategoryData: categoryData).launch(context);
          }
          onUpdate?.call();
        },
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        borderRadius: radius(),
      ),
    );
  }
}
