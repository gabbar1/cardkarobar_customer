

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../commonWidget/commonWidget.dart';

Widget histicon(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          indicatorColor: Color(0xff684e88),
          tabs: [
            Tab(text: "Latest"),
            Tab(text: "History"),
          ],
        ),
        title: const Text('Notification'),
      ),
      body: TabBarView(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              // Obx(
              //   () => _personalDetailsController.getDocumentUrl.isBlank
              //       ? Center(
              //           child: CircularProgressIndicator(
              //             valueColor: new AlwaysStoppedAnimation<Color>(
              //                 Constants().mainColor),
              //           ),
              //         )
              //       :
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: CommonTextInput1(
                  hint: "Enter email to get help",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),

              // ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // Obx(() => _personalDetailsController
              //           .getNameController.text.isEmpty
              //       ? Center(
              //     child: CircularProgressIndicator(
              //       valueColor: new AlwaysStoppedAnimation<Color>(
              //           Constants().mainColor),
              //     ),
              //   )
              //       :
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Container(
                  color: Color(0xff0F1B25),
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.greenAccent,
                        height: 80,
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 8),
                        child: Container(child: Icon(Icons.check_circle,color:Colors.greenAccent),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 5,),
                                Text("Payment Successful.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Text(
                                    "For more information tap on the icon twice....",
                                    style: TextStyle(
                                      fontSize: 15, color: Colors.white24,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Card(
                  color: Color(0xff0F1B25),
                  shadowColor: Colors.black,

                  child:Container(


                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.yellowAccent,
                        height: 80,
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 8),
                        child: Container(child: Icon(Icons.sim_card_alert,color:Colors.yellowAccent),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 5,),
                                Text("Pending.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,

                                    )),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Text(
                                    "Wait till it gets completed.",
                                    style: TextStyle(
                                      fontSize: 15, color: Colors.black54,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Container(
                  color: Colors.white,
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: 80,
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 8),
                        child: Container(child: Icon(Icons.clear,color:Colors.redAccent),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 5,),
                                Text("Failed.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,

                                    )),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Text(
                                    "Please Try again.",
                                    style: TextStyle(
                                      fontSize: 15, color: Colors.black54,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

