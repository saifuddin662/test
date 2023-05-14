import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/top_up_agent/top_up_agent_enter_amount_screen.dart';
import '../../base/base_consumer_state.dart';
import '../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../utils/Colors.dart';
import '../../utils/dimens/app_dimens.dart';
import '../../utils/extensions/extension_rounded_rectangle_border.dart';
import '../../utils/styles.dart';
import 'api/top_up_agent_list_controller.dart';


class TopUpAgentListScreen extends ConsumerStatefulWidget {

  const TopUpAgentListScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TopUpAgentListScreen> createState() => _TopUpAgentListScreenState();
}

class _TopUpAgentListScreenState extends BaseConsumerState<TopUpAgentListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(topUpAgentListControllerProvider.notifier).getAgentList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topUpAgentData = ref.watch(topUpAgentListControllerProvider);
    final agentList = topUpAgentData.value?.agentListList ?? [];

    return Scaffold(
      appBar: const CustomCommonAppBarWidget(appBarTitle: 'top_up_agent'),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: AppDimen.toolbarBottomGap),
            agentList.isNotEmpty ?
            Padding(
              padding: AppDimen.commonLeftRightPadding,
              child: CustomCommonTextWidget(
                  text: "top_up_agent_select".tr(),
                  style: CommonTextStyle.regular_16,
                  color: colorPrimaryText,
                  shouldShowMultipleLine : true
              ),
            ) : const SizedBox.shrink(),
            topUpAgentData.isLoading ?
            const Center(child: CircularProgressIndicator()) :
            agentList.isNotEmpty ?
            Expanded(
                child: ListView.builder(
                  padding: AppDimen.commonAllSidePadding20,
                  itemCount: agentList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: ShapeStyle.listItemShape(),
                      child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.person)
                          ),
                          title: CustomCommonTextWidget(
                              text: agentList[index],
                              style: CommonTextStyle.regular_16,
                              color: colorPrimaryText,
                              shouldShowMultipleLine : true
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopUpAgentEnterAmountScreen(
                                        userName: agentList[index].toString(),
                                        walletNumber: agentList[index].toString()
                                    )
                                )
                            );
                          }),
                    );
                  },
                )
            ) :
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: CustomCommonTextWidget(
                  text: "no_agent_found".tr(),
                  style: CommonTextStyle.regular_14,
                  color: eclipse ,
                ),
              ),
            ),
          ]
      )
    );
  }
}