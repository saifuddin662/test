import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/singleton_provider.dart';
import '../../../../base/base_consumer_state.dart';
import '../../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../../utils/dimens/dimensions.dart';
import '../../ekyc_core/cam_direction_provider.dart';
import '../../ekyc_core/camera_direction_type.dart';
import '../../ekyc_core/ekyc_constants.dart';
import '../back/nid_back_screen.dart';

class PreviewNidFront extends ConsumerStatefulWidget {
  final String imagePath;

  const PreviewNidFront({super.key, required this.imagePath});

  @override
  ConsumerState createState() => _PreviewNidFrontState();
}

class _PreviewNidFrontState extends BaseConsumerState<PreviewNidFront> {
  @override
  Widget build(BuildContext context) {
    storeImagePath();

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'nid_front'),

      body: showNid(),
    );
  }

  void storeImagePath() {
    final path = widget.imagePath;

    if (path.contains(EKycConstants.tagNidFront)) {
      ref.read(globalDataControllerProvider).capturedPhotos.nidFront = path;
      log.info(
          'front path saved --> ${ref.read(globalDataControllerProvider).capturedPhotos.nidFront}');
    }
  }

  // showing image as rotated, will rotate image later upon uploading
  Widget showNid() {
    final nextButton = SafeNextButtonWidget(
        text: "nid_back_pic_button".tr(),
        onPressedFunction: () {
          ref
              .watch(camDirectionProvider.notifier)
              .updateDirection(CamDirection.back);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NidBackScreen()),
          );
        });

    final retakeButton = SafeNextButtonWidget(
      text: "retake".tr(),
      onPressedFunction: () => {Navigator.pop(context)},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: DimenSizes.dimen_50),
        RotatedBox(
            quarterTurns: -1, // Pass -1 for 90o or -2 for 180o or -3 for 270o.
            child: Image.file(
              File(widget.imagePath),
            )),
        //const SizedBox(height: 10),
        Container(
            alignment: Alignment.center,
           // margin: const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 5.0),
            margin: DimenEdgeInset.marginTop_80,
            child: retakeButton),

        Container(
            alignment: Alignment.center,
            child: nextButton),
      ],
    );
  }
}
