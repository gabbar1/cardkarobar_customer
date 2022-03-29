import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/partner/controller/partner_controller.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailController.dart';

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


  @override
  void initState() {
    // TODO: implement initState
    _PartnerController.myLeads();
    super.initState();
  }

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
              hint: "Enter customer phone number",
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onChange: (val){
                print("===============onChange======");
                print(val);
                if(val.toString().length==10){
                  _PartnerController.mySearchLeads(int.parse(val));
                }else if(val.toString().isEmpty){
                  _PartnerController.myLeads();
                }
              }
            ),),
            Expanded(child: Obx(() => _PartnerController.getLeadList.isEmpty
                ? Center(
              child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Constants().mainColor),
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: () {
                  print("-------------checkRefresh");
                  _PartnerController.myRefreshLeads();
                },
                onLoading: () {
                  print("-------------checkLoading");
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
                                              .width /
                                              4,
                                          child: Text(
                                            _PartnerController
                                                .getLeadList[index]
                                                .customerName
                                                .capitalizeFirst,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            CommonText(
                                                text: _PartnerController
                                                    .getLeadList[index]
                                                    .product,
                                                textColor: Colors.white,
                                                fontSize: 15),
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
                                              child: Icon(Icons.phone)),
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
                                            null
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
        floatingActionButton: _personalDetailsController.getIsAdmin
            ? FloatingActionButton(
                onPressed: () {
                  _PartnerController.uploadData();
                },
                backgroundColor: Constants().inactiveColor,
                child: SvgPicture.asset("assets/icons/add.svg"),
              )
            : SizedBox());
  }
}
