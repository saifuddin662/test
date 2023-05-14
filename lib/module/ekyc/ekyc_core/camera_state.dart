import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

@immutable
class CameraState extends Equatable {
  final CameraController? controller;
  final XFile? file;

  const CameraState({
    this.controller,
    this.file,
  });

  CameraState copyWith(
      {CameraController? controller, XFile? file}) {
    return CameraState(
      controller: controller ?? this.controller,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [controller, file];
}
