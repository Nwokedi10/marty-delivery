import 'dart:io';

import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/splash_controller.dart';
import 'package:sixam_mart_delivery/data/model/response/profile_model.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/circular_button.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:sixam_mart_delivery/view/base/custom_image.dart';
import 'package:sixam_mart_delivery/view/base/custom_snackbar.dart';
import 'package:sixam_mart_delivery/view/base/my_text_field.dart';
import 'package:sixam_mart_delivery/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/view/screens/withdraw/widget/withdraw_bg.dart';

class UpdateBankScreen extends StatefulWidget {
  const UpdateBankScreen({Key? key}) : super(key: key);

  @override
  State<UpdateBankScreen> createState() => _UpdateBankScreenState();
}

class _UpdateBankScreenState extends State<UpdateBankScreen> {
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _bankFocus = FocusNode();
  final FocusNode _accNameFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accNumController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    Get.find<AuthController>().initData();
    // Get.find<AuthController>().newBankInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        if(authController.profileModel != null && _fullNameController.text.isEmpty && authController.newBankModel != null) {
          _fullNameController.text = authController.newBankModel!.accountName ?? '';
          _bankController.text = authController.newBankModel!.bank ?? '';
          _accNumController.text = authController.newBankModel!.accountNumber ?? '';
        }

        return authController.profileModel != null ? WithdrawBgWidget(
          backButton: true,
          mainWidget:
          Column(children: [

            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'Account Name'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                MyTextField(
                  hintText: 'full name'.tr,
                  controller: _fullNameController,
                  focusNode: _fullNameFocus,
                  nextFocus: _bankFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  'Bank'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                MyTextField(
                  hintText: 'Bank'.tr,
                  controller: _bankController,
                  focusNode: _bankFocus,
                  nextFocus: _accNameFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  'Account Number'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                MyTextField(
                  hintText: 'Account Number'.tr,
                  controller: _accNumController,
                  focusNode: _accNameFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                authController.newBankModel?.status == 'pending' ? Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have a pending request'),
                    CircularButton(text: ' cancel ', onPressed: () async {
                      await authController.cancelBankUpdate(authController.newBankModel!.id.toString()).then((status) async {
                        if (status.isSuccess) {
                          showCustomSnackBar('Cancel request approved.', isError: false);
                          Get.toNamed(RouteHelper.getMainRoute('main'));
                        }else {
                          showCustomSnackBar(status.message);
                        }
                      });
                      print('cancel ${authController.newBankModel?.status.toString()}');
                    }),
                  ],
                )) :
                authController.newBankModel?.status == null ?
                Text('') : Center(child: Text('Your last request was ${authController.newBankModel?.status}')),
                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]))),
            ))),

            authController.newBankModel?.status == 'pending' ? SizedBox.shrink() : !authController.isLoading ? CustomButton(
              onPressed: () => _updateProfile(authController),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              buttonText: 'update'.tr,
            ) : const Center(child: CircularProgressIndicator()),

          ]),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _updateProfile(AuthController authController) async {
    String fullName = _fullNameController.text.trim();
    String bank = _bankController.text.trim();
    String accNum = _accNumController.text.trim();
    if (authController.profileModel!.accountName == fullName &&
        authController.profileModel!.bank == bank && authController.profileModel!.accNum == accNum) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (fullName.isEmpty) {
      showCustomSnackBar('enter your account name'.tr);
    }else if (bank.isEmpty) {
      showCustomSnackBar('enter your bank'.tr);
    }else if (accNum.isEmpty) {
      showCustomSnackBar('enter your account number'.tr);
    }else if (accNum.length != 10) {
      showCustomSnackBar('enter a valid account number'.tr);
    } else {
      authController.updateBank(fullName, bank, accNum).then((status) async {
        if (status.isSuccess) {
          showCustomSnackBar('Account details update request received and will be confirmed by support.', isError: false);
          Get.toNamed(RouteHelper.getMainRoute('main'));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
