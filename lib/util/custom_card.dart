import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/util/circular_button.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';

import '../helper/route_helper.dart';
import '../view/base/custom_snackbar.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime time;
  final String status;
  final String bank;
  final String accnum;
  final int id;
  final AuthController authController;

  const CustomCard({
    required this.name,
    required this.amount,
    required this.time,
    required this.status,
    required this.bank,
    required this.accnum,
    required this.id,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        color: status == 'approved' ? Colors.green[400] :
        status == 'pending' ? Colors.orange[400] :
            status == 'denied' ? Colors.red[400] :
        Colors.grey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'robotoMedium',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    bank + ' (${accnum})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₦' + amount,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getTimeString(time),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  status == 'approved' ?
                  Text('Approved',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ) :
                  status == 'pending' ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      CircularButton(text: 'cancel?', onPressed: () async {
                        await authController.cancelWithdraw(id.toString()).then((status) async {
                          if (status.isSuccess) {
                            showCustomSnackBar('Cancel request approved.', isError: false);
                            Get.toNamed(RouteHelper.getMainRoute('main'));
                          }else {
                            showCustomSnackBar(status.message);
                          }
                        });
                        print('cancel ${id.toString()}');
                      },),
                    ],
                  ) :
                  Text(status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTimeString(DateTime time) {
    // Format the DateTime to your desired string format
    // For example:
    return DateFormat('yyyy-MM-dd HH:mm a').format(time);
  }
}
