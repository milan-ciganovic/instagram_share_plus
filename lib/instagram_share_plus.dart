import 'dart:async';

import 'package:flutter/services.dart';

class InstagramSharePlus {
  static const MethodChannel _channel = MethodChannel('instagram_share_plus');

  static Future<String?> shareInstagram({String? path, String? type}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': path,
      'type': type,
    };
    final String? status =
        await _channel.invokeMethod('shareVideoToInstagram', params);
    return status;
  }
}
