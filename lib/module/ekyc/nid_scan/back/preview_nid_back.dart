import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/singleton_provider.dart';
import '../../../../base/base_consumer_state.dart';
import '../../../../common/toasts.dart';
import '../../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../../utils/dimens/dimensions.dart';
import '../../api/upload_nid/model/upload_nid_reponse.dart';
import '../../api/upload_nid/upload_nid_controller.dart';
import '../../ekyc_core/common_model/ekyc_infos.dart';
import '../../ekyc_core/ekyc_constants.dart';
import '../../ekyc_core/ekyc_status_type.dart';
import '../../ekyc_home/ekyc_home_screen.dart';
import '../../nid_details/nid_details_screen.dart';

class PreviewNidBack extends ConsumerStatefulWidget {
  final String imagePath;

  const PreviewNidBack({super.key, required this.imagePath});

  @override
  ConsumerState createState() => _PreviewNidBackState();
}

class _PreviewNidBackState extends BaseConsumerState<PreviewNidBack> {
  void storeImagePath() {
    final path = widget.imagePath;

    if (path.contains(EKycConstants.tagNidBack)) {
      ref.read(globalDataControllerProvider).capturedPhotos.nidBack = path;
      log.info('back path saved --> ${ref.read(globalDataControllerProvider).capturedPhotos.nidBack}');
    }
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener(context);

    storeImagePath();

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'nid_back'),
      body: showNid(),
    );
  }

  Widget showNid() {
    final nextButton = SafeNextButtonWidget(
        text: "next".tr(),
        onPressedFunction: () async {
          log.info("next clicked");
          EasyLoading.show();
          ref.read(uploadNidControllerProvider.notifier).uploadNid();
        });

    final retakeButton = SafeNextButtonWidget(
      text: "retake".tr(),
      onPressedFunction: () => {
        Navigator.pop(context)
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: DimenSizes.dimen_50),
        RotatedBox( // showing image as rotated, will rotate image later upon uploading
            quarterTurns: -1, // Pass -1 for 90o or -2 for 180o or -3 for 270o.
            child: Image.file(
              File(widget.imagePath),
            )),
       // const SizedBox(height: 10),
        Container(
            alignment: Alignment.center,
            margin: DimenEdgeInset.marginTop_80,
            child: retakeButton),

        Container(
            alignment: Alignment.center,
            child: nextButton),
      ],
    );
  }

  void initAsyncListener(BuildContext context) {
    ref.listen<AsyncValue>(
      uploadNidControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          //EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          log.info("upload success");

          final uploadResponse = currentState.value as UploadNidResponse;

          final ekycInfo = ref.read(globalDataControllerProvider).ekycInfos;
          final partialNidNo = ref.read(globalDataControllerProvider).walletData.nid;
          final String ekycState = ref.read(globalDataControllerProvider).ekycState;

          storeNidResponse(ekycInfo, uploadResponse);

          if (ekycState == EkycStatus.PARTIAL.name) {
            if (partialNidNo == ekycInfo.nidNo) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NidDetailsScreen()),
              );
            } else {
              Toasts.showErrorToast("Invalid NID! Please try with valid NID");

              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const EkycHomeScreen();
              }), (r) {
                return false;
              });
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NidDetailsScreen()),
            );
          }
        }
      },
    );
  }

  void storeNidResponse(EkycInfos ekycInfo, UploadNidResponse uploadResponse) {
    ekycInfo.ocrRequestUuid = uploadResponse.data?.ocrRequestUuid;
    ekycInfo.nidNo = uploadResponse.data?.nidNo;
    ekycInfo.dob = uploadResponse.data?.dob;
    ekycInfo.applicantNameBen = uploadResponse.data?.applicantNameBen;
    ekycInfo.applicantNameEng = uploadResponse.data?.applicantNameEng;
    ekycInfo.fatherName = uploadResponse.data?.fatherName;
    ekycInfo.motherName = uploadResponse.data?.motherName;
    ekycInfo.spouseName = uploadResponse.data?.spouseName;
    ekycInfo.address = uploadResponse.data?.address;
    ekycInfo.idFrontName = uploadResponse.data?.idFrontName;
    ekycInfo.idBackName = uploadResponse.data?.idBackName;
    ekycInfo.ocrRequestUuid = uploadResponse.data?.ocrRequestUuid;
  }
}
