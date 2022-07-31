import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screen/partner/controller/partner_controller.dart';
import '../screen/partner/model/leadModel.dart';
import '../screen/partner/model/referModel.dart';
import 'commonWidget.dart';

class WebViewUtility extends StatefulWidget {

  ReferModel referModel;
  WebViewUtility({this.referModel});
  @override
  _WebViewUtilityState createState() => _WebViewUtilityState();
}

class _WebViewUtilityState extends State<WebViewUtility> {
  PartnerController _referController = Get.put(PartnerController());
  bool isLoading = false;
  WebViewController controller ;
  String name,email,pinCode,phone;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.referModel.name),
        centerTitle: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            WebView(
              initialUrl: "https://swiftserve.us/legal/privacy_policy.html",
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (value) {

              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading ? Center(child: CircularProgressIndicator()) : SizedBox()
          ],
        ),
      ),
    );
  }
}
