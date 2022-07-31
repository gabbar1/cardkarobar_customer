import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendNotification({String token, title, message}) async{

  final postUrl = 'https://fcm.googleapis.com/fcm/send';



  final data = {
    "notification": {"body":message, "title":title},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "sound": 'default',
      "screen": "yourTopicName",
    },
    "to": token};

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=AAAAlDBU6qA:APA91bF2TMrtiqHPgCjkO5SmQpGypG9zFbV5V_uv093mx85uOQH9xgjg8LrHX_azPvSwCP_mALkDvQmCDNZpS9xSALJQprKp2gFVaT9i0OUQvc0s75U_U-e8WjISJSdgqhTM9Z8BW8Ot'

  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
// on success do


  } else {
// on failure do


  }
}

