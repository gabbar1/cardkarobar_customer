import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upen/screen/partner/model/leadModel.dart';

import '../../commonWidget/loader.dart';

class AssignLeadController extends GetxController{

  var newLeadList = <LeadModel>[].obs;
  List<LeadModel> get getNewLeadList =>newLeadList.value;
  set setNewLeadList(LeadModel val){
    newLeadList.value.add(val);
    newLeadList.refresh();
  }
  DocumentSnapshot  lastNewDocument;
  latestLead(){
    newLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isEqualTo: "UnderProcess").limit(10).get().then((value) {
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
  refreshLatestLead(){
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isEqualTo: "UnderProcess").limit(10).startAfterDocument(lastNewDocument).get().then((value) {
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


  var historyLeadList = <LeadModel>[].obs;
  List<LeadModel> get getHistoryLeadList =>historyLeadList.value;
  set setHistoryLeadList(LeadModel val){
    historyLeadList.value.add(val);
    historyLeadList.refresh();
  }
  DocumentSnapshot  lastHistoryDocument;
  historyLead(){
    historyLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isNotEqualTo: "UnderProcess").limit(10).get().then((value) {
      if(value.docs.isNotEmpty){
        lastHistoryDocument = value.docs[value.docs.length -1];
      }
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setHistoryLeadList = leadModel;
      });
    });
  }

  refreshHistoryLead(){
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("status",isNotEqualTo: "UnderProcess").orderBy("status").limit(10).startAfterDocument(lastHistoryDocument).get().then((value) {
      if(value.docs.isNotEmpty){
        lastHistoryDocument = value.docs[value.docs.length -1];
      }
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setHistoryLeadList = leadModel;
      });
    });
  }

  Future<void> assignLead(LeadModel leadModel) async{
    try{
      showLoader();
        FirebaseFirestore.instance.collection("leads").doc(leadModel.key).update(leadModel.toJson()).then((value) {
          Navigator.pop(Get.context);
          latestLead();
          historyLead();
          Get.snackbar("Alert", "Data Assigned");
        }
        );closeLoader();
    }catch(e){
      closeLoader();
      throw e;
    }

  }

  searchLead(int phone){
    historyLeadList.value.clear();
    FirebaseFirestore.instance.collection("leads").where("assignedTo",isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).
    where("customer_phone",isEqualTo: phone).get().then((value) {
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setHistoryLeadList = leadModel;
        setNewLeadList=leadModel;
      });
    });
  }
}