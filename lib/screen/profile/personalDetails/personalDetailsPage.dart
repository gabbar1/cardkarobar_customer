import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailController.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailModel.dart';

//import 'personalDetailModel.dart';

class PersonalDetailsScreen extends StatefulWidget {
  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  TextEditingController dobController = TextEditingController();

  PersonalDetailsController _personalDetailsController =
      Get.put(PersonalDetailsController());
  File croppedFile;
  @override
  void initState() {
    // TODO: implement initState
    _personalDetailsController.personalDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal details"),
      ),
      body: Container(
        padding:
            EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0, top: 20),
        color: Colors.blue[30],
        child: ListView(
          children: <Widget>[
            Obx(() => CommonTextInputWithTitle(
                  
                  isReadOnly: true,
                  textInputAction: TextInputAction.next,
                  inputController: _personalDetailsController.getNameController,
                  title: "Name",
                  hint: "Enter Name",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  isReadOnly: true,
                  textInputAction: TextInputAction.next,
                  inputController:
                      _personalDetailsController.getPhoneController,
                  title: "Mobile Number",
                  hint: "Enter Mobile Number",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  isReadOnly: true,
                  textInputAction: TextInputAction.next,
                  inputController:
                      _personalDetailsController.getEmailController,
                  title: "Email Address",
                  hint: "Enter Email Address",
                )),
            SizedBox(
              height: 20,
            ),
            Obx(() => Container(
              decoration: const BoxDecoration(
                color: Color(0xff0F1B25),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonText(text: "Date of Birth"),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: _personalDetailsController.getDobController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                        BorderSide(width: 1, color: Colors.transparent),
                      ),
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      border: OutlineInputBorder(),
                      /* prefixIcon: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Icon(Icons.otp)),*/
                    ),
                    onTap: () async {
                      var date = await showDatePicker(
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                  primaryColor: Constants().mainColor,
                                  accentColor: Constants().mainColor,
                                  colorScheme: ColorScheme.light(
                                      primary: Constants().mainColor),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary)),
                              child: child,
                            );
                          },
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      _personalDetailsController.getDobController.text = DateFormat.yMMMMd().format(date);
                          date.toString().substring(0, 10);
                    },
                  ),
                ],
              ),
            )),
            SizedBox(
              height: 10,
            ),
            Obx(() => CommonTextInputWithTitle(
                  textInputAction: TextInputAction.next,
                  inputController: _personalDetailsController.getAdd1Controller,
                  title: "Address Line 1",
                  hint: "Enter Address Line 1",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  textInputAction: TextInputAction.next,
                  inputController: _personalDetailsController.getAdd2Controller,
                  title: "Address Line 2",
                  hint: "Enter Address Line 2",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  textInputAction: TextInputAction.next,
                  inputController: _personalDetailsController.getCityController,
                  title: "City",
                  hint: "Enter City Name",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  textInputAction: TextInputAction.next,
                  inputController:
                      _personalDetailsController.getStateController,
                  title: "State",
                  hint: "Enter State Name",
                )),
            SizedBox(height: 10,),
            Obx(() => CommonTextInputWithTitle(
                  textInputAction: TextInputAction.done,
                  inputController:
                      _personalDetailsController.getPincodeController,
                  title: "Pincode",
                  hint: "Pincode",
                  textInputType: TextInputType.phone,
                )),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Container(
                decoration: const BoxDecoration(
                  color: Color(0xff0F1B25),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CommonText(text: "Occupation Type"),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(left: 0, right: 20),
                    child: Row(
                      children: [
                        CommonText(text: 'Salaried', fontSize: 18),
                        Radio<SingingCharacter>(
                          activeColor: Constants().mainColor,
                          value: SingingCharacter.a,
                          groupValue:
                              _personalDetailsController.getOccupationType,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _personalDetailsController
                                  .occupationType.value = value;
                              _personalDetailsController.occupationType
                                  .refresh();
                            });
                          },
                        ),
                        CommonText(text: 'Business', fontSize: 18),
                        Radio<SingingCharacter>(
                          activeColor: Constants().mainColor,
                          value: SingingCharacter.b,
                          groupValue:
                              _personalDetailsController.getOccupationType,
                          onChanged: (SingingCharacter value) {
                            _personalDetailsController.occupationType.value =
                                value;
                            _personalDetailsController.occupationType
                                .refresh();
                            print(
                                _personalDetailsController.getOccupationType);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: InkWell(
                onTap: () {
                  _showPicker();

                }, //_personalDetailsController.getDocumentUrl
                child: Obx(() => _personalDetailsController.getFilePath == null && _personalDetailsController.getFilePath == ""
    ? _personalDetailsController.getDocumentUrl.isNotEmpty
                        ? Container(
                            width: 40,
                            height: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      _personalDetailsController.getDocumentUrl),
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
                        decoration: const BoxDecoration(
                          color: Color(0xff0F1B25),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Container(
                          width: 40,
                          height: 180,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                    File(_personalDetailsController.getFilePath)),
                                fit: BoxFit.fill),
                            border: Border.all(),
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.camera_alt,
                              size: 60, color: Colors.grey),
                        ),
                      )),
              ),
            ),
            SizedBox(
              height: 25,
            ),

            CommonButton(
              onPressed: () {
                print(_personalDetailsController.getFilePath);
                if(_personalDetailsController.getFilePath ==""){
                  UserDetailModel userDetailModel = UserDetailModel(
                      advisorName: _personalDetailsController.getNameController.text,
                      advisorAdd1: _personalDetailsController.getAdd1Controller.text,
                      advisorAdd2: _personalDetailsController.getAdd2Controller.text,
                      advisorCity: _personalDetailsController.getCityController.text,
                      advisorDob: _personalDetailsController.getDobController.text,
                      advisorEmail: _personalDetailsController.getEmailController.text,
                      advisorOccupation: _personalDetailsController.getOccupationType == SingingCharacter.a ?"Job":"Own",
                      advisorPhoneNumber: _personalDetailsController.getPhoneController.text,
                      advisorPincode: int.parse( _personalDetailsController.getPincodeController.text),
                      advisorState: _personalDetailsController.getStateController.text,
                      advisorUrl:_personalDetailsController.getDocumentUrl,
                      );
                  _personalDetailsController.updatePersonalDetails(userDetailModel);
                }else{
                  _personalDetailsController
                      .uploadFile(_personalDetailsController.getFilePath);
                }



              },
              buttonText: "Submit",
              vPadding: 15,
              buttonColor: Constants().appBarColor,
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
    _personalDetailsController.setFilePath(croppedFile.path);
  }
}
