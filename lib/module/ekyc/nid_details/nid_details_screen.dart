import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/ekyc_core/mixins/nid_validation_mixin.dart';
import '../../../base/base_consumer_state.dart';
import '../../../common/toasts.dart';
import '../../../core/di/singleton_provider.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../../ui/custom_widgets/custom_common_inputfield_widget.dart';
import '../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../ui/custom_widgets/custom_safe_next_button.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/app_dimens.dart';
import '../../../utils/dimens/dimensions.dart';
import '../../../utils/styles.dart';
import '../additional_info/additional_info_screen.dart';
import '../api/geo_location/geo_loc_controller.dart';
import '../api/geo_location/model/district_model.dart';
import '../api/geo_location/model/division_model.dart';
import '../api/geo_location/model/thana_model.dart';
import '../ekyc_core/common_model/ekyc_infos.dart';
import '../ekyc_core/common_model/geo_loc_data.dart';
import '../ekyc_core/enums/nid_details_tag.dart';
import '/../utils/extensions/extension_text_style.dart';


/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

class NidDetailsScreen extends ConsumerStatefulWidget {
  const NidDetailsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NidDetailsScreen> createState() => _NidDetailsScreenState();
}

class _NidDetailsScreenState extends BaseConsumerState<NidDetailsScreen>
    with NidValidationMixin{
  final _nidFormKey = GlobalKey<FormState>();

  final nameBnController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final dobController = TextEditingController();
  final nomDobController = TextEditingController();
  final nidController = TextEditingController();
  final presentAddressController = TextEditingController();
  final percentageController = TextEditingController();

  List<DivisionModel> divisionListPresent = [];
  List<DistrictModel> districtListPresent = [];
  List<ThanaModel> thanaListPresent = [];

  List<DivisionModel> divisionListPermanent = [];
  List<DistrictModel> districtListPermanent = [];
  List<ThanaModel> thanaListPermanent = [];

  DivisionModel? _selectedDivisionPresent;
  DistrictModel? _selectedDistrictPresent;
  ThanaModel? _selectedThanaPresent;

  DivisionModel? _selectedDivisionPermanent;
  DistrictModel? _selectedDistrictPermanent;
  ThanaModel? _selectedThanaPermanent;

  dynamic nomDob;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(geoLocControllerProvider.notifier)
          .getDivision(NidDetailsTag.divDropPresent);
      ref
          .read(geoLocControllerProvider.notifier)
          .getDivision(NidDetailsTag.divDropPermanent);
    });
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener();
    final ekycInfo = ref.read(globalDataControllerProvider).ekycInfos;
    nameBnController.text =
        ref.read(globalDataControllerProvider).ekycInfos.applicantNameBen!;
    fatherNameController.text =
        ref.read(globalDataControllerProvider).ekycInfos.fatherName!;
    motherNameController.text =
        ref.read(globalDataControllerProvider).ekycInfos.motherName!;
    nidController.text =
        ref.read(globalDataControllerProvider).ekycInfos.nidNo!;

    const percentage = '100';

    percentageController.text = percentage;
    ekycInfo.nominee_percentage = percentage;

    final userDob = DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd')
        .parse(ref.read(globalDataControllerProvider).ekycInfos.dob!));
    dobController.text = userDob;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "nid_details"),
      body: Form(
        key: _nidFormKey,
        child: SingleChildScrollView(
          padding: AppDimen.scrollViewPaddingLTRB,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: DimenEdgeInset.marginTB_25_4,
                child: CustomCommonTextWidget(
                    text: "your_details".tr(),
                    style: CommonTextStyle.bold_14,
                    color: colorPrimaryText,
                    shouldShowMultipleLine: true),
              ),
              const Divider(
                color: Colors.grey,
                height: DimenSizes.dimen_12,
                thickness: DimenSizes.dimen_half,
                indent: DimenSizes.dimen_2,
                endIndent: DimenSizes.dimen_2,
              ),
              Padding(
                padding: DimenEdgeInset.marginTop_4,
                child: CustomCommonTextWidget(
                    text: "nid_details_sub".tr(),
                    style: CommonTextStyle.regular_12,
                    color: greyColor,
                    shouldShowMultipleLine: true),
              ),
              const Padding(
                padding: DimenEdgeInset.marginTop_16,
              ),
              NidTextForm(
                controller: nameBnController,
                label: 'name_bangla_nid'.tr(),
              ),
              NidTextForm(
                controller: fatherNameController,
                label: 'father_spouse_s_name'.tr(),
              ),
              NidTextForm(
                controller: motherNameController,
                label: 'mother_s_name'.tr(),
              ),
              NidTextForm(
                controller: dobController,
                label: 'dob'.tr(),
              ),
              NidTextForm(
                controller: nidController,
                label: 'nid_num'.tr(),
              ),
              NidTexField(
                label: 'permanent_address'.tr(),
                hint: 'enter_permanent_address'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.permAddress,
                validator: validateAddress,
              ),
              _divisionDropdown(NidDetailsTag.divDropPermanent),
              _districtDropdown(NidDetailsTag.disDropPermanent),
              _thanaDropdown(NidDetailsTag.thanaDropPermanent),
              NidTexField(
                label: 'post_office_permanent'.tr(),
                hint: 'e.g. Jigatola TSO',
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.postOfficePermanent,
                validator: validateBasicText,
              ),
              NidTexField(
                label: 'post_code_permanent'.tr(),
                hint: 'e.g. 1205',
                ekycInfo: ekycInfo,
                inputType: TextInputType.number,
                tag: NidDetailsTag.postCodePermanent,
                validator: validatePostCode,
                maxInput: 4,
              ),
              NidTexField(
                label: 'present_address'.tr(),
                hint: 'enter_present_address'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.presAddress,
                validator: validateAddress,
              ),
              _divisionDropdown(NidDetailsTag.divDropPresent),
              _districtDropdown(NidDetailsTag.disDropPresent),
              _thanaDropdown(NidDetailsTag.thanaDropPresent),
              NidTexField(
                label: 'post_office_present'.tr(),
                hint: 'e.g. Jigatola TSO',
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.postOfficePresent,
                validator: validateBasicText,
              ),
              NidTexField(
                label: 'post_code_present'.tr(),
                hint: 'e.g. 1205',
                ekycInfo: ekycInfo,
                inputType: TextInputType.number,
                tag: NidDetailsTag.postCodePresent,
                validator: validatePostCode,
                maxInput: 4,
              ),
              NidTexField(
                label: 'nominee_name'.tr(),
                hint: 'enter_nominee_name'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.nomName,
                validator: validateBasicText,
              ),
              NidTexField(
                label: 'nominee_nid_no'.tr(),
                hint: 'enter_nominee_nid_no'.tr(),
                ekycInfo: ekycInfo,
                inputType: TextInputType.number,
                tag: NidDetailsTag.nomNid,
                validator: validateNid,
              ),
              Padding(
                  padding: DimenEdgeInset.marginTB_8,
                  child: CustomCommonInputFieldWidget(
                    controller: nomDobController,
                    scrollPadding: AppDimen.textFieldScrollPadding,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      //ekycInfo.nominee_dob = value;
                    },
                    style: FontStyle.h1_14_bold(),
                    textCapitalization: TextCapitalization.none,
                    validator: validateBasicText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'nominee_dob'.tr(),
                      labelStyle: FontStyle.l_14_regular(),
                      hintText: 'date_pattern'.tr(),
                      hintStyle: FontStyle.l_12_regular(color: greyColor),
                    ),
                    onTap: () async {
                      log.info('nom dob clicked');

                      FocusScope.of(context).requestFocus(FocusNode());

                      await processNomDob(context, ekycInfo);
                    },
                    obscureText: false,
                  )),
              NidTexField(
                label: 'nominee_mobile_num'.tr(),
                hint: 'e.g 01xxxxxxxxx',
                ekycInfo: ekycInfo,
                inputType: TextInputType.number,
                tag: NidDetailsTag.nomMob,
                validator: validateMobileNo,
                maxInput: 11,
              ),
              NidTexField(
                label: 'relation_with_nominee'.tr(),
                hint: 'e.g mother',
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.nomRelation,
                validator: validateBasicText,
              ),
              NidTextForm(
                controller: percentageController,
                label: 'percentage'.tr(),
                isEnabled: false,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SafeNextButtonWidget(
          text: "next".tr(),
          onPressedFunction: () {
            if (_nidFormKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdditionalInfoScreen()),
              );
            } else {
              Toasts.showErrorToast("give_all_inputs".tr());
            }
          }),
    );
  }

  Future<void> processNomDob(BuildContext context, EkycInfos ekycInfo) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(1994),
      firstDate: DateTime(1923),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      looping: true,
    );

    if (datePicked == null) {
      log.info('null bro');
    } else {
      nomDob = datePicked;

      var outputFormatForView = DateFormat('dd/MM/yyyy');
      var outputFormatForServer = DateFormat('yyyy/MM/dd');

      var outputForView = outputFormatForView.format(nomDob);
      var outputForServer = outputFormatForServer.format(nomDob);

      ekycInfo.nominee_dob = outputForServer;
      nomDobController.text = outputForView;
      log.info('picked dob view -------> $outputForView');
      log.info('picked dob server -------> $outputForServer');
    }
  }

  void initAsyncListener() {
    ref.listen<AsyncValue>(
      geoLocControllerProvider,
      (previousState, currentState) async {
        if (currentState.isLoading || currentState.isRefreshing) {
          EasyLoading.show();
        } else if (currentState.hasError) {
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          log.info("success");

          final geoData = currentState.value as GeoLocData;

          if (geoData.divisionList != null &&
              geoData.tag == NidDetailsTag.divDropPresent) {
            setState(() {
              divisionListPresent = geoData.divisionList!.data!
                  .map((division) => DivisionModel(
                      id: division.id, divisionName: division.divisionName))
                  .toList();
            });
          } else if (geoData.divisionList != null &&
              geoData.tag == NidDetailsTag.divDropPermanent) {
            setState(() {
              divisionListPermanent = geoData.divisionList!.data!
                  .map((division) => DivisionModel(
                      id: division.id, divisionName: division.divisionName))
                  .toList();
            });
          } else if (geoData.districtList != null &&
              geoData.tag == NidDetailsTag.divDropPresent) {
            setState(() {
              districtListPresent = geoData.districtList!.data!
                  .map((district) => DistrictModel(
                        id: district.id,
                        divisionId: district.divisionId,
                        districtName: district.districtName,
                        remarks: district.remarks,
                        isActive: district.isActive,
                      ))
                  .toList();
            });
          } else if (geoData.districtList != null &&
              geoData.tag == NidDetailsTag.divDropPermanent) {
            setState(() {
              districtListPermanent = geoData.districtList!.data!
                  .map((district) => DistrictModel(
                        id: district.id,
                        divisionId: district.divisionId,
                        districtName: district.districtName,
                        remarks: district.remarks,
                        isActive: district.isActive,
                      ))
                  .toList();
            });
          } else if (geoData.upazilaList != null &&
              geoData.tag == NidDetailsTag.disDropPresent) {
            setState(() {
              thanaListPresent = geoData.upazilaList!.data!
                  .map((thana) => ThanaModel(
                      id: thana.id,
                      districtId: thana.districtId,
                      upazillaName: thana.upazillaName))
                  .toList();
            });
          } else if (geoData.upazilaList != null &&
              geoData.tag == NidDetailsTag.disDropPermanent) {
            setState(() {
              thanaListPermanent = geoData.upazilaList!.data!
                  .map((thana) => ThanaModel(
                      id: thana.id,
                      districtId: thana.districtId,
                      upazillaName: thana.upazillaName))
                  .toList();
            });
          }
        }
      },
    );
  }

  Widget _divisionDropdown(NidDetailsTag tag) {
    final dropdown = DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
          labelText: tag == NidDetailsTag.divDropPermanent ?'select_division_permanent'.tr() : "select_division_present".tr(),
     //   labelText: 'select_division'.tr(),
        labelStyle: FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (tag == NidDetailsTag.divDropPermanent) {
          if (value == null) {
            return 'submit_division_permanent'.tr();
          }
          return null;
        }  else{
        if (value == null) {
        return 'submit_division_present'.tr();
        }
        return null;
    }
  },
      items: _createDivisionList(tag),
      value: tag == NidDetailsTag.divDropPresent
          ? _selectedDivisionPresent
          : _selectedDivisionPermanent,
      onChanged: (DivisionModel? value) => setState(() {
        if (tag == NidDetailsTag.divDropPresent) {
          _selectedDivisionPresent = value ?? DivisionModel();
          ref.read(globalDataControllerProvider).ekycInfos.divisionPresent =
              _selectedDivisionPresent?.id;

          setState(() {
            _selectedDistrictPresent = null;
            _selectedThanaPresent = null;
          });

          ref
              .read(geoLocControllerProvider.notifier)
              .getDistrict(value!.id!, NidDetailsTag.divDropPresent);
        } else {
          _selectedDivisionPermanent = value ?? DivisionModel();
          ref.read(globalDataControllerProvider).ekycInfos.divisionPermanent =
              _selectedDivisionPermanent?.id;

          setState(() {
            _selectedDistrictPermanent = null;
            _selectedThanaPermanent = null;
          });

          ref
              .read(geoLocControllerProvider.notifier)
              .getDistrict(value!.id!, NidDetailsTag.divDropPermanent);
        }
      }),
    );

    if (tag == NidDetailsTag.divDropPresent) {
      return _createDivisionDropdownContainer(
        dropdown,
      );
    } else {
      return _createDivisionDropdownContainer(
        dropdown,
      );
    }
  }

  Widget _districtDropdown(NidDetailsTag tag) {
    final dropdown = DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
        labelText: tag == NidDetailsTag.disDropPermanent ?'select_district_permanent'.tr() : "select_district_present".tr(),
       // labelText: 'select_district'.tr(),
        labelStyle: FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (tag == NidDetailsTag.disDropPermanent) {
          if (value == null) {
            return 'submit_district_permanent'.tr();
          }
          return null;
        }  else{
          if (value == null) {
            return 'submit_district_present'.tr();
          }
          return null;
        }
      },
      items: _createDistrictList(tag),
      value: tag == NidDetailsTag.disDropPresent
          ? _selectedDistrictPresent
          : _selectedDistrictPermanent,
      onChanged: (DistrictModel? value) => setState(() {
        if (tag == NidDetailsTag.disDropPresent) {
          _selectedDistrictPresent = value ?? DistrictModel();
          ref.read(globalDataControllerProvider).ekycInfos.districtPresent =
              _selectedDistrictPresent?.id;
          _selectedThanaPresent = null;
          ref
              .read(geoLocControllerProvider.notifier)
              .getThana(value!.id!, NidDetailsTag.disDropPresent);
        } else {
          _selectedDistrictPermanent = value ?? DistrictModel();
          ref.read(globalDataControllerProvider).ekycInfos.districtPermanent =
              _selectedDistrictPermanent?.id;
          _selectedThanaPermanent = null;
          ref
              .read(geoLocControllerProvider.notifier)
              .getThana(value!.id!, NidDetailsTag.disDropPermanent);
        }
      }),
    );

    if (tag == NidDetailsTag.disDropPresent) {
      return _createDistrictDropdownContainer(
        dropdown,
      );
    } else {
      return _createDistrictDropdownContainer(
        dropdown,
      );
    }
  }

  Widget _thanaDropdown(NidDetailsTag tag) {
    final dropdown = DropdownButtonFormField(
      isExpanded: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
        //labelText: 'select_thana'.tr(),
        labelText: tag == NidDetailsTag.thanaDropPermanent ?'select_thana_permanent'.tr() : "select_thana_present".tr(),
        labelStyle: FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (tag == NidDetailsTag.thanaDropPermanent) {
          if (value == null) {
            return 'submit_thana_permanent'.tr();
          }
          return null;
        }  else{
          if (value == null) {
            return 'submit_thana_present'.tr();
          }
          return null;
        }
      },
      items: _createThanaList(tag),
      value: tag == NidDetailsTag.thanaDropPresent
          ? _selectedThanaPresent
          : _selectedThanaPermanent,
      onChanged: (ThanaModel? value) => setState(() {
        if (tag == NidDetailsTag.thanaDropPresent) {
          _selectedThanaPresent = value ?? ThanaModel();
          ref.read(globalDataControllerProvider).ekycInfos.thanaPresent =
              _selectedThanaPresent?.id;
        } else {
          _selectedThanaPermanent = value ?? ThanaModel();
          ref.read(globalDataControllerProvider).ekycInfos.thanaPermanent =
              _selectedThanaPermanent?.id;
        }
      }),
    );

    if (tag == NidDetailsTag.thanaDropPresent) {
      return _createThanaDropdownContainer(
        dropdown,
      );
    } else {
      return _createThanaDropdownContainer(
        dropdown,
      );
    }
  }

  List<DropdownMenuItem<DivisionModel>> _createDivisionList(NidDetailsTag tag) {
    if (tag == NidDetailsTag.divDropPresent) {
      return divisionListPresent
          .map<DropdownMenuItem<DivisionModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.divisionName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    } else {
      return divisionListPermanent
          .map<DropdownMenuItem<DivisionModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.divisionName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    }
  }

  List<DropdownMenuItem<DistrictModel>> _createDistrictList(NidDetailsTag tag) {
    if (tag == NidDetailsTag.disDropPresent) {
      return districtListPresent
          .map<DropdownMenuItem<DistrictModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.districtName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    } else {
      return districtListPermanent
          .map<DropdownMenuItem<DistrictModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.districtName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    }
  }

  List<DropdownMenuItem<ThanaModel>> _createThanaList(NidDetailsTag tag) {
    if (tag == NidDetailsTag.thanaDropPresent) {
      return thanaListPresent
          .map<DropdownMenuItem<ThanaModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.upazillaName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    } else {
      return thanaListPermanent
          .map<DropdownMenuItem<ThanaModel>>(
            (e) => DropdownMenuItem(
              value: e,
              child: CustomCommonTextWidget(
                  text: e.upazillaName ?? '',
                  style: CommonTextStyle.bold_14,
                  color: colorPrimaryText,
                  textAlign: TextAlign.center,
                  shouldShowMultipleLine: true),
            ),
          )
          .toList();
    }
  }
}

