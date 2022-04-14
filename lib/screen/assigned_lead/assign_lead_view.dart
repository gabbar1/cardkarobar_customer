
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upen/screen/assigned_lead/assign_lead_controller.dart';
import 'package:upen/screen/assigned_lead/status_update.dart';
import 'package:upen/screen/helper/constant.dart';

import '../../commonWidget/commonWidget.dart';
import 'lead_type.dart';

class AssignLeadView extends StatefulWidget {
  @override
  _AssignLeadViewState createState() => _AssignLeadViewState();
}

class _AssignLeadViewState extends State<AssignLeadView> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  AssignLeadController _assignLeadController = Get.put(AssignLeadController());
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final RefreshController _refreshHistoryController = RefreshController(
    initialRefresh: false,
  );

  String leadType = "UnderProcess";
  @override
  void initState() {
    // TODO: implement initState
    _assignLeadController.latestLead(leadType);
    //_assignLeadController.historyLead();
    super.initState();
  }
TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title:  Text("${leadType} Lead"),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: CommonTextInput1(
                inputController: _controller,
                  hint: "Enter customer phone number",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChange: (val) {

                     if (val.toString().isEmpty) {
                    _assignLeadController.latestLead("UnderProcess");
                    //_assignLeadController.historyLead();
                    }
                     else{

                         try{
                           var phone = int.parse(val);
                           if(val.length==10){
                             _assignLeadController.searchLead(int.parse(val));
                           }
                         }catch(e){
                           _debouncer.call(() {
                             _assignLeadController.searchLeadByName(val);
                           });
                         }

                     }

                  }),
            ),
                    Expanded(
                child: Obx(() {
                  if (_assignLeadController.getNewLeadList.isEmpty && _assignLeadController.getNewLeadList.toString() != '[]') {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Constants().mainColor),
                      ),
                    );
                  }
                  if (_assignLeadController.getNewLeadList.toString() == '[]' &&
                      _assignLeadController.getNewLeadList.length == 0) {
                    return Center(child: Text("No Data Found",style: TextStyle(color: Colors.white,fontSize: 18),));
                  }
                  if (_assignLeadController.getNewLeadList != null)
                    return Padding(
                    padding:
                    const EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      controller: _refreshController,
                      onRefresh: () {

                        _assignLeadController.refreshLatestLead(leadType);
                      },
                      onLoading: () async {

                        var refresh =
                        await _assignLeadController.refreshLatestLead(leadType);

                        _refreshController.loadComplete();
                      },
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                          _assignLeadController.getNewLeadList.length,
                          //shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _assignLeadController.referralDetails(_assignLeadController
                                    .getNewLeadList[index].referralId.toString());
                                Get.to(StatusUpdate(
                                  referModel: _assignLeadController
                                      .getNewLeadList[index],
                                  leadType: leadType,
                                ));
                              },
                              child: Card(
                                color: Colors.white,
                                child: SizedBox(
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CommonText(
                                                text: "Customer Name",
                                                textColor: Colors.black),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              //  height: 10,
                                              child: Text(
                                                _assignLeadController
                                                    .getNewLeadList[index]
                                                    .customerName,
                                                style:
                                                TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            CommonText(
                                                text: "Product Name",
                                                textColor: Colors.black),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            CommonText(
                                                text: _assignLeadController
                                                    .getNewLeadList[index]
                                                    .product,
                                                textColor: Colors.black,
                                                fontSize: 20),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50.0, right: 5),
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
                                                      Radius.circular(
                                                          5))),
                                              child: CommonText(
                                                  text:
                                                  _assignLeadController
                                                      .getNewLeadList[
                                                  index]
                                                      .status)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                })),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constants().appBackGroundColor,
          child: SvgPicture.asset("assets/icons/floating.svg"),
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
        ),
      ),
    );
  }

//"Login","UnderProcess","Rejected","Declined","Approved"
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

                _assignLeadController.latestLead(leadType);
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
                          _assignLeadController.latestLead(leadType);
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
