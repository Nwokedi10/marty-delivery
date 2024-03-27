import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/chat_controller.dart';
import 'package:sixam_mart_delivery/controller/splash_controller.dart';
import 'package:sixam_mart_delivery/data/model/body/notification_body.dart';
import 'package:sixam_mart_delivery/data/model/response/conversation_model.dart';
import 'package:sixam_mart_delivery/data/model/response/withdrawal_list_model.dart';
import 'package:sixam_mart_delivery/helper/date_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/helper/user_type.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_app_bar.dart';
import 'package:sixam_mart_delivery/view/base/custom_image.dart';
import 'package:sixam_mart_delivery/view/base/custom_ink_well.dart';
import 'package:sixam_mart_delivery/view/base/custom_snackbar.dart';
import 'package:sixam_mart_delivery/view/base/paginated_list_view.dart';
import 'package:sixam_mart_delivery/view/screens/chat/widget/search_field.dart';
import 'package:sixam_mart_delivery/view/screens/dashboard/widget/bottom_nav_item.dart';

import '../../../controller/order_controller.dart';
import '../../../util/custom_card.dart';
import '../../base/custom_alert_dialog.dart';
class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  int _pageIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageIndex = 3;

    Get.find<AuthController>().getWithdrawalList();
    Get.find<AuthController>().getTotalWith();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Withdrawal List'.tr),
      bottomNavigationBar: GetPlatform.isDesktop ? const SizedBox() : BottomAppBar(
        elevation: 5,
        notchMargin: 5,
        shape: const CircularNotchedRectangle(),

        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Row(children: [
            BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage('main')),
            BottomNavItem(iconData: Icons.list_alt_rounded, isSelected: _pageIndex == 1,  onTap: () => _setPage('order-request')),
            BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 2, onTap: () => _setPage('order')),
            BottomNavItem(iconData: Icons.person, isSelected: _pageIndex == 3, onTap: () => _setPage('profile')),
          ]),
        ),
      ),
      body:  GetBuilder<AuthController>(builder: (authController) {
        return Column(
          children: [
            Center(
              child: Image.asset('assets/image/with.png', width: 100, height: 100,),
            ),
            Text('Total Withdrawals: ₦${authController.allWithdrawalBalModel?.total.toString()}'),
            Text('Pending Withdrawals: ₦${authController.allWithdrawalBalModel?.pending.toString()}'),
            SizedBox(height: 20,),
            authController.withdrawalList != null ?
            Expanded(
              child: ListView.builder(
                itemCount: authController.withdrawalList!.length,
                physics: PageScrollPhysics(),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  var withdrawal = authController.withdrawalList![index];
                  return CustomCard(
                    authController: authController,
                    id: withdrawal.id ?? 0,
                    name: withdrawal.fullname ?? '',
                    amount: withdrawal.amount ?? '',
                    time: withdrawal.createdAt ?? DateTime.now(),
                    status: withdrawal.status ?? '',
                    bank: withdrawal.bank ?? '',
                    accnum: withdrawal.accnum ?? '',
                  );
                },
              ),
            ) :  const Center(child: CircularProgressIndicator())
          ],
        );
      })

    );
  }
  void _setPage(String pageName) {
    setState(() {
      Get.toNamed(RouteHelper.getMainRoute(pageName));
    });
  }
}
