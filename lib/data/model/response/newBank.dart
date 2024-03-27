class NewBankModel {
  String? status;

  NewBankModel(
      {this.status});

  NewBankModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
