import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../ekyc_core/mixins/nid_validation_mixin.dart';
import '/../utils/extensions/extension_text_style.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,February,2023.

class PartialInfoScreen extends ConsumerStatefulWidget {
  const PartialInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PartialInfoScreen> createState() => _PartialInfoScreenState();
}

class _PartialInfoScreenState extends BaseConsumerState<PartialInfoScreen>
    with NidValidationMixin {
  final _nidFormKey = GlobalKey<FormState>();

  final nameBnController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final dobController = TextEditingController();
  final nomDobController = TextEditingController();
  final nidController = TextEditingController();
  final presentAddressController = TextEditingController();
  final percentageController = TextEditingController();

  List<DivisionModel> divisionList = [];
  List<DistrictModel> districtList = [];
  List<ThanaModel> thanaList = [];

  DivisionModel? _selectedDivision;
  DistrictModel? _selectedDistrict;
  ThanaModel? _selectedThana;
  dynamic nomDob;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //--> ref.read(geoLocControllerProvider.notifier).getDivision();
    });
  }

  @override
  Widget build(BuildContext context) {
    initAsyncListener();

    final walletInfo = ref.watch(globalDataControllerProvider).walletData;
    final ekycInfo = ref.read(globalDataControllerProvider).ekycInfos;

    nameBnController.text = walletInfo.fullName!;

    nidController.text = walletInfo.nid!;
    const percentage = '100';

    percentageController.text = percentage;
    ekycInfo.nominee_percentage = percentage;

    final userDob = DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(walletInfo.dob!));
    dobController.text = userDob;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomCommonAppBarWidget(appBarTitle: "user_details"),
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
                child:  Text(
                  "your_details",
                  style: FontStyle.h1_14_bold(),
                ).tr(),
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
                child:  Text(
                  "nid_details_sub",
                  style: FontStyle.l_12_regular(color: greyColor),
                ).tr(),
              ),
              const Padding(
                padding: DimenEdgeInset.marginTop_16,
              ),
              NidTextForm(
                controller: nameBnController,
                label: 'name_bangla_nid'.tr(),
                isEnabled: false,
              ),

              NidTexField(
                label: 'father_spouse_s_name'.tr(),
                hint: 'eg_father_name'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.fatherName,
                validator: validateBasicText,
              ),

              NidTexField(
                label: 'mother_s_name'.tr(),
                hint: 'eg_mother_name'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.motherName,
                validator: validateBasicText,
              ),

              NidTextForm(
                controller: dobController,
                label: 'dob'.tr(),
                isEnabled: false,
              ),


              NidTextForm(
                controller: nidController,
                label: 'nid_num'.tr(),
                isEnabled: false,
              ),

              NidTexField(
                label: 'permanent_address'.tr(),
                hint: 'enter_permanent_address'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.permAddress,
                validator: validateAddress,
              ),

              NidTexField(
                label: 'present_address'.tr(),
                hint: 'enter_present_address'.tr(),
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.presAddress,
                validator: validateAddress,
              ),

              _divisionDropdown(),
              _districtDropdown(),
              _thanaDropdown(),

              NidTexField(
                label: 'post_office'.tr(),
                hint: 'e.g. Jigatola TSO',
                ekycInfo: ekycInfo,
                tag: NidDetailsTag.postOfficePresent,
                validator: validateBasicText,
              ),

              NidTexField(
                label: 'post_code'.tr(),
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
                padding:  DimenEdgeInset.marginTB_8,
                child:   CustomCommonInputFieldWidget(
                  obscureText: false,
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
                    labelStyle: FontStyle.l_14_regular(),
                    labelText: 'nominee_dob'.tr(),
                    hintText: 'date_pattern'.tr(),
                    hintStyle: FontStyle.l_12_regular(color: greyColor),
                  ),
                  onTap: () async {
                    log.info('nom dob clicked');

                    FocusScope.of(context).requestFocus(FocusNode());

                    await processNomDob(context, ekycInfo);
                  },
                ),

              ),
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
              // NidTexField(
              //   label: 'Percentage',
              //   hint: '100%',
              //   ekycInfo: ekycInfo,
              //   inputType: TextInputType.number,
              //   tag: NidDetailsTag.nomPercentage,
              //   validator: validateBasicNumber,
              // ),
            ],
          ),
        ),
      ),
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

          if (geoData.divisionList != null) {
            setState(() {
              divisionList = geoData.divisionList!.data!
                  .map((division) => DivisionModel(
                      id: division.id, divisionName: division.divisionName))
                  .toList();
            });
          } else if (geoData.districtList != null) {
            setState(() {
              districtList = geoData.districtList!.data!
                  .map((district) => DistrictModel(
                        id: district.id,
                        divisionId: district.divisionId,
                        districtName: district.districtName,
                        remarks: district.remarks,
                        isActive: district.isActive,
                      ))
                  .toList();
            });
          } else if (geoData.upazilaList != null) {
            setState(() {
              thanaList = geoData.upazilaList!.data!
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

  Widget _divisionDropdown() {
    final dropdown = DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
        labelText: 'select_division'.tr(),
        labelStyle:  FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (value == null) {
          return 'submit_division'.tr();
        }
        return null;
      },
      items: _createDivisionList(),
      value: _selectedDivision,
      onChanged: (DivisionModel? value) => setState(() {
        _selectedDivision = value ?? DivisionModel();
        ref.read(globalDataControllerProvider).ekycInfos.divisionPresent =
            _selectedDivision?.id;

        setState(() {
          _selectedDistrict = null;
          _selectedThana = null;
        });

        //---> ref.read(geoLocControllerProvider.notifier).getDistrict(value!.id!);
      }),
    );
    return _createDivisionDropdownContainer(
      dropdown,
      "Division",
      _selectedDivision,
    );
  }

  Widget _districtDropdown() {
    final dropdown = DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
        labelText: 'select_district'.tr(),
        labelStyle: FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (value == null) {
          return 'submit_district'.tr();
        }
        return null;
      },
      items: _createDistrictList(),
      value: _selectedDistrict,
      onChanged: (DistrictModel? value) => setState(() {
        _selectedDistrict = value ?? DistrictModel();
        ref.read(globalDataControllerProvider).ekycInfos.districtPresent =
            _selectedDistrict?.id;
        _selectedThana = null;
        //--> ref.read(geoLocControllerProvider.notifier).getThana(value!.id!);
      }),
    );
    return _createDistrictDropdownContainer(
      dropdown,
      "District",
      _selectedDistrict,
    );
  }

  Widget _thanaDropdown() {
    final dropdown = DropdownButtonFormField(
      isExpanded: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DimenSizes.dimen_10,
          vertical: DimenSizes.dimen_16,
        ),
        labelText: 'select_thana'.tr(),
        labelStyle:  FontStyle.l_14_regular(),
      ),
      style: FontStyle.h1_14_bold(),
      validator: (value) {
        if (value == null) {
          return 'submit_thana'.tr();
        }
        return null;
      },
      items: _createThanaList(),
      value: _selectedThana,
      onChanged: (ThanaModel? value) => setState(() {
        _selectedThana = value ?? ThanaModel();
        ref.read(globalDataControllerProvider).ekycInfos.thanaPresent =
            _selectedThana?.id;
      }),
    );
    return _createThanaDropdownContainer(
      dropdown,
      "Thana",
      _selectedThana,
    );
  }

  List<DropdownMenuItem<DivisionModel>> _createDivisionList() {
    return divisionList
        .map<DropdownMenuItem<DivisionModel>>(
          (e) => DropdownMenuItem(
            value: e,
            child: CustomCommonTextWidget(
                text: e.divisionName ?? '',
                style: CommonTextStyle.bold_14,
                color: colorPrimaryText,
                textAlign :  TextAlign.center,
                shouldShowMultipleLine : true
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<DistrictModel>> _createDistrictList() {
    return districtList
        .map<DropdownMenuItem<DistrictModel>>(
          (e) => DropdownMenuItem(
            value: e,
            child: CustomCommonTextWidget(
                text: e.districtName ?? '',
                style: CommonTextStyle.bold_14,
                color: colorPrimaryText,
                textAlign :  TextAlign.center,
                shouldShowMultipleLine : true
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<ThanaModel>> _createThanaList() {
    return thanaList
        .map<DropdownMenuItem<ThanaModel>>(
          (e) => DropdownMenuItem(
            value: e,
            child: CustomCommonTextWidget(
                text: e.upazillaName ?? '',
                style: CommonTextStyle.bold_14,
                color: colorPrimaryText,
                textAlign :  TextAlign.center,
                shouldShowMultipleLine : true
            ),
          ),
        )
        .toList();
  }

  Widget _createDivisionDropdownContainer(
      Widget dropdown, String label, DivisionModel? value) {
    return Container(
      margin: DimenEdgeInset.marginTB_8,
      child: Column(
        children: [dropdown],
      ),
    );
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
            case NidDetailsTag.disDropPresent:
            case NidDetailsTag.thanaDropPresent:
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
          labelStyle:  FontStyle.l_14_regular(),
          hintText: hint,
          hintStyle: FontStyle.l_12_regular(color: greyColor),
        ),
      ),
    );
  }
}

class NidTextForm extends StatefulWidget {
  const NidTextForm({
    super.key,
    required this.controller,
    required this.label,
    this.isEnabled = true,
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
            labelStyle:  FontStyle.l_14_regular(),
            labelText: widget.label,
            border: OutlineInputBorder(
              borderRadius: AppDimen.commonCircularBorderRadius,
              borderSide: BorderSide(color: greyColor, width: DimenSizes.dimen_2),
            )),
        validator: validateBasicText,
      ),
    );
  }
}

Widget _createDistrictDropdownContainer(
    Widget dropdown, String label, DistrictModel? value) {
  return Container(
    margin: DimenEdgeInset.marginTB_8,
    child: Column(
      children: [dropdown],
    ),
  );
}

Widget _createThanaDropdownContainer(
    Widget dropdown, String label, ThanaModel? value) {
  return Container(
    margin: DimenEdgeInset.marginTB_8,
    child: Column(
      children: [
        dropdown,
      ],
    ),
  );
}
