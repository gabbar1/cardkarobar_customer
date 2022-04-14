 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:upen/screen/partner/model/user_details.dart';



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

  }


