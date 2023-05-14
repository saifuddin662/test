import 'dart:convert';


class AppEncoderDecoderUtility {
  String base64Encoder(String text) {
    String credentials = text;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    return encoded;
  }
}