class NidTexField extends StatelessWidget {
  const NidTexField({
    super.key,
    required this.ekycInfo,
    required this.label,
    required this.hint,
    this.inputType,
    required this.tag,
    this.inputFormatters,
    this.validator,
    this.maxInput,
  });

  final EkycInfos ekycInfo;
  final String label;
  final String hint;
  final TextInputType? inputType;
  final NidDetailsTag tag;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxInput;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: DimenEdgeInset.marginTB_8,
        child: CustomCommonInputFieldWidget(
          obscureText: false,
          scrollPadding: AppDimen.textFieldScrollPadding,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: maxInput,
          onChanged: (value) {
            switch (tag) {
              case NidDetailsTag.presAddress:
                ekycInfo.pres_address = value;
                break;
              case NidDetailsTag.permAddress:
                ekycInfo.perm_address = value;
                break;
              case NidDetailsTag.postOfficePresent:
                ekycInfo.post_office_present = value;
                break;
              case NidDetailsTag.postCodePresent:
                ekycInfo.post_code_present = value;
                break;
              case NidDetailsTag.postOfficePermanent:
                ekycInfo.post_office_permanent = value;
                break;
              case NidDetailsTag.postCodePermanent:
                ekycInfo.post_code_permanent = value;
                break;
              case NidDetailsTag.nomName:
                ekycInfo.nominee = value;
                break;
              case NidDetailsTag.nomNid:
                ekycInfo.nominee_nid = value;
                break;
              case NidDetailsTag.nomDob:
                ekycInfo.nominee_dob = value;
                break;
              case NidDetailsTag.nomMob:
                ekycInfo.nominee_mobile = value;
                break;
              case NidDetailsTag.nomRelation:
                ekycInfo.nominee_relation = value;
                break;
              case NidDetailsTag.nomPercentage:
                ekycInfo.nominee_percentage = value;
                break;
              case NidDetailsTag.fatherName:
                ekycInfo.fatherName = value;
                break;
              case NidDetailsTag.motherName:
                ekycInfo.motherName = value;
                break;
              case NidDetailsTag.divDropPresent:
              case NidDetailsTag.divDropPermanent:
              case NidDetailsTag.disDropPresent:
              case NidDetailsTag.disDropPermanent:
              case NidDetailsTag.thanaDropPresent:
              case NidDetailsTag.thanaDropPermanent:
                break;
            }
          },
          style: FontStyle.h1_14_bold(),
          textCapitalization: TextCapitalization.none,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            labelStyle: FontStyle.l_14_regular(),
            hintText: hint,
            hintStyle: FontStyle.l_12_regular(color: greyColor),
          ),
        ));
  }
}

