class WithModel {
  String? status;
  String? error;
  String? min;

  WithModel(
      {this.status,
        this.error,
        this.min});

  WithModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['min'] = min;
    return data;
  }
}
