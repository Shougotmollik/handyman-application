import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/category_response.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class DropdownSubCategoryComponent extends StatefulWidget {
  final int? categoryId;
  final Function(CategoryData value) onValueChanged;
  final bool isValidate;

  final bool isUpdate;

  DropdownSubCategoryComponent({
    required this.onValueChanged,
    required this.isValidate,
    this.categoryId,
    this.isUpdate = false,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownUserTypeComponentState createState() => _DropdownUserTypeComponentState();
}

class _DropdownUserTypeComponentState extends State<DropdownSubCategoryComponent> {
  CategoryData? selectedData;
  List<CategoryData> subCategoryList = [];

  @override
  void initState() {
    super.initState();
    LiveStream().on(SELECT_SUBCATEGORY, (p0) {
      if (selectedData != null) {
        selectedData = null;
        setState(() {});
      }
      init(subCategory: p0.toString());
    });

    afterBuildCreated(() {
      init();
    });
  }

  init({String? subCategory}) async {
    toast(subCategory);
    log(subCategory);
    subCategoryList.clear();

    getSubCategoryList(
      catId: subCategory.toInt().validate(),
      perPage: PER_PAGE_ITEM,
      subCategoryList: subCategoryList,
      callback: (res) {
        setState(() {});
      },
    ).then((value) {
      if (selectedData == null) {
        if (widget.isUpdate && value.isNotEmpty) {
          /// logic for Sub Category Selection
          selectedData = value.firstWhere((element) => element.id == widget.categoryId, orElse: null);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(SELECT_SUBCATEGORY);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryData>(
      onChanged: (CategoryData? val) {
        widget.onValueChanged.call(val!);
        selectedData = val;
      },
      validator: widget.isValidate
          ? (c) {
              if (c == null) return errorThisFieldRequired;
              return null;
            }
          : null,
      value: selectedData,
      dropdownColor: context.cardColor,
      decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor),
      hint: Text(locale.selectSubcategory, style: secondaryTextStyle()),
      items: List.generate(
        subCategoryList.length,
        (index) {
          CategoryData data = subCategoryList[index];
          return DropdownMenuItem<CategoryData>(
            child: Text(data.name.toString(), style: primaryTextStyle()),
            value: data,
          );
        },
      ),
    );
  }
}
