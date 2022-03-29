import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/partner/controller/partner_controller.dart';
import 'package:upen/screen/profile/personalDetails/personalDetailController.dart';
import 'package:upen/screen/refer/refer_controller.dart';

class ReferView extends StatefulWidget {
  @override
  _ReferViewState createState() => _ReferViewState();
}

class _ReferViewState extends State<ReferView> {
  //old
  PersonalDetailsController _personalDetailsController =
      Get.put(PersonalDetailsController());
  PartnerController _PartnerController = Get.put(PartnerController());
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  //new
  ReferController referController = Get.put(ReferController());

  @override
  void initState() {
    // TODO: implement initState
    referController.getReferralUserList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          referralProgram(),
          Obx(()=>referController.getReferralList.length ==0? referPoster():
          Expanded(

            child: referralList(),))
        ],
      ),
    );
  }

  referralProgram() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(0xFF0F1B25),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(text: "Refer & Earn 10% Lifetime"),
                  SvgPicture.asset("assets/icons/refer.svg")
                ],
              ),
              CommonText(
                  text:
                      "Refer CardKarobar app to your friends or family and earn extra 10% of their earnings"),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: "Referral Code:"),
                          CommonText(
                              text: FirebaseAuth
                                  .instance.currentUser.phoneNumber
                                  .replaceAll("+91", "")),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){
                          Clipboard.setData(new ClipboardData(text: FirebaseAuth
                              .instance.currentUser.phoneNumber
                              .replaceAll("+91", "")));
                          Get.snackbar("Message", "Refer code copied");
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                //color: Constants,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: SvgPicture.asset("assets/icons/copy.svg")),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      share(FirebaseAuth
                          .instance.currentUser.phoneNumber
                          .replaceAll("+91", ""));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xFFD88BBC),
                                const Color(0xFF9361A8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.0, 2.0],
                              tileMode: TileMode.clamp),
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: CommonText(text: "REFER NOW"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share(String code) async {
    await FlutterShare.share(
        title: 'CardKarobar',
        text: 'Refer Cardkarobar to your friend and earn 10% of their income lifetime user code $code',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.cardkarobar.crm',
        chooserTitle: code
    );
  }
  referPoster() {
    return Column(
      children: [
        Image.asset("assets/icons/refer_logo.png"),
        CommonText(
            text: "Refer Now & Earn", fontStyle: FontWeight.bold, fontSize: 18),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: CommonText(
            textAlign: TextAlign.center,
            text:
                "Refer Cardkarobar Nnow to add member in your team and earn more",
          ),
        ),
      ],
    );
  }

  referralList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () {
          print("-------------checkRefresh");
          referController.getRefreshReferralUserList();
        },
        onLoading: () {
          print("-------------checkLoading");
            referController.getRefreshReferralUserList();
            _refreshController.loadComplete();

        },
        child: Obx(()=>ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: referController.getReferralList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Color(0xFF0F1B25),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Row(
                      //    mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Constants().appBackGroundColor,
                            child: CachedNetworkImage(

                              imageBuilder: (context, imageProvider) => Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => SvgPicture.asset("assets/icons/profile.svg",color: Constants().mainColor,),
                              imageUrl: referController.getReferralList[index].advisorUrl,
                            ),
                          ) ,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    referController
                                        .getReferralList[index]
                                        .advisorName
                                        .capitalizeFirst,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  CommonText(
                                      text: referController
                                          .getReferralList[index]
                                          .advisorPhoneNumber,
                                      textColor: Colors.white54,
                                      fontSize: 15)
                                ],
                              ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))),
                                child: CommonText(
                                    text: referController
                                        .getReferralList[index]
                                        .current_wallet=="null" ?"₹ 0":"₹ ${referController
                                        .getReferralList[index]
                                        .current_wallet}"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              );
            })),
      ),
    );
  }
}
