
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:upen/commonWidget/loader.dart';
import 'package:upen/screen/dashBoard/models/productModel.dart';

import 'models/bannerModel.dart';
import 'service/cardkarobar.dart';

class DashBoardController extends GetxController{

  var banners = <BannerModel>[].obs;
  List<BannerModel> get getBanners => banners.value;
  var isHide = false.obs;
  bool get getIsHide => isHide.value;

  var productList = <ProductModel>[].obs;
  List<ProductModel> get getProducts=> productList.value;

  setIsHide(bool val){
    isHide.value = val;
  }

  setBannerList(BannerModel bannerModel){

    this.banners.add(bannerModel);

  }

  Future<void> getBannerList()async{
    banners.value.clear();
    getBanners.clear();
      try {

        FirebaseFirestore.instance
            .collection("banners")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((element) {

            Map<String, dynamic> bannerList = element.data();
            BannerModel bannerModel = BannerModel.fromJson(bannerList);
            setBannerList(bannerModel);
          });
        });
      } catch (exception) {
        throw exception;
      }
    }

  Future<void> getProductList()async{
    productList.value.clear();
    try {

      FirebaseFirestore.instance
          .collection("products")
          .get()
          .then((QuerySnapshot querySnapshot) {

        querySnapshot.docs.forEach((element) {

          ProductModel _productModel = ProductModel(id:element.id,steps: element["steps"] );

          setProductList(_productModel);
        });
      });
    } catch (exception) {
      throw exception;
    }
  }

  setProductList(ProductModel val){
    productList.value.add(val);
    productList.refresh();
  }


}