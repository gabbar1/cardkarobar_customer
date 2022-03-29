class UserDetailModel {

  String advisorEmail;
  String advisorName;
  String advisorPhoneNumber;
  String advisorDob;
  String advisorAdd1;
  String advisorAdd2;
  String advisorCity;
  String advisorState;
  int advisorPincode;
  String advisorOccupation;
  String advisorUrl;


  UserDetailModel(
      {
        this.advisorEmail,
        this.advisorName,
        this.advisorPhoneNumber,
        this.advisorDob,
        this.advisorAdd1,
        this.advisorAdd2,
        this.advisorCity,
        this.advisorState,
        this.advisorPincode,
        this.advisorOccupation,
        this.advisorUrl,
      });

  UserDetailModel.fromJson(Map<String, dynamic> json) {

    advisorEmail = json['advisor_email'];
    advisorName = json['advisor_name'];
    advisorPhoneNumber = json['advisor_phone_number'];
    advisorDob = json['advisor_dob'];
    advisorAdd1 = json['advisor_add1'];
    advisorAdd2 = json['advisor_add2'];
    advisorCity = json['advisor_city'];
    advisorState = json['advisor_state'];
    advisorPincode = json['advisor_pincode'];
    advisorOccupation = json['advisor_occupation'];
    advisorUrl = json['advisor_Url'];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advisor_email'] = this.advisorEmail;
    data['advisor_name'] = this.advisorName;
    data['advisor_phone_number'] = this.advisorPhoneNumber;
    data['advisor_dob'] = this.advisorDob;
    data['advisor_add1'] = this.advisorAdd1;
    data['advisor_add2'] = this.advisorAdd2;
    data['advisor_city'] = this.advisorCity;
    data['advisor_state'] = this.advisorState;
    data['advisor_pincode'] = this.advisorPincode;
    data['advisor_occupation'] = this.advisorOccupation;
    data['advisor_Url'] = this.advisorUrl;
    return data;
  }
}

