import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:upen/screen/assigned_lead/assign_lead_controller.dart';

import '../../commonWidget/commonWidget.dart';
import '../../commonWidget/loader.dart';
import '../helper/constant.dart';
import '../partner/model/leadModel.dart';
import '../partner/model/referModel.dart';
import '../profile/personalDetails/personalDetailController.dart';

class StatusUpdate extends StatefulWidget {
  StatusUpdate({this.appliedBank, this.referModel});

  LeadModel referModel;
  String appliedBank;

  @override
  _StatusUpdateState createState() => _StatusUpdateState();
}

class _StatusUpdateState extends State<StatusUpdate> {
  String _type = "--Assign Type--";

  assignData() {

    nameController.text = widget.referModel.customerName;
    phoneController.text = widget.referModel.customerPhone.toString();
    emailController.text = widget.referModel.customerEmail;
    stateController.text = widget.referModel.customerState;
    cityController.text = widget.referModel.customerCity;
    salaryController.text = widget.referModel.customerSalary;
    businessController.text = widget.referModel.customerItr;
    leadBankController.text = widget.referModel.product;
    cardLimitController.text = widget.referModel.customerCardLimit;
    commentController.text = widget.referModel.adminComment;
    customerCommentController.text = widget.referModel.comment;
    customerLeadTypeController.text = widget.referModel.type;
    itrTypeController.text = widget.referModel.customerItr;
    isFixedPriceController.text = widget.referModel.desireAmount;
    applicationNumberController.text = widget.referModel.applicationNumber;
    // leadBankController.text = widget.referModel.comment;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController c2cController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController customerCommentController = TextEditingController();
  TextEditingController leadBankController = TextEditingController();
  TextEditingController customerLeadTypeController = TextEditingController();
  TextEditingController itrTypeController = TextEditingController();
  TextEditingController cardLimitController = TextEditingController();

  TextEditingController isFixedPriceController = TextEditingController();
  TextEditingController applicationNumberController = TextEditingController();
  AssignLeadController _assignLeadController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    clearText();
    assignData();
    super.initState();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    stateController.clear();
    cityController.clear();
    leadBankController.clear();
    itrTypeController.clear();
    salaryController.clear();
    c2cController.clear();
    cardLimitController.clear();
    customerLeadTypeController.clear();
    commentController.clear();
    customerCommentController.clear();
    isFixedPriceController.clear();
    applicationNumberController.clear();
  }

  String assignleadStatus = "--Assign Type--";
  String existinglist;

