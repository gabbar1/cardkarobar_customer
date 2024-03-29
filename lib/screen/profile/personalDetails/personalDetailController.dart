
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upen/commonWidget/loader.dart';
import '../../helper/constant.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailModel.dart' as personal ;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

import '../../partner/model/user_details.dart';
import '';
enum SingingCharacter { a,b }
enum StatusCharacter {a,b,c,d,e,f,g,h}
enum AssignCharacter {a,b,c,d,e}
enum LeadCharacter { a,b,c,d,e }
enum SearchByValue { a,b }
class PersonalDetailsController extends GetxController{
  var nameController = TextEditingController().obs;
  TextEditingController get getNameController => nameController.value;
  var phoneController = TextEditingController().obs;
  TextEditingController get getPhoneController => phoneController.value;
  var emailController = TextEditingController().obs;
  TextEditingController get getEmailController => emailController.value;
  var dobController = TextEditingController().obs;
  TextEditingController get getDobController => dobController.value;
  var add1Controller = TextEditingController().obs;
  TextEditingController get getAdd1Controller => add1Controller.value;
  var add2Controller = TextEditingController().obs;
  TextEditingController get getAdd2Controller => add2Controller.value;
  var cityController = TextEditingController().obs;
  TextEditingController get getCityController => cityController.value;
  var stateController = TextEditingController().obs;
  TextEditingController get getStateController => stateController.value;
  var pincodeController = TextEditingController().obs;
  TextEditingController get getPincodeController => pincodeController.value;
  var occupationController = TextEditingController().obs;
  TextEditingController get getOccupationController => occupationController.value;
  var referedBy = "".obs;
  String get getReferedBy => referedBy.value;
  var occupationType = SingingCharacter.a.obs;
  SingingCharacter get getOccupationType => occupationType.value;
  var currentWallet = "".obs;
  String get getCurrentWallet => currentWallet.value;
  var totalWallet = "".obs;
  String get getTotalWallet => totalWallet.value;

  var isAdmin = false.obs;
  var isEnable = false.obs;
  bool get getIsAdmin => isAdmin.value;
  bool get getIsEnable => isEnable.value;



  var userDetailModel = UserDetailModel().obs;

  UserDetailModel get getUserDetail => userDetailModel.value;
  var documentUrl = "".obs;
  String get getDocumentUrl => documentUrl.value;
  setUserModel(UserDetailModel val){
    userDetailModel.value = val;
    nameController.value.text =val.advisorName;
    phoneController.value.text =val.advisorPhoneNumber;
    emailController.value.text =val.advisorEmail;
    dobController.value.text =val.advisorDob;
    add1Controller.value.text =val.advisorAdd1;
    add2Controller.value.text =val.advisorAdd2;
    cityController.value.text =val.advisorCity;
    stateController.value.text =val.advisorState;
    pincodeController.value.text =val.advisorPincode.toString().isBlank ?"":val.advisorPincode.toString();
    occupationController.value.text =val.advisorOccupation;
    occupationType.value = val.advisorOccupation == "Job"? SingingCharacter.a :SingingCharacter.b;
    isEnable.value = val.isEnabled;
    isAdmin.value = val.isAdmin;
    documentUrl.value = val.advisorUrl;
    currentWallet.value =val.current_wallet;
    totalWallet.value = val.total_wallet;
    currentWallet.refresh();
    totalWallet.refresh();
    documentUrl.refresh();
    nameController.refresh();
    phoneController.refresh();
    emailController.refresh();
    dobController.refresh();
    add1Controller.refresh();
    add2Controller.refresh();
    cityController.refresh();
    stateController.refresh();
    pincodeController.refresh();
    occupationController.refresh();
    userDetailModel.refresh();

  }
  Future<void> personalDetails() async{
    FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).get().then((value) {
      UserDetailModel _userDetailModel = UserDetailModel();
      setUserModel(_userDetailModel);

      UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data().cast());
      setUserModel(userDetailModel);
    });

  }




  Future<void> updatePersonalDetails(personal.UserDetailModel userDetailModel) async{
    showLoader();
    FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).update(userDetailModel.toJson())
        .then((value) {
      closeLoader();
      Navigator.of(Get.context).pop();
      Get.snackbar("Done", "Thank you for updating profile",backgroundColor: Constants().mainColor);
    }).onError((error, stackTrace) {
      closeLoader();
      Get.snackbar("Error", error.toString(), backgroundColor: Constants().mainColor);
    });

  }

  Future<firebase_storage.UploadTask> uploadFile( file) async {
    if (file == null) {
      ScaffoldMessenger.of(Get.context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref().child("profile")
        .child(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", ""))
        .child('/${FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file});


    uploadTask = ref.putFile(io.File(file), metadata);
    _downloadLink(uploadTask.snapshot.ref);

    return Future.value(uploadTask);
  }

  Future<void> _downloadLink(firebase_storage.Reference ref) async {

    try{
     
      final link = await ref.getDownloadURL();
      if(link!=null){
        documentUrl.value ="";
        documentUrl.value = link;
        documentUrl.refresh();

        personal.UserDetailModel userDetailModel = personal.UserDetailModel(
            advisorName: getNameController.text,
            advisorAdd1: getAdd1Controller.text,
            advisorAdd2: getAdd2Controller.text,
            advisorCity: getCityController.text,
            advisorDob: getDobController.text,
            advisorEmail: getEmailController.text,
            advisorOccupation: getOccupationType == SingingCharacter.a ?"Job":"Own",
            advisorPhoneNumber: getPhoneController.text,
            advisorPincode: int.parse( getPincodeController.text),
            advisorState: getStateController.text,
            advisorUrl:link,
           );
        updatePersonalDetails(userDetailModel);

        

      }
    }  catch( exception){
      Get.snackbar("Error",exception.toString(), backgroundColor: Constants().mainColor);
      throw exception ;
    }

  }




  var filePath = ("").obs;
   get getFilePath => filePath.value;
  setFilePath( val){
    filePath.value =val;
    filePath.refresh();
  }

  var telecallerContact = 0.obs;
  int get getTelecallerContact => telecallerContact.value;
  set setTelecallerContact(int val){
    telecallerContact.value= val;
    telecallerContact.refresh();
  }
  getTelecallers(String product)async{
    try{

      FirebaseFirestore.instance.collection("telecaller").where(product,isEqualTo: true).get().then((value) {
        if(value.docs.isNotEmpty){
          final _random = Random();

           setTelecallerContact= value.docs.toList()[_random.nextInt(value.docs.length)]['mobile'];


        }
      });
    }catch(e){
      throw e;
    }
  }
}