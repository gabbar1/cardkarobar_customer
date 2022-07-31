 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:upen/screen/partner/model/user_details.dart';

import '../partner/model/leadModel.dart';



class ReferController extends GetxController{
  
  var referralList = <UserDetailModel>[].obs;
  List<UserDetailModel> get getReferralList => referralList.value;
  setReferralUserList(UserDetailModel val){
    referralList.value.add(val);
    referralList.refresh();
  }


  DocumentSnapshot lastRefferalDocument ;
  getReferralUserList() {
    referralList.value.clear();
    try {
      FirebaseFirestore.instance.collection("user_details").where(
          "refered_By", isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).limit(10).get().then((value) {
        if(value.docs.isNotEmpty){
          lastRefferalDocument = value.docs[value.docs.length -1];
        }
        value.docs.forEach((element) {
          Map<String, dynamic> ReferralList = element.data();
          UserDetailModel userDetailModel = UserDetailModel.fromJson(ReferralList);

          setReferralUserList(userDetailModel);
        }
        );
      });
    }
    catch (exception) {
      throw exception;
    }
  }

  getRefreshReferralUserList() {

    try {
      FirebaseFirestore.instance.collection("user_details").where(
          "refered_By", isEqualTo:FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).startAfterDocument(lastRefferalDocument).limit(10).get().then((value) {
        if(value.docs.isNotEmpty){
          lastRefferalDocument = value.docs[value.docs.length -1];
        }
        value.docs.forEach((element) {
          Map<String, dynamic> ReferralList = element.data();
          UserDetailModel userDetailModel = UserDetailModel.fromJson(ReferralList);

          setReferralUserList(userDetailModel);
        }
        );
      });
    }
    catch (exception) {
      throw exception;
    }
  }
  var leadUpdateList = <LeadModel>[].obs;
  List<LeadModel> get getLeadUpdateList => leadUpdateList.value;
  set setLeadUpdateList(LeadModel val){
    leadUpdateList.value.add(val);
    leadUpdateList.refresh();
  }
  DocumentSnapshot lastDocument;
  var leadCount = 0.obs;
  int  get getLeadCount => leadCount.value;
  set setLeadCount(int val){
    leadCount.value =val;
    leadCount.refresh();
  }
  leadUpdate(String type,int user){
    leadUpdateList.value.clear();
    leadUpdateList.refresh();

    if(type=="Today"){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(!value.docs.isEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {

            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }

      });
    }
    else if (type =='YesterDay'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-1);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(value.docs.isNotEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {
            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }
      });
    }
    else if(type =='This Week') {
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-6);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(value.docs.isNotEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {
            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }
      });
    }
    else if(type == 'Last Week'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-13);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(value.docs.isNotEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {
            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }
      });
    }
    else if(type =='This Month'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(value.docs.isNotEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {
            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }
      });
    }
    else if(type =='Last Month'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month-29);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        if(value.docs.isNotEmpty){
          lastDocument = value.docs[value.docs.length -1];
          setLeadCount = value.docs.length;
          value.docs.forEach((element) {
            LeadModel _leadModel = LeadModel.fromJson(element.data());
            _leadModel.key = element.id;
            setLeadUpdateList = _leadModel;
          });
        }
      });
    }
    else{
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
      FirebaseFirestore.instance.collection("leads").where("referral_id",isEqualTo: user).get().then((value) {
       if(value.docs.isNotEmpty){
         lastDocument = value.docs[value.docs.length -1];
         setLeadCount = value.docs.length;
         value.docs.forEach((element) {
           LeadModel _leadModel = LeadModel.fromJson(element.data());
           _leadModel.key = element.id;
           setLeadUpdateList = _leadModel;
         });
       }
      });
    }

  }
  }


