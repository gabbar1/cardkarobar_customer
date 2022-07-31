import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upen/screen/dashBoard/models/bannerModel.dart';

class BannerService {
  Future<BannerModel> getBannerService() async {
    try {
      FirebaseFirestore.instance
          .collection("banners")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {


          Map<String, dynamic> bannerList = element.data();
          BannerModel bannerModel = BannerModel.fromJson(bannerList);

          return bannerModel;
        });

      });
    } catch (exception) {
      throw exception;
    }
  }
}
