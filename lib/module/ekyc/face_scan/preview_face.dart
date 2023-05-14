import 'dart:io';
import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/singleton_provider.dart';
import '../../../../common/toasts.dart';
import '../../../base/base_consumer_state.dart';
import '../../../core/di/core_providers.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../dashboard/dashboard_screen.dart';
import '../api/verify_ekyc/model/verify_ekyc_response.dart';
import '../api/verify_ekyc/verify_ekyc_controller.dart';
import '../ekyc_core/ekyc_constants.dart';
import '../ekyc_core/ekyc_status_type.dart';
import '../pending/ekyc_pending_screen.dart';

class PreviewFace extends ConsumerStatefulWidget {
  final String imagePath;

  const PreviewFace({super.key, required this.imagePath});

  @override
  ConsumerState createState() => _PreviewFaceState();
}

class _PreviewFaceState extends BaseConsumerState<PreviewFace> {
  void storeImagePath() {
    final path = widget.imagePath;

    if (path.contains(EKycConstants.tagFace)) {
      ref.read(globalDataControllerProvider).capturedPhotos.face = path;
      log.info(
          'face path saved --> ${ref.read(globalDataControllerProvider).capturedPhotos.face}');
    }
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    storeImagePath();

    return Scaffold(
      //  appBar: const CustomCommonAppBarWidget(appBarTitle: 'Preview Face'),
      body: showFace(),
    );
  }

  Widget showFace() {
    final nextButton = SafeNextButtonWidget(
        text: "next".tr(),
        onPressedFunction: () async {
          log.info("next clicked");
          EasyLoading.show();
          ref.read(verifyEkycControllerProvider.notifier).verifyEkyc();
        });

    final retakeButton = SafeNextButtonWidget(
      text: "retake".tr(),
      onPressedFunction: () => {Navigator.pop(context)},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              margin: AppDimen.faceImageMarginLTRB,
              child: Image.file(
                File(widget.imagePath),
              )),
        ),
        const SizedBox(height: DimenSizes.dimen_10),
        Container(alignment: Alignment.center, child: retakeButton),
        // const SizedBox(height: 10),
        Container(alignment: Alignment.center, child: nextButton),
      ],
    );
  }

  void initAsyncListener(BuildContext context) {
    ref.listen<AsyncValue>(
      verifyEkycControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          //EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info(
              "------------------------------------------------> ekyc success");

          final VerifyEkycResponse ekycResponse =
              currentState.value as VerifyEkycResponse;
          final String ekycState =
              ref.read(globalDataControllerProvider).ekycState;

          Toasts.showSuccessToast(ekycResponse.message);

          if (ekycState == EkycStatus.PARTIAL.name) {

            ref.read(localPrefProvider).setBool(PrefKeys.keyIsUserLoggedIn, true);

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
              return const DashboardScreen();
            }), (r) {
              return false;
            });
          } else {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const EkycPendingScreen();
            }), (r) {
              return false;
            });
          }
        }
      },
    );
  }
}
