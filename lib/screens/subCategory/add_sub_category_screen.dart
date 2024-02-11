import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/category_response.dart';
import 'package:handyman_admin_flutter/networks/network_utils.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class AddSubCategoryScreen extends StatefulWidget {
  final CategoryData categoryData;
  final CategoryData? subCategoryData;

  AddSubCategoryScreen(this.categoryData, {this.subCategoryData});

  @override
  _AddSubCategoryScreenState createState() => _AddSubCategoryScreenState();
}

class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String selectedStatusType = ACTIVE;
  bool isFeature = false;

  File? imageFile;
  FilePickerResult? pickedFile;
  int? subCategoryId;

  CategoryData? selectedCategory;
  List<CategoryData> categoryList = [];
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    isUpdate = widget.subCategoryData != null;
    init();
  }

  void init() async {
    if (isUpdate) {
      subCategoryId = widget.subCategoryData!.id;

      nameCont.text = widget.subCategoryData!.name.validate();
      descriptionCont.text = widget.subCategoryData!.description.validate();
      selectedStatusType = widget.subCategoryData!.status.validate() == 1 ? ACTIVE : IN_ACTIVE;
      isFeature = widget.subCategoryData!.isFeatured.validate() == 1 ? true : false;
    }
    getCategory();
  }

  Future<void> getCategory() async {
    await getCategoryList(perPage: PER_PAGE_ALL, categoryList: categoryList).then((value) {
      int id = 0;
      if (widget.categoryData.categoryId.validate() != 0) {
        id = widget.categoryData.categoryId!;
      } else {
        id = widget.categoryData.id!;
      }

      selectedCategory = categoryList.firstWhere((element) => element.id == id);

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> addSubCategoryButton() async {
    if (!isUpdate && imageFile == null) {
      toast(locale.chooseImage);
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      if (selectedCategory == null) return toast('Please choose category');

      MultipartRequest multiPartRequest = await getMultiPartRequest('subcategory-save');

      if (subCategoryId != null) {
        multiPartRequest.fields[CommonKeys.id] = subCategoryId.toString();
      } else {
        multiPartRequest.fields[CommonKeys.id] = '';
      }

      if (isUpdate) {
        multiPartRequest.fields['category_id'] = selectedCategory!.id.validate().toString();
      }

      /// Use category_id For add
      if (widget.subCategoryData == null) {
        multiPartRequest.fields['category_id'] = selectedCategory!.id.validate().toString();
      }

      multiPartRequest.fields['name'] = nameCont.text;
      multiPartRequest.fields['status'] = selectedStatusType == ACTIVE ? '1' : '0';
      multiPartRequest.fields['description'] = descriptionCont.text;
      multiPartRequest.fields['is_featured'] = isFeature ? '1' : '0';
      multiPartRequest.fields['color'] = '#ffffff';

      if (imageFile != null) {
        multiPartRequest.files.add(await MultipartFile.fromPath('subcategory_image', imageFile!.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      appStore.setLoading(true);
      sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          appStore.setLoading(false);
          toast(jsonDecode(data)['message'], print: true);

          finish(context, true);
        },
        onError: (error) {
          toast(error.toString(), print: true);
          appStore.setLoading(false);
        },
      ).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  getMultipleFile() async {
    pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

    if (pickedFile != null) {
      imageFile = pickedFile!.paths.map((path) => File(path!)).first;
      setState(() {});
    }
  }

  /// Delete SubCategory
  Future<void> removeSubCategory(int? id) async {
    appStore.setLoading(true);
    await deleteSubCategory(id.validate()).then((value) {
      appStore.setLoading(false);
      widget.subCategoryData!.deletedAt = '';
      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore SubCategory
  Future<void> restoreSubCategoryData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.subCategoryData!.id,
      type: RESTORE,
    };

    await restoreSubCategory(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);

      widget.subCategoryData!.deletedAt = null;
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete SubCategory
  Future<void> forceDeleteSubCategoryData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.subCategoryData!.id,
      type: FORCE_DELETE,
    };

    await restoreSubCategory(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);

      widget.categoryData.deletedAt = null;
      finish(context, true);
      setState(() {});
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
      appBarTitle: widget.subCategoryData == null ? locale.addSubCategory : '${locale.update} ${widget.subCategoryData!.name}',
      actions: [
        if (isUpdate)
          PopupMenuButton(
            icon: Icon(Icons.more_vert, size: 24, color: white),
            color: context.cardColor,
            onSelected: (selection) {
              if (selection == 1) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.doYouWantToDelete,
                  positiveText: locale.delete,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      removeSubCategory(widget.subCategoryData!.id.validate());
                    });
                  },
                );
              } else if (selection == 2) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.ACCEPT,
                  title: locale.doYouWantToRestore,
                  positiveText: locale.accept,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      restoreSubCategoryData();
                    });
                  },
                );
              } else if (selection == 3) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.doYouWantToDeleteForcefully,
                  positiveText: locale.delete,
                  negativeText: locale.cancel,
                  onAccept: (_) {
                    ifNotTester(context, () {
                      forceDeleteSubCategoryData();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.subCategoryData!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.subCategoryData!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.subCategoryData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.subCategoryData!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.subCategoryData!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.subCategoryData!.deletedAt != null,
              ),
            ],
          ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: boxDecorationDefault(
                          border: Border.all(color: context.cardColor, width: 4),
                          shape: BoxShape.circle,
                          color: context.cardColor,
                        ),
                        child: imageFile != null
                            ? Image.file(imageFile!, width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(45)
                            : CachedImageWidget(
                                url: isUpdate ? widget.subCategoryData!.categoryImage.validate() : '',
                                height: 80,
                                fit: BoxFit.cover,
                                radius: 40,
                              ),
                      ).onTap(
                        () async {
                          getMultipleFile();
                        },
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: primaryColor,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Icon(AntDesign.camera, color: Colors.white, size: 16).paddingAll(4.0),
                        ),
                      )
                    ],
                  ),
                  16.width,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameCont,
                    focus: nameFocus,
                    errorThisFieldRequired: locale.thisFieldIsRequired,
                    decoration: inputDecoration(context, hint: locale.name),
                  ).expand(),
                ],
              ),
              16.height,
              DropdownButtonFormField<CategoryData>(
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.category),
                value: selectedCategory,
                hint: Text(locale.selectCategory, style: secondaryTextStyle()),
                items: categoryList.map((data) {
                  return DropdownMenuItem<CategoryData>(
                    value: data,
                    child: Text(data.name.validate(), style: primaryTextStyle()),
                  );
                }).toList(),
                onChanged: (CategoryData? value) async {
                  selectedCategory = value!;
                  setState(() {});
                  LiveStream().emit(SELECT_SUBCATEGORY, selectedCategory!.id.validate());
                },
              ),
              16.height,
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(
                    child: Text(locale.active, style: primaryTextStyle()),
                    value: ACTIVE,
                  ),
                  DropdownMenuItem(
                    child: Text(locale.inactive, style: primaryTextStyle()),
                    value: IN_ACTIVE,
                  ),
                ],
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.selectStatus),
                value: selectedStatusType,
                validator: (value) {
                  if (value == null) return errorThisFieldRequired;
                  return null;
                },
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedStatusType = c.validate();
                },
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.MULTILINE,
                minLines: 5,
                controller: descriptionCont,
                focus: descriptionFocus,
                errorThisFieldRequired: locale.thisFieldIsRequired,
                decoration: inputDecoration(
                  context,
                  hint: locale.description,
                ),
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                padding: EdgeInsets.only(left: 16,right: 4),
                child: Theme(
                  data:  ThemeData(
                    unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor: context.iconColor,
                  ),
                  child: CheckboxListTile(
                    checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                    autofocus: false,
                    activeColor: context.primaryColor,
                    checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                    value: isFeature,
                    contentPadding: EdgeInsets.zero,
                    title: Text(locale.setAsFeature, style: secondaryTextStyle()),
                    onChanged: (bool? v) {
                      isFeature = v.validate();
                      setState(() {});
                    },
                  ),
                ),
              ),
              24.height,
              AppButton(
                text: locale.save,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.subCategoryData == null || widget.subCategoryData!.deletedAt == null) {
                    ifNotTester(context, () {
                      addSubCategoryButton();
                    });
                  } else {
                    toast(locale.youCanTUpdateDeleted);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
