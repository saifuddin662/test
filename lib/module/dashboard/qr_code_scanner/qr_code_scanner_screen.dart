import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/flavor/flavor_provider.dart';
import '../../../ui/configs/branding_data_controller.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import '../../cash_out/cash_out_enter_amount_screen.dart';
import '../../send_money/send_money_enter_amount_screen.dart';
import 'api/qr_code_scanner_controller.dart';


class QrCodeScannerScreen extends ConsumerStatefulWidget {
  const QrCodeScannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends BaseConsumerState<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: CustomCommonTextWidget(
             text: 'camera_permission_required'.tr(),
             style: CommonTextStyle.regular_14,
             color: colorPrimaryText ,
      ),),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    ref.listen<AsyncValue>(
      qrCodeScannerControllerProvider,
          (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
          Toasts.showErrorToast("${currentState.error}");
        } else {
          EasyLoading.dismiss();
          if(currentState.value.accountStatus == "ACTIVE") {
            if(ref.read(flavorProvider).name == "CUSTOMER") {
              switch(currentState.value.userType) {
                case "CUSTOMER":
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SendMoneyEnterAmountScreen(
                                userName: currentState.value.name,
                                walletNumber: currentState.value.walletNo,
                              )
                      )
                  );
                  break;
                case "AGENT":
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CashOutEnterAmountScreen(
                                agentName: currentState.value.name,
                                agentNumber: currentState.value.walletNo,
                              )
                      )
                  );
                  break;
              }
            }
          }
          else {
            Toasts.showErrorToast("invalid_account_type".tr());
          }
        }
      },
    );

    var scanArea = (
        MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: "scan_qr"),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: BrandingDataController.instance.branding.colors.primaryColor,
            borderRadius: DimenSizes.dimen_10,
            borderLength: DimenSizes.dimen_30,
            borderWidth: DimenSizes.dimen_10,
            cutOutSize: scanArea
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      )
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      _onQRScanned(scanData.code);
    });
  }

  void _onQRScanned(String? data) {
    ref.read(qrCodeScannerControllerProvider.notifier).getQrCodeDetails("$data");
    controller?.pauseCamera();
    Future.delayed(const Duration(seconds: 3), () {
      controller?.resumeCamera();
    });
  }
}

