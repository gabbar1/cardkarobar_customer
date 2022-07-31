import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:upen/screen/partner/model/leadModel.dart';
import 'package:upen/screen/partner/model/referModel.dart';
import '../../commonWidget/loader.dart';
import '../profile/personalDetails/personalDetailModel.dart';
import 'model/raw_model.dart';

class AssignLeadController extends GetxController{

  var newLeadList = <LeadModel>[].obs;
  List<LeadModel> get getNewLeadList =>newLeadList.value;
  set setNewLeadList(LeadModel val){
    newLeadList.value.add(val);
    newLeadList.refresh();
  }
  DocumentSnapshot  lastNewDocument;
  latestLead(String leadType){
    newLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo:FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isEqualTo: leadType).limit(10).get().then((value) {
      if(value.docs.isNotEmpty){
        lastNewDocument = value.docs[value.docs.length -1];
      }
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setNewLeadList = leadModel;
      });
    });
  }
  refreshLatestLead(String leadType){
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isEqualTo: leadType).limit(10).startAfterDocument(lastNewDocument).get().then((value) {
      if(value.docs.isNotEmpty){
        lastNewDocument = value.docs[value.docs.length -1];
      }
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setNewLeadList = leadModel;
      });
    });
  }


  Future<void> assignLead(LeadModel leadModel,String leadType) async{
    try{
      showLoader();
        FirebaseFirestore.instance.collection("leads").doc(leadModel.key).update(leadModel.toJson()).then((value) {
          Navigator.pop(Get.context);
          latestLead(leadType);
         // historyLead();
          Get.snackbar("Alert", "Data Assigned");
        }
        );closeLoader();
    }catch(e){
      closeLoader();
      throw e;
    }

  }

  searchLead(int phone){
    newLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("customer_phone",isEqualTo: phone).get().then((value) {
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setNewLeadList = leadModel;
      });
    });
  }
  searchLeadByName(String name){
    newLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    orderBy("customer_name").where("customer_name",isGreaterThanOrEqualTo: name).where("customer_name",isLessThanOrEqualTo: name + '\uf8ff').get().then((value) {
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setNewLeadList = leadModel;
      });
    });
  }

  var productLists = <ReferModel>[].obs;
  List<ReferModel> get getProductLists => productLists.value;
  set setProductLists(ReferModel val){
    productLists.value.add(val);
    productLists.refresh();
  }
  productList(){
    productLists.value.clear();
    productLists.refresh();

    FirebaseFirestore.instance.collection("direct-selling-referral").where("type",isEqualTo: "Credit Card").get().then((value) {
      if(!value.docs.isEmpty){
        value.docs.forEach((element) {
          ReferModel referModel = ReferModel.fromJson(element.data());
          referModel.key = element.id;

          setProductLists = referModel;
        });
      }
    });
  }

  var referralDetail = UserDetailModel().obs;
  UserDetailModel get getReferralDetails => referralDetail.value;
  set setReferralDetails(UserDetailModel val){
    referralDetail.value =val;
    referralDetail.refresh();
  }
  referralDetails(String referralID){
    FirebaseFirestore.instance.collection("user_details").doc(referralID).get().then((value) {

      if(value.exists){

        UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
        setReferralDetails = userDetailModel;
      }
    });
  }

  var rawPrice = RawModel().obs;
  RawModel get getRawPrice => rawPrice.value;
  set setRawPrice(RawModel val){
    rawPrice.value =val;
    rawPrice.refresh();
  }
   productPrice(String productName) async{
    try{
     // showLoader();
      FirebaseFirestore.instance.collection("direct-selling-referral").where("name",isEqualTo: productName).get().then((value) {
        value.docs.forEach((element) {
          RawModel rawModel = RawModel.fromJson(element.data());
          setRawPrice = rawModel;
        });
      }).then((value) {
       // closeLoader();

      });
    }catch(e){
      throw e;
    }

  }
}