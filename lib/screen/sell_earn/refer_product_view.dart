import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:upen/commonWidget/commonWidget.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:upen/screen/partner/controller/partner_controller.dart';
import 'refer_info_view.dart';

class ReferPartnerView extends StatefulWidget {
  String videoID;
  String category;
  ReferPartnerView({this.videoID,this.category});
  @override
  _ReferPartnerViewState createState() => _ReferPartnerViewState();
}

class _ReferPartnerViewState extends State<ReferPartnerView> {
  PartnerController _PartnerController = Get.put(PartnerController());
  @override
  void initState() {
    // TODO: implement initState
    _PartnerController.referralPartners(false,widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text("Partners"),
        centerTitle: true,
      ),
      body: Obx(() => _PartnerController.getReferList.isEmpty ? Center(
        child: CircularProgressIndicator(
          valueColor:
          new AlwaysStoppedAnimation<Color>(Constants().mainColor),
        ),
      ):Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: _PartnerController.getReferList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(ReferInfoView(referModel: _PartnerController.getReferList[index],));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xFF0F1B25),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Row(
                         // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          CachedNetworkImage(

                            imageUrl:  _PartnerController.getReferList[index].banner,

                            imageBuilder: (context, imageProvider) => Container(
                              width: 150.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) => Container(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => SvgPicture.asset("assets/icons/profile.svg",color: Constants().mainColor,),
                          ),
                          SizedBox(width: 20,),
                          Center(
                       //     padding:  EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                CommonText(
                                  text: _PartnerController.getReferList[index].name.capitalize,
                                  fontSize: 20
                                ),
                                SizedBox(height: 5,),
                                SizedBox(
                                 // height: 100,
                                  width: MediaQuery.of(context).size.width/2.5,
                                  child: CommonText(
                                    text:!_PartnerController.getReferList[index].isFixedPrice?
                                    "Refer to your customers and friends, and earn ${_PartnerController.getReferList[index].pricePercentage.toString()} % of total amount":
                                    "Refer to your customers and friends, and earn ₹ ${_PartnerController.getReferList[index].price.toString()}"
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],),
                      ),
                    ),
                  );
                  return InkWell(
                    onTap: () {
                      Get.to(ReferInfoView(referModel: _PartnerController.getReferList[index],));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: MediaQuery.of(context).size.height/5,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                                imageUrl:
                                    _PartnerController.getReferList[index].banner),
                          ),
                          Positioned(
                              right: 20,
                              top: 20,
                              child: CommonText(
                                  text: "Earn " +
                                      _PartnerController.getReferList[index].price
                                          .toString(),
                                  fontStyle: FontWeight.w500,
                                  fontSize: 18))
                        ],
                      ),
                    ),
                  );
                }),
          )),
    );
  }
}
