import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/dimens/dimensions.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 01,April,2023.

class ShimmerHomeGridWidget extends StatelessWidget {
  const ShimmerHomeGridWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(DimenSizes.dimen_5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.only(left: DimenSizes.dimen_5, right: DimenSizes.dimen_5, top: DimenSizes.dimen_5, bottom: DimenSizes.dimen_0),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimenSizes.dimen_8),
            ),
            child: SvgPicture.asset('assets/svg_files/ic_placeholder.svg'),
          );
        },
      ),
      subtitle: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: DimenSizes.dimen_5, right: DimenSizes.dimen_5, top: DimenSizes.dimen_0, bottom: DimenSizes.dimen_0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(DimenSizes.dimen_5),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimenSizes.dimen_8),
            ),
          );
        },
      ),
    );
  }
}