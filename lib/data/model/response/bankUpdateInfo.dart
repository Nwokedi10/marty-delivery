class BankUpdateInfoModel {
  String? accountName;
  String? accountNumber;
  String? bank;
  String? status;
  int? id;

  BankUpdateInfoModel(
      {this.status, this.bank, this.accountNumber, this.accountName, this.id});

  BankUpdateInfoModel.fromJson(Map<String, dynamic> json) {
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    bank = json['bank'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['bank'] = bank;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