  @override
  Widget build(BuildContext context) {
    print("==========widget.referModel.type=============");
    print(widget.referModel.type);

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Status"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Constants().appBackGroundColor,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0))),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                CommonTextInputWithTitle(
                    title: "Customer Name",
                isReadOnly: true,
                labeltext: "Name",
                hint: "Enter Customer Name",
                inputController: nameController),
                SizedBox(
                  height: 10,
                ),
                CommonTextInputWithTitle(
                    title: "Customer Email",
                    isReadOnly: true,
                    labeltext: "Enter Customer Email",
                    hint: "Enter Customer Email",
                    inputController: emailController),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    CommonTextInputWithTitle(
                      title: "Customer Mobile",
                      isReadOnly: true,
                      hint: "Enter Customer Mobile",
                      inputController: phoneController,),
                    Positioned(right: 5,child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                          left: 50.0, right: 5),
                      child: IconButton(
                          onPressed: () {
                            FlutterPhoneDirectCaller.callNumber(
                                phoneController.text);
                          },
                          icon: CircleAvatar(
                              backgroundColor: Constants()
                                  .mainColor
                                  .withOpacity(0.4),
                              child: Icon(
                                Icons.call,
                                color: Constants().mainColor,
                                size: 20,
                              ))),
                    ),)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextInputWithTitle(
                    title: "Customer State",
                    isReadOnly: true,
                    hint: "Enter Customer State",
                    inputController: stateController),
                SizedBox(
                  height: 10,
                ),
                CommonTextInputWithTitle(
                    title: "Customer City",
                    isReadOnly: true,
                    hint: "Enter Customer City",
                    inputController: cityController),
                SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 10,
                ),
                if (widget.referModel.type == "Credit Card") ...[
                  CommonTextInputWithTitle(
                      title: "Applied Bank",
                      hint: "Enter Applied Bank",
                      isReadOnly: true,
                      inputController: leadBankController),
                  if (widget.referModel.customerLeadType == "Business") ...[
                    CommonTextInputWithTitle(
                        title: "Customer ITR",
                        hint: "Enter Customer ITR",
                        isReadOnly: true,
                        inputController: itrTypeController)
                  ] else if (widget.referModel.customerLeadType ==
                      "Salary") ...[
                    CommonTextInputWithTitle(
                        title: "Customer Salary",
                        hint: "Enter Customer Salary",
                        isReadOnly: true,
                        inputController: salaryController)
                  ] else if (widget.referModel.customerLeadType == "c2c") ...[
                    CommonTextInputWithTitle(
                        title: "Customer Credit Card",
                        hint: "Enter Customer Credit Card",
                        isReadOnly: true,
                        inputController: c2cController),
                    CommonTextInputWithTitle(
                        title: "Customer Credit Card Limit",
                        hint: "Enter Customer Credit Card Limit",
                        isReadOnly: true,
                        inputController: cardLimitController),
                  ]
                ] else if (widget.referModel.type == "Loans") ...[
                  CommonTextInputWithTitle(
                      title: "Customer Lead Type",
                      hint: "Enter Customer Lead Type",
                      isReadOnly: true,
                      inputController: customerLeadTypeController),
                  if (widget.referModel.customerLeadType == "Business") ...[
                    CommonTextInputWithTitle(
                        title: "Customer ITR",
                        hint: "Enter Customer ITR",
                        isReadOnly: true,
                        inputController: itrTypeController)
                  ] else if (widget.referModel.customerLeadType ==
                      "Salary") ...[
                    CommonTextInputWithTitle(
                        title: "Customer Salary",
                        hint: "Enter Customer Salary",
                        isReadOnly: true,
                        inputController: salaryController)
                  ]
                ] /*else if (widget.referModel.type == "Home Loan") ...[
                  CommonTextInputWithTitle(
                      title: "Customer Lead Type",
                      hint: "Enter Customer Lead Type",
                      isReadOnly: true,
                      inputController: customerLeadTypeController),
                  if (widget.referModel.customerLeadType == "Business") ...[
                    CommonTextInputWithTitle(
                        title: "Customer ITR",
                        hint: "Enter Customer ITR",
                        isReadOnly: true,
                        inputController: itrTypeController)
                  ] else if (widget.referModel.customerLeadType ==
                      "Salary") ...[
                    CommonTextInputWithTitle(
                        title: "Customer Salary",
                        hint: "Enter Customer Salary",
                        isReadOnly: true,
                        inputController: salaryController)
                  ]
                ]*/,
                SizedBox(height: 10,),
                CommonTextInputWithTitle(
                  isReadOnly: true,
                    title: "Customer Comment",

                    minLines: 5,
                    inputController: customerCommentController,
                    hint: "Customer Comment",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name),
                SizedBox(height: 10,),
                CommonTextInputWithTitle(
                  title: "Enter Comment",

                    minLines: 5,
                    inputController: commentController,
                    hint: "Enter any Comment",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name),
                SizedBox(
                  height: 15,
                ),
               if (widget.referModel.isFixedPrice!=null &&!widget.referModel.isFixedPrice ) ...[
                CommonTextInputWithTitle(
                  isReadOnly: false,
                  title:"Customer Required Amount",
                  hint:"Enter Customer Required Amount Here",
                  inputController: isFixedPriceController,
                ),],

                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  value: assignleadStatus,
                  dropdownColor: Constants().appBackGroundColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // labelText: "Existing Bank",
                  ),
                  items: <String>[
                    '--Assign Type--',
                    'Login',
                    'Rejected',
                    'Pending',
                  ].map((String value) {
                    setState(() {
                      existinglist = value;
                    });
                    return DropdownMenuItem<String>(
                      onTap: () {
                        setState(() {
                          _type= value;
                        });
                      },
                      value: existinglist,
                      child: CommonText(
                          text: existinglist, textColor: Colors.white),
                    );
                  }).toList(),
                  validator: (value) {
                    print("-----------ValidatedOr not------------");
                    print(value);
                    if (value == null) {
                      return 'Field required';
                    }
                    return null;
                  },
                  onChanged: (val) {},
                ),
                SizedBox(
                  height: 20,
                ),
                if(_type =='Login' || applicationNumberController.text.isNotEmpty)...[
                  CommonTextInputWithTitle(
                    isReadOnly: false,
                    title:"Application Number",
                    hint:"Enter Customer Application Number Here",
                    inputController: applicationNumberController,
                  ),
                ],
                SizedBox(height: 20,),
                CommonButton(
                    buttonText: "Submit",
                    buttonTextColor: Colors.black,
                    vPadding: 20,
                    buttonColor: Constants().mainColor,
                    onPressed: () {
                      // nameController
                      if (_type == '--Assign Type--') {
                        Get.snackbar(
                            "Alert", "Assign type should not be Empty");
                      } else if (widget.referModel.isFixedPrice!=null &&!widget.referModel.isFixedPrice && isFixedPriceController.text.isEmpty) {
                        print(isFixedPriceController.text.isEmpty);
                        print(widget.referModel.isFixedPrice );
                        Get.snackbar(
                            "Alert", "Amount should not be Empty");
                      } else if (_type =='Login' &&applicationNumberController.text.isEmpty){
                        Get.snackbar(
                            "Alert", "Please Enter Application number before login");
                      }
                      else {
                        if(widget.referModel.isFixedPrice!=null &&!widget.referModel.isFixedPrice){
                          widget.referModel.referralPrice = (int.parse(isFixedPriceController.text) *double.parse(widget.referModel.percentage)/100).toInt();
                        }
                        LeadModel _leadModel = widget.referModel;
                        _leadModel.status=_type;
                        _leadModel.adminComment = commentController.text;
                        _leadModel.comment = customerCommentController.text;
                        _leadModel.desireAmount = isFixedPriceController.text;
                        _leadModel.applicationNumber = applicationNumberController.text;
                        _leadModel.isLeadClosed = _type =='Rejected'?true :widget.referModel.isLeadClosed;
                        _assignLeadController.assignLead(_leadModel);
                        Get.snackbar(
                            "Alert", "  Status Updated.");
                      }
                    }
                    ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
