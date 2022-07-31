
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upen/screen/helper/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../commonWidget/commonWidget.dart';
import '../partner/controller/partner_controller.dart';
import '../partner/model/leadModel.dart';
import '../partner/model/referModel.dart';

class WebLeadView extends StatefulWidget {
  WebLeadView({this.appliedBank, this.referModel});

  ReferModel referModel;
  String appliedBank;

  @override
  State<WebLeadView> createState() => _WebLeadViewState();
}

class _WebLeadViewState extends State<WebLeadView> {
  PartnerController _referController = Get.put(PartnerController());
  WebViewController controller ;

  bool isShow = false;
  String name,email,pinCode,phone;
  String newUrl;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.referModel.name),
        centerTitle: false,
        actions: [Center(child: CommonText(text: "₹ ${widget.referModel.price}")),SizedBox(width: 40,)],
      ),
        body:
        Stack(children: [
          WebView(
            initialUrl: widget.referModel.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController){
              controller = webViewController;
            },
            onPageFinished: (val){

              controller.evaluateJavascript("document.getElementsByClassName(\"logoarea\")[0].style.display='none';");
              controller.evaluateJavascript("document.getElementsByClassName(\"rightside\")[0].style.display='none';");
              controller.evaluateJavascript("document.getElementsByClassName(\"rightside\")[0].style.display='none';");
              controller.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
              setState(() {
                isShow=true;
              });

            },
            navigationDelegate: (request) async{

              if(request.url.contains("banksathi")){
                return NavigationDecision.navigate;
              }
              else{

                name = await controller.evaluateJavascript("document.getElementById('full_name').value");
                phone =await controller.evaluateJavascript("document.getElementById('mobile_no').value");
                email =await controller.evaluateJavascript("document.getElementById('email').value");
                pinCode =await controller.evaluateJavascript("document.getElementById('select2-pincode_id-container').title");
                LeadModel leadModel = LeadModel(status: "submitted",
                    customerEmail:email.replaceAll('"', ""),
                    customerName: name.replaceAll('"', ""),
                    customerPhone: int.parse(phone.replaceAll('"', "")),
                    product: widget.referModel.name,
                    referralId: int.parse(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")),
                    referralPrice: widget.referModel.price,
                    time: Timestamp.now(),
                    isEnabled: widget.referModel.isEnabled,
                    mode: "web"
                );
                newUrl = request.url;
                _referController.submitReferral(leadModel,newUrl).then((value) async{
                  Navigator.pop(context);
                  await launchUrl(Uri.parse(newUrl));

                });

                return NavigationDecision.prevent;
              }
            },
            //String data_from_webview =  await flutterWebviewPlugin.evalJavaScript("document.getElementById('#someElement').innerText");
          ),
          isShow ?SizedBox()  :Center(child: CircularProgressIndicator(color: Constants().mainColor,))
        ],)
    );
  }


}
