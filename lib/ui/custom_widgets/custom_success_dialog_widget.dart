import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../module/dashboard/dashboard_screen.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/styles.dart';
import '../configs/branding_data_controller.dart';
import 'custom_common_text_widget.dart';

class CustomSuccessDialogWidget extends StatefulWidget {
  const CustomSuccessDialogWidget({Key? key}) : super(key: key);

  @override
  State<CustomSuccessDialogWidget> createState() => _CustomSuccessDialogWidgetState();
}

class _CustomSuccessDialogWidgetState extends State<CustomSuccessDialogWidget> {
  FutureBuilder getWidget(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 5000)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_10)),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(DimenSizes.dimen_12, DimenSizes.dimen_40, DimenSizes.dimen_12, DimenSizes.dimen_0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_12, DimenSizes.dimen_8, DimenSizes.dimen_4, DimenSizes.dimen_24),
                                              child: CustomCommonTextWidget(
                                                    text: "send_money".tr(),
                                                    style: CommonTextStyle.regular_18,
                                                    color: BrandingDataController.instance.branding.colors.primaryColor ,
                                                  ),
                                                ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_8, DimenSizes.dimen_12, DimenSizes.dimen_24),
                                                child: CustomCommonTextWidget(
                                                      text: "successful".tr(),
                                                      style: CommonTextStyle.bold_18,
                                                      color: BrandingDataController.instance.branding.colors.primaryColor ,
                                                    ),

                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_18, DimenSizes.dimen_12, DimenSizes.dimen_12, DimenSizes.dimen_24),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children:  [
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_2, DimenSizes.dimen_0, DimenSizes.dimen_2),
                                                    child: CustomCommonTextWidget(
                                                        text: "Md Solaiman",
                                                        style: CommonTextStyle.regular_14,
                                                        color: colorPrimaryText,
                                                        textAlign :  TextAlign.start,
                                                        shouldShowMultipleLine : true
                                                    ),


                                                  )
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children:  [
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_2, DimenSizes.dimen_0, DimenSizes.dimen_2),
                                                    child: CustomCommonTextWidget(
                                                        text: "01833184117",
                                                        style: CommonTextStyle.regular_14,
                                                        color: colorPrimaryText,
                                                        textAlign :  TextAlign.start,
                                                        shouldShowMultipleLine : true
                                                    ),

                                                  )
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              width: double.infinity,
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_12, DimenSizes.dimen_0, DimenSizes.dimen_12),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children: [
                                            CustomCommonTextWidget(
                                              text:  'Time',
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            CustomCommonTextWidget(
                                              text:  '08:33am 08/06/22',
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Container(
                                    color: Colors.black12,
                                    width: DimenSizes.dimen_1,
                                    height: DimenSizes.dimen_50,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children:  [
                                            CustomCommonTextWidget(
                                              text:  'transaction_id'.tr(),
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),

                                            const SizedBox(height: DimenSizes.dimen_4),

                                            CustomCommonTextWidget(
                                              text:  '57GVSHASF67',
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              width: double.infinity,
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_12, DimenSizes.dimen_0, DimenSizes.dimen_12),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children:  [
                                            CustomCommonTextWidget(
                                              text:  'total'.tr(),
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                            const SizedBox(height: DimenSizes.dimen_4),

                                            CustomCommonTextWidget(
                                              text:  '৳505.00',
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Container(
                                    color: Colors.black12,
                                    width: DimenSizes.dimen_1,
                                    height: DimenSizes.dimen_50,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children: [
                                            CustomCommonTextWidget(
                                              text:  'new_balance'.tr(),
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),

                                            const SizedBox(height: DimenSizes.dimen_4),

                                            CustomCommonTextWidget(
                                              text:  '৳6995.25',
                                              style: CommonTextStyle.regular_14,
                                              color: colorPrimaryText,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              width: double.infinity,
                              height: DimenSizes.dimen_1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_12, DimenSizes.dimen_0, DimenSizes.dimen_12),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children:  [
                                            const Text('reference').tr(),
                                            const SizedBox(height: DimenSizes.dimen_4),
                                            const Text('N/A')
                                          ],
                                        ),
                                      )
                                  ),
                                  Container(
                                    color: Colors.black12,
                                    width: DimenSizes.dimen_1,
                                    height: DimenSizes.dimen_50,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(DimenSizes.dimen_8),
                                        child: Column(
                                          children: const [
                                            Text(' '),
                                            SizedBox(height: DimenSizes.dimen_4),
                                            Text('')
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.black12,
                              width: double.infinity,
                              height: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Lottie.asset('assets/lottie_files/lottie_successful.json',
                                    height: DimenSizes.dimen_120,
                                    width: DimenSizes.dimen_120
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                  Container(
                    color: BrandingDataController.instance.branding.colors.primaryColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(DimenSizes.dimen_12),
                        child: Row(
                          children:  [
                            Expanded(
                                child: CustomCommonTextWidget(
                              text:  "back_to_home".tr(),
                              style: CommonTextStyle.regular_14,
                              color: Colors.white,
                            ),),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: DimenSizes.dimen_30,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(DimenSizes.dimen_10)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie_files/lottie_processing.json', height: DimenSizes.dimen_120, width: DimenSizes.dimen_120),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(DimenSizes.dimen_0, DimenSizes.dimen_8, DimenSizes.dimen_4, DimenSizes.dimen_4),
                      child: const Text("processing").tr(),
                    )
                  ],
                ),
              ),
            );
          } // Return empty container to avoid build errors
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getWidget(context),
    );
  }
}
