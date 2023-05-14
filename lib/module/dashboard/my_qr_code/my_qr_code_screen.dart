import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shimmer/shimmer.dart';
import '../../../base/base_consumer_state.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/pref_keys.dart';
import '../../../utils/styles.dart';
import 'api/model/my_qr_code_request.dart';
import 'my_qr_code_controller.dart';


class MyQrCodeScreen extends ConsumerStatefulWidget {
  const MyQrCodeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyQrCodeScreen> createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends BaseConsumerState<MyQrCodeScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyQrCodeRequest myQrCodeRequest = MyQrCodeRequest(
          walletNo: ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn),
          walletType: ref.read(flavorProvider).name
      );
      ref.read(myQrCodeControllerProvider.notifier).getMyQrCode(myQrCodeRequest);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final qrCodeData = ref.watch(myQrCodeControllerProvider);

    final userName = ref.read(localPrefProvider).getString(PrefKeys.keyUserName);
    final walletNo = ref.read(localPrefProvider).getString(PrefKeys.keyMsisdn);

    final decodeString = qrCodeData.value?.qrCode.toString();
    final encodedBytes = decodeString.toString().replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'my_qr_code'),
      body: Container(
          color: BrandingDataController.instance.branding.colors.primaryColorLight,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.fromLTRB(DimenSizes.dimen_20, DimenSizes.dimen_80, DimenSizes.dimen_20, DimenSizes.dimen_150),
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(DimenSizes.dimen_10))
            ),
            child: Container(
              padding: const EdgeInsets.all(DimenSizes.dimen_10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: DimenSizes.dimen_20),
                  CustomCommonTextWidget(text: "$userName",
                      style: CommonTextStyle.semiBold_16
                  ),
                  CustomCommonTextWidget(text: "$walletNo",
                    style: CommonTextStyle.bold_20,
                    color: BrandingDataController.instance.branding.colors.primaryColor
                  ),
                  Expanded(
                    child: qrCodeData.isLoading == false ?
                    Container(
                      margin: const EdgeInsets.all(DimenSizes.dimen_10),
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: MemoryImage(base64Decode(encodedBytes)),
                          fit: BoxFit.scaleDown,
                        ),
                        shape: QrScannerOverlayShape(
                          borderColor: BrandingDataController.instance.branding.colors.primaryColor,
                          borderLength: DimenSizes.dimen_20,
                          borderWidth: DimenSizes.dimen_10,
                          overlayColor: Colors.white,
                        ),
                      ),
                    ) : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.all(DimenSizes.dimen_10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DimenSizes.dimen_8),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

