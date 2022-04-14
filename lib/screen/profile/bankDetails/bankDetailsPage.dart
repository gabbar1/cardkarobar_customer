import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/profile/bankDetails/bankDetail_controller.dart';

import '../../../commonWidget/loader.dart';
import 'bankDetailModel.dart';

class BankDetailsScreen extends StatefulWidget {
  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  File croppedFile;
  BankDetailsController _detailsController = Get.put(BankDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Details"),
      ),
      body: Container(
        padding:
            EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0, top: 20),
        child: ListView(
          children: [
            Obx(() => CommonTextInput(
                inputController: _detailsController.getBankNameController,
                textInputAction: TextInputAction.next,
                labeltext: "Bank Name",
                hint: "Enter Bank Name")),
            Obx(() => CommonTextInput(
                inputController: _detailsController.getNameController,
                textInputAction: TextInputAction.next,
                labeltext: "Name as per bank record",
                hint: "Enter Your Name")),
            Obx(() => CommonTextInput(
                inputController: _detailsController.getAccountNumberController,
                textInputAction: TextInputAction.next,
                labeltext: "Account Number",
                textInputType: TextInputType.phone,
                hint: "Enter Account Number")),
            Obx(() => CommonTextInput(
                inputController: _detailsController.getIFSCController,
                textInputAction: TextInputAction.next,
                labeltext: "IFSC Code",
                hint: "Enter IFSC Code")),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 20),
              child: CommonText(
                  text: "Upload cancelled cheque or passbook", fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _showPicker();

              },
              child: Obx(() => _detailsController.getFilePath == null
                  ? _detailsController.getDocumentUrl == null
                      ? Container(
                          width: 40,
                          height: 180,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    _detailsController.getDocumentUrl),
                                fit: BoxFit.fill),
                            border: Border.all(),
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(Icons.camera_alt,
                              size: 60, color: Colors.grey),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff0F1B25),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Container(
                            width: 40,
                            height: 180,
                            child: Icon(Icons.camera_alt,
                                size: 60, color: Colors.grey),
                          ),
                        )
                  : Container(
                      width: 40,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_detailsController.getFilePath),
                            fit: BoxFit.fill),
                        border: Border.all(),
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:
                          Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                    )),
            ),
            SizedBox(
              height: 25,
            ),
            CommonButton(
              onPressed: () {
                print(_detailsController.getFilePath.toString());
                if (_detailsController.getFilePath != "") {
                  print(
                      "============_detailsController.getFilePath============;");
                  _detailsController.uploadFile(_detailsController.getFilePath);
                } else {
                  UserBankDetailModel userBankDetailModel = UserBankDetailModel(
                      bankName: _detailsController.getBankNameController.text,
                      accHolderName: _detailsController.getNameController.text,
                      accHolderNumber:
                          _detailsController.getAccountNumberController.text,
                      accHolderIfsc: _detailsController.getIFSCController.text,
                      accHolderDocType:
                          _detailsController.getDocTypeController.text,
                      accHolderDocUrl: _detailsController.getDocumentUrl,
                      docVerification: false);
                  FirebaseFirestore.instance
                      .collection("user_details")
                      .doc(FirebaseAuth.instance.currentUser.phoneNumber
                          .replaceAll("+91", ""))
                      .collection("bank_details")
                      .doc("bank_details")
                      .set(userBankDetailModel.toJson())
                      .then((value) {
                    closeLoader();
                    Navigator.of(Get.context).pop();
                    Get.snackbar("Done", "Thank you for updating profile",
                        backgroundColor: Constants().mainColor);
                  }).onError((error, stackTrace) {
                    closeLoader();
                    Get.snackbar("Error", error.toString(),
                        backgroundColor: Constants().mainColor);
                  });
                }
              },
              buttonText: "Submit",
              buttonColor: Constants().mainColor,
              vPadding: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  void _showPicker() {
    showModalBottomSheet(
        context: Get.context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(Get.context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(Get.context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      displayImageOptions(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      displayImageOptions(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  Future<void> displayImageOptions(String path) async {
    ImageCropper c = ImageCropper();

    croppedFile = await c.cropImage(
        sourcePath: path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Adjust Image",
            toolbarColor: Constants().mainColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));
    _detailsController.setFilePath(croppedFile);
  }

  @override
  void initState() {
    _detailsController.bankDetails();
  }
}
