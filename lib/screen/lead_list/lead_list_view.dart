import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/partner/controller/partner_controller.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailController.dart';

import '../assigned_lead/lead_type.dart';

class LeadListView extends StatefulWidget {
  bool isHide;

  LeadListView({this.isHide});

  @override
  _LeadListViewState createState() => _LeadListViewState();
}

class _LeadListViewState extends State<LeadListView> {
  PartnerController _PartnerController = Get.put(PartnerController());
  PersonalDetailsController _personalDetailsController =
      Get.put(PersonalDetailsController());
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String leadType = "UnderProcess";

  @override
  void initState() {
    // TODO: implement initState
    _PartnerController.myLeads();
    super.initState();
  }
TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isHide
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text("My Work"),
                centerTitle: true,
              ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(left: 10,right: 10),child:  CommonTextInput1(
              inputController: _controller,
              hint: "Search Customer by mobile or Name",

              textInputAction: TextInputAction.done,
              onChange: (val){

                if (val.toString().isEmpty) {
                  _PartnerController.myLeads();
                  //_assignLeadController.historyLead();
                }
                else{
                  try{
                    var phone = int.parse(val);
                    if(val.length==10){
                      _PartnerController.mySearchLeads(int.parse(val));
                    }
                  }catch(e){
                    _debouncer.call(() {
                      _PartnerController.searchLeadByName(val);
                    });
                  }

                }
              }
            ),),
            Expanded(child: Obx(() => _PartnerController.getLeadList.isEmpty
                ? Center(child: Text("No Data Found",style: TextStyle(color: Colors.white,fontSize: 18),))
                : Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: () {

                  _PartnerController.myRefreshLeads();
                },
                onLoading: () {

                  _PartnerController.myRefreshLeads().then((value) {
                    _refreshController.loadComplete();
                  });
                },
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _PartnerController.getLeadList.length,
                    //shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xFF0F1B25),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /2,
                                          child: CommonText(text: "${_PartnerController
                                              .getLeadList[index]
                                              .customerName.capitalize}  ( ${_PartnerController
                                              .getLeadList[index].selfLead ==null ? "Self-Lead":_PartnerController
                                              .getLeadList[index].selfLead} )",
                                            fontSize: 16,
                                            fontStyle: FontWeight.bold,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CommonText(text:"Lead at : ${DateFormat().format(_PartnerController
                                            .getLeadList[index].time.toDate())}" ),
                                        Row(
                                          children: [
                                            CommonText(
                                                text: _PartnerController
                                                    .getLeadList[index]
                                                    .product,
                                                textColor: Colors.white,
                                                fontSize: 12),
                                            _PartnerController
                                                .getLeadList[index]
                                                .type==null ?SizedBox():  CommonText(
                                                text: " (" +
                                                    _PartnerController
                                                        .getLeadList[index]
                                                        .type +
                                                    ")",
                                                textColor: Colors.white,
                                                fontSize: 15),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        _PartnerController
                                            .getLeadList[index]
                                            .assignedTo==null?SizedBox(): InkWell(
                                          onTap: (){

                                            FlutterPhoneDirectCaller.callNumber(
                                                _PartnerController
                                                    .getLeadList[index]
                                                    .assignedTo);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                  bottom: 5,
                                                  top: 5),
                                              decoration: BoxDecoration(
                                                  color: Constants()
                                                      .mainColor
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(5))),
                                              child: Icon(Icons.phone,color: Colors.white,)),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                bottom: 5,
                                                top: 5),
                                            decoration: BoxDecoration(
                                                color: Constants()
                                                    .mainColor
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: CommonText(
                                                text: _PartnerController
                                                    .getLeadList[index]
                                                    .status)),
                                        SizedBox(height: 5,),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                bottom: 5,
                                                top: 5),
                                            decoration: BoxDecoration(
                                                color: Constants()
                                                    .mainColor
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: CommonText(
                                                text: "₹ ${_PartnerController
                                                    .getLeadList[index]
                                                    .referralPrice.toString()}")),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    // height:30,
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 10, top: 10),
                                    decoration: BoxDecoration(
                                        color: Constants().appBackGroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child:
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context)
                                          .size
                                          .width /
                                          4,
                                      child: Text(
                                        _PartnerController
                                            .getLeadList[
                                        index]
                                            .adminComment ==
                                            null|| _PartnerController
                                            .getLeadList[
                                        index]
                                            .adminComment.isEmpty
                                            ? "No Comment"
                                            : _PartnerController
                                            .getLeadList[
                                        index]
                                            .adminComment,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.clear();
            showModalBottomSheet(
                backgroundColor: Constants().appBackGroundColor,
                //isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                context: context,
                builder: (builder) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: leadTypePopup());
                });
          },
          backgroundColor: Constants().inactiveColor,
          child: SvgPicture.asset("assets/icons/floating.svg"),
        ));
  }

  List<LeadType> leadTypeList = <LeadType>[
    LeadType(
      status: true,
      type: "UnderProcess",
    ),
    LeadType(
      status: false,
      type: "Login",
    ),
    LeadType(
      status: false,
      type: "Pending",
    ),
    LeadType(
      status: false,
      type: "Rejected",
    ),
    LeadType(
      status: false,
      type: "Declined",
    ),
    LeadType(
      status: false,
      type: "Approved",
    ),
  ];

  leadTypePopup() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: leadTypeList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              leadTypeList.forEach((element) {
                element.status = false;
              });

              Navigator.pop(context);
              setState(() {
                leadType = leadTypeList[index].type;
                leadTypeList[index].status = !leadTypeList[index].status;

                _PartnerController.latestLead(leadType);
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(text: leadTypeList[index].type),
                  Checkbox(
                      activeColor: Constants().mainColor,
                      value: leadTypeList[index].status,
                      onChanged: (val) {
                        leadTypeList.forEach((element) {
                          element.status = false;
                        });

                        setState(() {
                          leadTypeList[index].status = val;
                          leadType = leadTypeList[index].type;
                          _PartnerController.latestLead(leadType);
                        });
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }
}
