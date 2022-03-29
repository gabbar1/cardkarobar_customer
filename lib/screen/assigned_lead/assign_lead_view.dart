import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upen/screen/assigned_lead/assign_lead_controller.dart';
import 'package:upen/screen/assigned_lead/status_update.dart';
import 'package:upen/screen/helper/constant.dart';

import '../../commonWidget/commonWidget.dart';

class AssignLeadView extends StatefulWidget {
  @override
  _AssignLeadViewState createState() => _AssignLeadViewState();
}

class _AssignLeadViewState extends State<AssignLeadView> {
  AssignLeadController _assignLeadController = Get.put(AssignLeadController());
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final RefreshController _refreshHistoryController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    // TODO: implement initState
    _assignLeadController.latestLead();
    _assignLeadController.historyLead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Color(0xff684e88),
            tabs: [
              Tab(text: "New"),
              Tab(text: "History"),
            ],
          ),
          title: const Text('Assigned Lead'),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10,right: 10),child:  CommonTextInput1(
                    hint: "Enter customer phone number",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChange: (val){
                      print("===============onChange======");
                      print(val);
                      if(val.toString().length==10){
                        _assignLeadController.searchLead(int.parse(val));
                      }else if(val.toString().isEmpty){
                        _assignLeadController.latestLead();
                        _assignLeadController.historyLead();
                      }
                    }
                ),),
               Expanded(child:  Obx(() => _assignLeadController.getNewLeadList.isEmpty
                   ? Center(
                 child: CircularProgressIndicator(
                   valueColor: new AlwaysStoppedAnimation<Color>(
                       Constants().mainColor),
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
                     _assignLeadController.refreshLatestLead();
                   },
                   onLoading: () async{
                     print("-------------checkLoading");
                     var refresh=  await _assignLeadController.refreshLatestLead();

                     _refreshController.loadComplete();

                   },
                   child: ListView.builder(
                       physics: const BouncingScrollPhysics(),
                       itemCount: _assignLeadController.getNewLeadList.length,
                       //shrinkWrap: true,
                       itemBuilder: (context, index) {
                         return InkWell(
                           onTap: (){
                             Get.to(StatusUpdate(referModel: _assignLeadController.getNewLeadList[index],));
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
                                             _assignLeadController.getNewLeadList[index]
                                                 .customerName,

                                             style: TextStyle(fontSize: 15),
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
                                             text: _assignLeadController.getNewLeadList[index].product,
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
                                               borderRadius: BorderRadius.all(
                                                   Radius.circular(5))),
                                           child: CommonText(
                                               text: _assignLeadController.getNewLeadList[index]
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
               ))),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10,right: 10),child:  CommonTextInput1(
                    hint: "Enter customer phone number",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChange: (val){
                      print("===============onChange======");
                      print(val);
                      if(val.toString().length==10){
                        _assignLeadController.searchLead(int.parse(val));
                      }else if(val.toString().isEmpty){
                        _assignLeadController.latestLead();
                        _assignLeadController.historyLead();
                      }
                    }
                ),),
                Expanded(child: Obx(() => _assignLeadController.getHistoryLeadList.isEmpty
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Constants().mainColor),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: _refreshHistoryController,
                    onRefresh: () {
                      print("-------------checkRefresh");
                      _assignLeadController.refreshHistoryLead();
                    },
                    onLoading: () {
                      print("-------------checkLoading");
                      _assignLeadController.refreshHistoryLead();
                      _refreshHistoryController.loadComplete();

                    },
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _assignLeadController.getHistoryLeadList.length,
                        //shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              print(_assignLeadController.getHistoryLeadList[index].product);
                              Get.to(StatusUpdate(referModel: _assignLeadController.getHistoryLeadList[index],));
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
                                              child: Text(
                                                _assignLeadController.getHistoryLeadList[index]
                                                    .customerName,
                                                style: TextStyle(fontSize: 15),
                                              )),
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
                                              text: _assignLeadController.getHistoryLeadList[index].product,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: CommonText(
                                                text: _assignLeadController.getHistoryLeadList[index]
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
                )),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
