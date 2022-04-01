
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:upen/screen/dashBoard/models/productModel.dart';
import 'package:upen/screen/myWork/model/contact_model.dart';

import '../../../commonWidget/loader.dart';
import '../models/bannerModel.dart';
import '../service/cardkarobar.dart';

class DashBoardController extends GetxController{

  var banners = <BannerModel>[].obs;
  List<BannerModel> get getBanners => banners.value;
  var isHide = false.obs;
  bool get getIsHide => isHide.value;

 var productList = <ProductModel>[].obs;
  List<ProductModel> get getProducts=> productList.value;

  setIsHide(bool val){
    isHide.value = val;
  }

  setBannerList(BannerModel bannerModel){

    this.banners.add(bannerModel);

  }



  Future<void> getBannerList()async{
    banners.value.clear();
    getBanners.clear();
      try {

        FirebaseFirestore.instance
            .collection("banners")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((element) {

            Map<String, dynamic> bannerList = element.data();
            BannerModel bannerModel = BannerModel.fromJson(bannerList);
            setBannerList(bannerModel);
          });
        });
      } catch (exception) {
        throw exception;
      }
    }

  Future<void> getProductList()async{
    productList.value.clear();
    try {

      FirebaseFirestore.instance
          .collection("products")
          .get()
          .then((QuerySnapshot querySnapshot) {

        querySnapshot.docs.forEach((element) {
          print("----------------CheckElement----------------");

          ProductModel _productModel = ProductModel(id:element.id,steps: element["steps"] );
          print(_productModel.id);
          print(_productModel.steps);
          setProductList(_productModel);
        });
      });
    } catch (exception) {
      throw exception;
    }
  }

  var isRecall = true.obs;
  bool  get getIsRecall => isRecall.value;
  setIsRecall(bool val){
    isRecall.value = val;
    isRecall.refresh();
  }

  /*Future<void> removeZero()async{
    try {

      FirebaseFirestore.instance
          .collection("contactData").where("version",isEqualTo: "policy_guj").where("mobile",isGreaterThanOrEqualTo: ".0")
          .get()
          .then((QuerySnapshot querySnapshot) {


        querySnapshot.docs.forEach((element) {
          UserContactModel userContactModel = UserContactModel.fromJson(element.data());
          print("===================querySnapshot00000000000000000000000========================");
        //  print(jsonEncode(userContactModel));
          userContactModel.key = element.id;
          print(userContactModel.key);
          if(userContactModel.mobile.contains(".0")){
            print(userContactModel.mobile);
            userContactModel.mobile.replaceAll(".0", "");
            print(userContactModel.mobile.replaceAll(".0", ""));
            FirebaseFirestore.instance.collection("contactData").doc(userContactModel.key).update({
              "mobile":userContactModel.mobile.replaceAll(".0", ""),
              "name":userContactModel.name,
              "email":userContactModel.email,
              "city":userContactModel.city,
              "state":userContactModel.state,
              "status":false,
              "version":"policy_guj"
             });
          }else{
            Get.snackbar("Not", "found");
          }
        });
      });
    } catch (exception) {
      throw exception;
    }
  }*/

  setProductList(ProductModel val){
    productList.value.add(val);
    productList.refresh();
  }

  redeemMoney(){
    String email,amount;
    try{
      showLoader();
      FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).get().then((value) {
        if(value.exists){
          email = value["advisor_email"];
          amount = value["current_wallet"];
          FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).collection("bank_details").doc("bank_details").get().then((bankValue) {
            if(bankValue.exists){
              if(bankValue["doc_verification"]){
                if(value["current_wallet"]=="0"){
                  closeLoader();
                  Get.snackbar("Alert", "You do not have sufficient fund to redeem");
                } else if(int.parse(value["current_wallet"])<=50){
                  closeLoader();
                  Get.snackbar("Alert", "Minimum withdrawal amount is 50 rupees");
                }else{
                  FirebaseFirestore.instance.collection("payment_history").add({
                    "PYMT_PROD_TYPE_CODE":"PAB_VENDOR",
                    "PYMT_MODE":"NEFT",
                    "DEBIT_ACC_NO":"138505004285",
                    "BNF_NAME":bankValue["acc_holder_name"],
                    "BENE_ACC_NO":bankValue["acc_holder_number"],
                    "BENE_IFSC":bankValue["acc_holder_ifsc"],
                    "AMOUNT":value["current_wallet"],
                    "REMARK":"Payout",
                    "PYMT_DATE":Timestamp.now(),
                    "status":"UnderProcess",
                    "user_id":FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")
                  }).then((value) {
                    FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).update({
                      "current_wallet":"0"
                    });
                    closeLoader();
                    sendMail(email,amount);
                    Get.snackbar("Success","Request Initiated");
                  });
                }

              }else{
                closeLoader();
                Get.snackbar("Alert", "Your bank details has not verified");
              }
            }else{
              closeLoader();
              Get.snackbar("Alert", "Enter your bank details");
            }
          });
        }
      });
    }catch(e){
      closeLoader();
      Get.snackbar("Error",e.toString());
      throw e;
    }
  }

  sendMail(String email,amount) async{
    try {
      print("===============email============");
      print(email);
      print(amount);
      final smtpServer =  cardkarobarMail("hr@cardkarobar.in","Card@12911");
      final message = Message()
        ..from = Address("info@cardkarobar.in")
        ..recipients.add(email.trim())
        ..subject =
            "Payment Request of Rupees ${amount} on : ${DateTime.now()}"
        ..html =
            "<h3>THANK YOU FOR CHOOSING CardKarobar \n\n Your Payment would be processed soon</h3>";
      final sendReport = await send(message, smtpServer);
      print(sendReport.mail.toString());
      print(sendReport.connectionOpened.toString());
      print(sendReport.messageSendingEnd.toString());
      print(sendReport.messageSendingStart.toString());
    }catch(e){
      Get.snackbar("Error", e.toString());
    }


  }

}