class NidTextForm extends StatefulWidget {
  const NidTextForm({
    super.key,
    required this.controller,
    required this.label,
    this.isEnabled = false,
  });

  final TextEditingController controller;
  final String label;
  final bool isEnabled;

  @override
  State<NidTextForm> createState() => _NidTextFormState();
}

class _NidTextFormState extends State<NidTextForm> with NidValidationMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DimenEdgeInset.marginTB_8,
      child: CustomCommonInputFieldWidget(
        obscureText: false,
        scrollPadding: const EdgeInsets.all(0),
        style: FontStyle.h1_14_bold(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: widget.isEnabled,
        controller: widget.controller,
        decoration: InputDecoration(
            labelStyle: FontStyle.l_14_regular(),
            labelText: widget.label,
            border: OutlineInputBorder(
              borderRadius: AppDimen.commonCircularBorderRadius,
              borderSide:
                  BorderSide(color: greyColor, width: DimenSizes.dimen_2),
            )),
        validator: validateBasicText,
      ),
    );
  }
}

Widget _createDivisionDropdownContainer(Widget dropdown) {
  return Padding(
    padding: DimenEdgeInset.marginTB_8,
    child: Column(
      children: [dropdown],
    ),
  );
}

Widget _createDistrictDropdownContainer(Widget dropdown) {
  return Padding(
    padding: DimenEdgeInset.marginTB_8,
    child: Column(
      children: [dropdown],
    ),
  );
}

Widget _createThanaDropdownContainer(Widget dropdown) {
  return Padding(
    padding: DimenEdgeInset.marginTB_8,
    child: Column(
      children: [
        dropdown,
      ],
    ),
  );
}
