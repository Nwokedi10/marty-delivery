class AllWithdrawalBalModel {
  String? total;
  String? pending;

  AllWithdrawalBalModel({this.total, this.pending});

  AllWithdrawalBalModel.fromJson(Map<String, dynamic> json) {
    total = json['total_withdrawn'];
    pending = json['pending_withdraw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_withdrawn'] = total;
    data['pending_withdraw'] = pending;
    return data;
  }
}