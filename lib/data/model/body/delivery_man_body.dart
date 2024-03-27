class DeliveryManBody {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? identityType;
  String? identityNumber;
  String? earning;
  String? zoneId;
  String? vehicleId;
  String? bank;
  String? accNum;
  String? accName;
  String? delcomId;

  DeliveryManBody(
      {this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.identityType,
        this.identityNumber,
        this.earning,
        this.zoneId,
        this.vehicleId,
        this.accNum,
        this.bank,
        this.accName,
        this.delcomId,
      });

  DeliveryManBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    identityType = json['identity_type'];
    identityNumber = json['identity_number'];
    earning = json['earning'];
    zoneId = json['zone_id'];
    vehicleId = json['vehicle_id'];
    bank = json['bank'];
    accNum = json['account_number'];
    accName = json['account_name'];
    delcomId = json['delcom_id'];

  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['f_name'] = fName!;
    data['l_name'] = lName!;
    data['phone'] = phone!;
    data['email'] = email!;
    data['password'] = password!;
    data['identity_type'] = identityType!;
    data['identity_number'] = identityNumber!;
    data['earning'] = earning!;
    data['zone_id'] = zoneId!;
    data['vehicle_id'] = vehicleId!;
    data['bank'] = bank!;
    data['account_number'] = accNum!;
    data['account_name'] = accName!;
    data['delcom_id'] = delcomId!;
    return data;
  }
}
