import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_attendance/utils/image_src.dart';

class MapServices {
  static Future<Uint8List> getMarkerImage(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(imageIcon);
    return byteData.buffer.asUint8List();
  }

  static Future<Uint8List> getMarkerWithSize(
    int width,
    int height,
    String image,
  ) async {
    ByteData data = await rootBundle.load(image);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Uint8List> getMarkerWithSize1(int width) async {
    ByteData data = await rootBundle.load(mapMarker);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 110, targetHeight: 140);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Uint8List> getMarkerWithSize2(int width) async {
    ByteData data = await rootBundle.load("assets/images/b.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
