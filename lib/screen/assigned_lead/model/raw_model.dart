class RawModel {
  int rawPrice;
  int price;

  RawModel({this.rawPrice, this.price});

  RawModel.fromJson(Map<String, dynamic> json) {
    rawPrice = json['rawPrice'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rawPrice'] = this.rawPrice;
    data['price'] = this.price;
    return data;
  }
}
