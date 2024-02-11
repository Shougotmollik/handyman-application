import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_admin_flutter/components/cached_image_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/model/attachment_model.dart';
import 'package:handyman_admin_flutter/model/document_list_response.dart';
import 'package:handyman_admin_flutter/networks/network_utils.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs.dart';
import '../../model/provider_document_response.dart';
import '../../utils/colors.dart';

class AddProviderDocumentScreen extends StatefulWidget {
  final ProviderDocumentData? data;
  final int providerId;

  const AddProviderDocumentScreen({super.key, this.data, required this.providerId});

  @override
  State<AddProviderDocumentScreen> createState() => _AddProviderDocumentScreenState();
}

class _AddProviderDocumentScreenState extends State<AddProviderDocumentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Documents? selectedDocument;

  List<Documents> documentList = [];

  int currentPage = 1;

  bool isLastPage = false;

  int page = 1;

  bool? isVerified = true;

  FilePickerResult? filePickerResult;
  List<String> imageFiles = [];
  List<Attachments> eAttachments = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getDocuments(
      page: currentPage,
      documents: documentList,
      callback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
    ).then((value) {
      if (widget.data != null) {
        selectedDocument = value.firstWhere((element) => element.id == widget.data!.documentId);
        setState(() {});
      }
    });
    appStore.setLoading(true);

    if (widget.data != null) {
      isVerified = widget.data!.isVerified.validate() == 1 ? true : false;
      imageFiles.add(widget.data!.providerDocument!);
    }
    setState(() {});
  }

  getMultipleFile() async {
    filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

    if (filePickerResult != null) {
      setState(() {
        imageFiles = filePickerResult!.paths.map((path) => path!).toList();
      });
    } else {}
  }

  /// Save Provider Document
  Future<void> addProviderDocuments() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (selectedDocument == null) {
        return toast(locale.pleaseChooseDocument);
      } else if (imageFiles.isEmpty) {
        return toast(locale.chooseAtLeastOneImage);
      }

      hideKeyboard(context);

      var url = Uri.parse('${BASE_URL}provider-document-save');

      var body = {
        "id": widget.data != null ? widget.data!.id.toString() : '',
        "document_id": selectedDocument!.id.toString(),
        "provider_id": widget.providerId.toString(),
        "is_verified": isVerified.validate() ? '1' : '0',
      };

      var req = MultipartRequest('POST', url);
      req.headers.addAll(buildHeaderTokens());
      if (imageFiles.isNotEmpty) {
        if (!imageFiles.first.startsWith('https')) {
          req.files.add(await MultipartFile.fromPath('provider_document', imageFiles.first));
        }
      }
      req.fields.addAll(body);

      appStore.setLoading(true);
      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      appStore.setLoading(false);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        finish(context, true);
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  /// Delete Provider Document
  Future<void> deleteProviderDocument(int? id) async {
    appStore.setLoading(true);
    await removeProviderDocument(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore Provider Document
  Future<void> restoreProviderDocumentData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: RESTORE,
    };

    await restoreProviderDocument(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete Provider Document
  Future<void> forceDeleteProviderDocument() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: FORCE_DELETE,
    };

    await restoreProviderDocument(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
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
      appBarTitle: widget.data == null ? locale.addProviderDocument : locale.updateProviderDocument,
      actions: [
        if (widget.data != null)
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
                      deleteProviderDocument(widget.data!.id.validate());
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
                      restoreProviderDocumentData();
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
                      forceDeleteProviderDocument();
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(locale.delete, style: boldTextStyle(color: widget.data!.deletedAt == null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 1,
                enabled: widget.data!.deletedAt == null,
              ),
              PopupMenuItem(
                child: Text(locale.restore, style: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 2,
                enabled: widget.data!.deletedAt != null,
              ),
              PopupMenuItem(
                child: Text(locale.forceDelete, style: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : textSecondaryColor)),
                value: 3,
                enabled: widget.data!.deletedAt != null,
              ),
            ],
          ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<Documents>(
                onChanged: (Documents? val) {
                  setState(() {
                    selectedDocument = val;
                  });
                },
                /*validator: widget.isValidate
                      ? (c) {
                          if (c == null) return errorThisFieldRequired;
                          return null;
                        }
                      : null,*/
                value: selectedDocument,
                dropdownColor: context.cardColor,
                decoration: inputDecoration(context, hint: locale.chooseDocument),
                items: documentList.map((Documents value) {
                  return DropdownMenuItem<Documents>(
                    value: value,
                    child: Text(value.name.validate(), style: primaryTextStyle()),
                  );
                }).toList(),
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                padding: EdgeInsets.only(left: 16, right: 4),
                child: Theme(
                  data:  ThemeData(
                    unselectedWidgetColor: appStore.isDarkMode ? context.dividerColor: context.iconColor,
                  ),
                  child: CheckboxListTile(
                    checkboxShape: RoundedRectangleBorder(borderRadius: radius(4)),
                    autofocus: false,
                    activeColor: context.primaryColor,
                    checkColor: appStore.isDarkMode ? context.iconColor : context.cardColor,
                    value: isVerified,
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: radius(8)),
                    title: Text(locale.verified, style: secondaryTextStyle()),
                    onChanged: (bool? v) {
                      isVerified = v.validate();
                      setState(() {});
                    },
                  ),
                ),
              ),
              16.height,
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(),
                  backgroundColor: context.cardColor,
                ),
                child: DottedBorder(
                  color: context.primaryColor.withOpacity(0.4),
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  dashPattern: [6, 5],
                  radius: Radius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.selectDocument, style: secondaryTextStyle()).paddingSymmetric(vertical: 16),
                      8.width,
                      Image.asset(selectImage, height: 20, width: 20, color: appStore.isDarkMode ? context.dividerColor: context.iconColor),
                    ],
                  ).paddingSymmetric(horizontal: 16).center().onTap(borderRadius: radius(), () async {
                    getMultipleFile();
                  }),
                ),
              ),
              20.height,
              HorizontalList(
                  itemCount: imageFiles.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        if (imageFiles[i].startsWith('https')) Image.network(imageFiles[i], width: 90, height: 90, fit: BoxFit.cover) else Image.file(File(imageFiles[i]), width: 90, height: 90, fit: BoxFit.cover),
                        Container(
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                          margin: EdgeInsets.only(right: 8, top: 8),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 16, color: white),
                        ).onTap(() {
                          filePickerResult = null;
                          imageFiles.removeAt(i);
                          setState(() {});
                        }),
                      ],
                    );
                  }).paddingBottom(16).visible(imageFiles.isNotEmpty),
              HorizontalList(
                itemCount: eAttachments.length,
                itemBuilder: (context, i) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CachedImageWidget(
                        url: eAttachments[i].url.validate(),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                        margin: EdgeInsets.only(right: 8, top: 8),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, size: 16, color: white),
                      ).onTap(() {
                        // removeAttachment(id: eAttachments[i].id!, index: i);
                      })
                    ],
                  );
                },
              ).paddingBottom(16).visible(eAttachments.isNotEmpty),
              40.height,
              AppButton(
                text: locale.save,
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  if (widget.data == null || widget.data!.deletedAt == null) {
                    ifNotTester(context, () {
                      addProviderDocuments();
                    });
                  } else {
                    toast(locale.youCanTUpdateDeleted);
                  }
                },
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
