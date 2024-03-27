class WithdrawalListModel {
  int? id;
  String? fullname;
  String? bank;
  String? accnum;
  String? amount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  WithdrawalListModel({this.id, this.fullname, this.amount, this.status, this.bank, this.accnum, this.createdAt, this.updatedAt});

  WithdrawalListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['account_name'];
    bank = json['bank'];
    accnum = json['account_number'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullname;
    data['bank'] = bank;
    data['account_number'] = accnum;
    data['amount'] = amount;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}