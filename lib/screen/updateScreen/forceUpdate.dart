import 'package:flutter/material.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/service/authservice.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../commonWidget/commonWidget.dart';


class ForceUpdateView extends StatelessWidget {
  String updateRequired;
  String forceUpdate;
  String maintenance;

  ForceUpdateView(this.updateRequired, this.forceUpdate, this.maintenance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
        Navigator.pop(context);
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (maintenance == "0")
                      ? Image.asset("assets/images/img_force_update.png")
                      : Image.asset("assets/images/img_force_update.png"),
                  SizedBox(
                    height: 15,
                  ),
                  CommonText(text: (maintenance == "0")
                      ? "Time To Update !"
                      : "Under Maintenance",fontSize: 21),

                  SizedBox(
                    height: 15,
                  ),
                  CommonText(
                   text: (maintenance == "0")
                        ? "We have added lots of new features and improved our existing app to make your experience better and smooth as possible."
                        : "We appreciate your patience for our maintenance work. We will be back soon.\nRegards,\FinsEarn Team.",
                    textAlign: TextAlign.center,
                    fontSize: 15
                  ),
                  (maintenance == "0")
                      ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {

                          launch("https://play.google.com/store/apps/details?id=com.cardkarobar.crm");
                         // OpenAppstore.launch(androidAppId: "com.facebook.katana&hl=ko", iOSAppId: "284882215")
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                              color: Constants().mainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Update Now",
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (forceUpdate == "0")
                          ? GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AuthService().handleAuth()),
                                  (route) => false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                color: Constants().mainColor, fontSize: 15.0),
                          ),
                        ),
                      )
                          : Container()
                    ],
                  )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



