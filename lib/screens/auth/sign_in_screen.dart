import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/selected_item_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/auth/user_demo_mode_screen.dart';
import 'package:handyman_admin_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:handyman_admin_flutter/utils/colors.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:handyman_admin_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_admin_flutter/utils/images.dart';
import 'package:handyman_admin_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Text Field Controller
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  /// FocusNodes
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isRemember = getBoolAsync(IS_REMEMBERED, defaultValue: true);
    if (isRemember) {
      emailCont.text = getStringAsync(USER_EMAIL);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  //region Widgets
  Widget _buildTopWidget() {
    return Column(
      children: [
        32.height,
        Text(locale.helloAgain, style: boldTextStyle(size: 22)),
        16.height,
        Text(
          locale.welcomeBackYouHave,
          style: secondaryTextStyle(size: 16),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32),
        64.height,
      ],
    );
  }

  Widget _buildForgotRememberWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                2.width,
                SelectedItemWidget(isSelected: isRemember).onTap(() async {
                  await setValue(IS_REMEMBERED, isRemember);
                  isRemember = !isRemember;
                  setState(() {});
                }),
                TextButton(
                  onPressed: () async {
                    await setValue(IS_REMEMBERED, isRemember);
                    isRemember = !isRemember;
                    setState(() {});
                  },
                  child: Text(locale.rememberMe, style: secondaryTextStyle()),
                ),
              ],
            ),
          ],
        ),
        32.height,
      ],
    );
  }

  Widget _buildButtonWidget() {
    return AppButton(
      text: locale.login,
      color: primaryColor,
      width: context.width(),
      onTap: () {
        loginUsers();
      },
    );
  }

  //endregion

  //region Methods
  void loginUsers() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.email: emailCont.text,
        UserKeys.password: passwordCont.text,
      };

      if (isRemember) {
        await setValue(USER_EMAIL, emailCont.text);
        await setValue(USER_PASSWORD, passwordCont.text);
        await setValue(IS_REMEMBERED, isRemember);
      }

      appStore.setLoading(true);

      await loginUser(request).then((res) async {
        TextInput.finishAutofillContext();
        appStore.setLoading(true);
        await saveUserData(res.data!);
        push(DashboardScreen(), pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        elevation: 0,
        showBack: false,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: getStatusBrightness(val: appStore.isDarkMode), statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopWidget(),
                    AutofillGroup(
                      child: Column(
                        children: [
                          AppTextField(
                            textFieldType: TextFieldType.EMAIL_ENHANCED,
                            controller: emailCont,
                            focus: emailFocus,
                            nextFocus: passwordFocus,
                            errorThisFieldRequired: locale.thisFieldIsRequired,
                            decoration: inputDecoration(context, hint: locale.emailAddress),
                            suffix: ic_message.iconImage(size: 10).paddingAll(14),
                            autoFillHints: [AutofillHints.email],
                          ),
                          16.height,
                          AppTextField(
                            textFieldType: TextFieldType.PASSWORD,
                            controller: passwordCont,
                            focus: passwordFocus,
                            errorThisFieldRequired: locale.thisFieldIsRequired,
                            suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                            suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                            errorMinimumPasswordLength: "${locale.passwordLengthShouldBe} $passwordLengthGlobal",
                            decoration: inputDecoration(context, hint: locale.password),
                            autoFillHints: [AutofillHints.password],
                            onFieldSubmitted: (s) {
                              loginUsers();
                            },
                          ),
                          8.height,
                        ],
                      ),
                    ),
                    _buildForgotRememberWidget(),
                    _buildButtonWidget(),
                    24.height,
                    if (isIqonicProduct)
                      UserDemoModeScreen(
                        onChanged: (email, password) {
                          if (email.isNotEmpty && password.isNotEmpty) {
                            emailCont.text = email;
                            passwordCont.text = password;
                          } else {
                            emailCont.clear();
                            passwordCont.clear();
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            Observer(
              builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
