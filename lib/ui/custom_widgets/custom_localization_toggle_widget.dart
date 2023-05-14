import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/base_consumer_state.dart';
import '../../utils/dimens/dimensions.dart';
import '../../utils/pref_keys.dart';

class CustomLocalizationToggle extends ConsumerStatefulWidget {
  final List<String> values;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? callbackAction;

  const CustomLocalizationToggle({
    super.key,
    required this.values,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.callbackAction,
  });
  @override
  ConsumerState<CustomLocalizationToggle> createState() => _CustomLocalizationToggleState();
}

class _CustomLocalizationToggleState extends BaseConsumerState<CustomLocalizationToggle> {

  late SharedPreferences _prefs;

  String lang = "en";

  @override
  void initState() {
    _initPrefs();
    super.initState();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      height: MediaQuery.of(context).size.width * 0.07,
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              widget.callbackAction != null ? widget.callbackAction!() : null;
              if(Scaffold.of(context).isDrawerOpen) {
                //Scaffold.of(context).closeDrawer();
              }
              if (context.locale.languageCode == "en") {
                setState(() {
                  lang = "bn";
                });
                context.setLocale(const Locale("bn"));
                _prefs.setString(PrefKeys.keyAppLang, "bn");
              }
              else {
                setState(() {
                  lang = "en";
                });
                context.setLocale(const Locale("en"));
                _prefs.setString(PrefKeys.keyAppLang, "en");
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DimenSizes.dimen_8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length, (index) =>
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        widget.values[index],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xAA000000),
                        ),
                      ),
                    ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: context.locale.languageCode == "en" ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.width * 0.07,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DimenSizes.dimen_8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                context.locale.languageCode == "en" ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}