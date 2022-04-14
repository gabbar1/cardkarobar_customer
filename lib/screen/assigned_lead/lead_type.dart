class LeadType {
  String type;
  bool status;

  LeadType({this.type, this.status});

  LeadType.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}
