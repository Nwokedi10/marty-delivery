
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final FocusNode _amountFocus = FocusNode();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().getProfile();
  }

  String generateRandomNumberString(int length) {
    final random = Random();
    String numberString = '';

    for (int i = 0; i < length; i++) {
      numberString += random.nextInt(10).toString();
    }

    return numberString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Withdraw Earnings'),
      body:
      GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null ? const Center(child: CircularProgressIndicator()) :
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 1170,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column( children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text('Withdraw from earning', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      '${'Get paid directly into your bank account from your earning.'.tr}',
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr, textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Column(children: [
                          Image.asset(Images.earnMoney, width: ResponsiveHelper.isDesktop(context) ? 200 : 100,
                              height: ResponsiveHelper.isDesktop(context) ? 250 : 150, fit: BoxFit.contain),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('Amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      CustomTextField(
                        hintText: 'minimum is ' + authController.withModel!.min.toString(),
                        controller: _amountController,
                        focusNode: _amountFocus,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.done,
                        prefixIcon: Images.money,
                        divider: true,
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomButton(buttonText: 'Withdraw',icon: Icons.wallet, onPressed: (){
                      String amount = _amountController.text.trim();
                      if(!amount.isNumericOnly){
                        showCustomSnackBar('Please enter valid amount');
                      } else
                      if(amount.isEmpty){
                        showCustomSnackBar('Enter amount');
                      } else if(double.parse(amount) < double.parse(authController.withModel!.min.toString())){
                        showCustomSnackBar('Amount is less than minimum withdrawal');
                      } else if(double.parse(amount) > double.parse(authController.profileModel!.balance.toString())){
                        showCustomSnackBar('Amount is more than your available balance');
                      }
                      else {
                        _withdraw(authController, _amountController, context);
                      }
                    }),

                  ]);
                }
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  void _withdraw(AuthController authController, TextEditingController amountText, BuildContext context) async {
    String amount = amountText.text.trim();

    if(!amount.isNumericOnly){
      showCustomSnackBar('Please enter valid amount');
    } else
    if(amount.isEmpty){
      showCustomSnackBar('Enter amount');
    } else if(double.parse(amount) < double.parse(authController.withModel!.min.toString())){
      showCustomSnackBar('Amount is less than minimum withdrawal');
    } else if(double.parse(amount) > double.parse(authController.profileModel!.balance.toString())){
      showCustomSnackBar('Amount is more than your available balance');
    }else {
      authController.withdraw(amount).then((status) async {
        if (status.isSuccess) {
          showCustomSnackBar('Withdrawal request received and will be credited to your account.', isError: false);
          Get.toNamed(RouteHelper.getMainRoute('main'));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }

    /*print('------------1');
    final _imageData = await Http.get(Uri.parse('https://cdn.dribbble.com/users/1622791/screenshots/11174104/flutter_intro.png'));
    print('------------2');
    String _stringImage = base64Encode(_imageData.bodyBytes);
    print('------------3 {$_stringImage}');
    SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString('image', _stringImage);
    print('------------4');
    Uint8List _uintImage = base64Decode(_sp.getString('image'));
    authController.setImage(_uintImage);
    //await _thetaImage.writeAsBytes(_imageData.bodyBytes);
    print('------------5');*/
  }
}