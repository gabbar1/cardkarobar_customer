import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel {
  int referralPrice;
  int referralId;
  String product;
  String status;
  Timestamp time;
  String customerName;
  int customerPhone;
  String customerEmail;
  String customerState;
  String customerCity;
  String customerLeadType;
  String customerSalary;
  String customerItr;
  String customerCardLimit;
  String customerHasCar;
  String customerCibil;
  String comment;
  String adminComment;
  String type;
  String key;
  String assignedTo;
  String percentage;
  String desireAmount;
  String applicationNumber;
  bool isFixedPrice;
  bool isLeadClosed;
  String selfLead;
  bool isEnabled;
  String mode;

  LeadModel(
      {this.referralPrice,
        this.referralId,
        this.product,
        this.status,
        this.time,
        this.customerName,
        this.customerPhone,
        this.customerEmail,
        this.key,
        this.comment,
        this.customerCardLimit,
        this.customerCibil,
        this.customerCity,
        this.customerHasCar,
        this.customerItr,
        this.customerLeadType,
        this.customerSalary,
        this.customerState,
        this.type,
        this.assignedTo,
        this.adminComment,
        this.isFixedPrice,
        this.percentage,
        this.desireAmount,
        this.applicationNumber,
        this.isLeadClosed,
        this.selfLead,
        this.isEnabled,
        this.mode
      });

  LeadModel.fromJson(Map<String, dynamic> json) {
    referralPrice = json['referral_price'];
    referralId = json['referral_id'];
    product = json['product'];
    status = json['status'];
    time = json['time'].runtimeType==String ?Timestamp.fromDate(DateTime.parse(json['time'])):json['time'] ;
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    comment = json['comment'];
    customerCardLimit = json['customerCardLimit'];
    customerCibil = json['customerCibil'];
    customerCity = json['customerCity'];
    customerHasCar = json['customerHasCar'];
    customerItr = json['customerItr'];
    customerLeadType = json['customerLeadType'];
    customerSalary = json['customerSalary'];
    customerState = json['customerState'];
    key = json['key'];
    type = json['type'];
    assignedTo = json['assignedTo'];
    adminComment = json['adminComment'];
    percentage = json['percentage'];
    isFixedPrice = json['isFixedPrice'];
    desireAmount = json['desireAmount'];
    applicationNumber = json['applicationNumber'];
    isLeadClosed = json['isLeadClosed'];
    selfLead = json['selfLead'];
    isEnabled = json['isEnabled'];
    mode =json['mode'];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referral_price'] = this.referralPrice;
    data['referral_id'] = this.referralId;
    data['product'] = this.product;
    data['status'] = this.status;
    data['time'] = this.time;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['comment'] = this.comment;
    data['customerCardLimit'] = this.customerCardLimit;
    data['customerCibil'] = this.customerCibil;
    data['customerCity'] = this.customerCity;
    data['customerHasCar'] = this.customerHasCar;
    data['customerItr'] = this.customerItr;
    data['customerLeadType'] = this.customerLeadType;
    data['customerSalary'] = this.customerSalary;
    data['customerState'] = this.customerState;
    data['key'] = this.key;
    data['type'] = this.type;
    data['assignedTo'] = this.assignedTo;
    data['adminComment'] = this.adminComment;
    data['isFixedPrice'] = this.isFixedPrice;
    data['percentage'] = this.percentage;
    data['desireAmount'] = this.desireAmount;
    data['applicationNumber'] = this.applicationNumber;
    data['isLeadClosed'] = this.isLeadClosed;
    data['selfLead'] = this.selfLead;
    data['isEnabled'] = this.isEnabled;
    data['mode'] = this.mode;
    return data;
  }
}
