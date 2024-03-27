import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_delivery/data/model/body/delivery_man_body.dart';
import 'package:sixam_mart_delivery/data/model/body/record_location_body.dart';

import 'package:sixam_mart_delivery/data/api/api_client.dart';
import 'package:sixam_mart_delivery/data/model/response/profile_model.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String phone, String password) async {
    return await apiClient.postData(AppConstants.loginUri, {"phone": phone, "password": password});
  }

  Future<Response> withdraw(String amount) async {
    return await apiClient.postData('${AppConstants.withdrawUri}${getUserToken()}', {"amount": amount});
  }

  Future<Response> updateBank(String accountName, String bank, String accountNumber ) async {
    return await apiClient.postData('${AppConstants.updateAccountUri}${getUserToken()}', {"account_name": accountName, "bank": bank, "account_number": accountNumber});
  }


  Future<Response> cancelWith(String id) async {
    return await apiClient.getData('${AppConstants.cancelWithdrawalUri}${getUserToken()}&withdraw_id=${id}');
  }

  Future<Response> cancelBankUpdate(String id) async {
    return await apiClient.getData('${AppConstants.cancelBankUpdateUri}${getUserToken()}&request_id=${id}');
  }

  Future<Response> newBankInfo() async {
    return await apiClient.getData('${AppConstants.newBankUri}${getUserToken()}');
  }

  Future<Response> getCompanies() async {
    return await apiClient.getData('${AppConstants.getCompaniesUri}');
  }

  Future<Response> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileUri + getUserToken());
  }

  Future<Response> recordLocation(RecordLocationBody recordLocationBody) {
    recordLocationBody.token = getUserToken();
    return apiClient.postData(AppConstants.recordLocationUri, recordLocationBody.toJson());
  }

  Future<Response> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!,
      'email': userInfoModel.email!, 'token': getUserToken()
    });
    return await apiClient.postMultipartData(AppConstants.updateProfileUri, fields, [MultipartBody('image', data)]);
  }

  Future<Response> changePassword(ProfileModel userInfoModel, String password) async {
    return await apiClient.postData(AppConstants.updateProfileUri, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'email': userInfoModel.email, 'password': password, 'token': getUserToken()});
  }

  Future<Response> updateActiveStatus() async {
    return await apiClient.postData(AppConstants.activeStatusUri, {'token': getUserToken()});
  }

  Future<Response> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      // FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.VEHICLE_WISE_TOPIC));
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if(!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    if (kDebugMode) {
      print('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  Future<Response> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.forgetPasswordUri, {"phone": phone});
  }

  Future<Response> verifyToken(String? phone, String token) async {
    return await apiClient.postData(AppConstants.verifyTokenUri, {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String? resetToken, String phone, String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.resetPasswordUri,
      {"_method": "put", "phone": phone, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
    );
  }

  Future<bool> saveUserToken(String token, String zoneTopic/*, String vehicleWiseTopic*/) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode));
    sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    // sharedPreferences.setString(AppConstants.VEHICLE_WISE_TOPIC, vehicleWiseTopic);

    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
      FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      // FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.VEHICLE_WISE_TOPIC));
      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": '@'});
    }
    await sharedPreferences.remove(AppConstants.token);
    await sharedPreferences.setStringList(AppConstants.ignoreList, []);
    await sharedPreferences.remove(AppConstants.userAddress);
    apiClient.updateHeader(null, null);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
        // FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.VEHICLE_WISE_TOPIC));
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  Future<Response> deleteDriver() async {
    return await apiClient.deleteData(AppConstants.driverRemoveUri + getUserToken());
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.zoneListUri);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  Future<bool> saveUserAddress(String address, List<int>? zoneIDs) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      sharedPreferences.getString(AppConstants.languageCode),
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> registerDeliveryMan(DeliveryManBody deliveryManBody, List<MultipartBody> multiParts) async {
    return apiClient.postMultipartData(AppConstants.dmRegisterUri, deliveryManBody.toJson(), multiParts);
  }

  Future<Response> getVehicleList() async {
    return await apiClient.getData(AppConstants.vehiclesUri);
  }
  Future<Response> getWithdrawalList() async {
    return await apiClient.getData('${AppConstants.withdrawalListUri}${getUserToken()}');
  }
  Future<Response> getAllWiths() async {
    return await apiClient.getData('${AppConstants.totalWithUri}${getUserToken()}');
  }

  Future<Response> getWithdrawalStat() async {
    return await apiClient.getData('${AppConstants.withdrawalUri}${getUserToken()}');
  }

}
