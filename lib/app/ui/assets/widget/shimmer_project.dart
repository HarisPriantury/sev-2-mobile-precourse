import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProject extends StatelessWidget {
  const ShimmerProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: Container(
        margin: EdgeInsets.only(top: Dimens.SPACE_20),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                period: Duration(seconds: 1),
                baseColor: ColorsItem.grey979797,
                highlightColor: ColorsItem.grey606060,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 10,
                    itemBuilder: (_, __) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                height: Dimens.SPACE_16,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                            SizedBox(height: Dimens.SPACE_6),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Dimens.SPACE_20,
                                        right: Dimens.SPACE_10),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    width: Dimens.SPACE_20,
                                    height: Dimens.SPACE_12,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                                Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: Dimens.SPACE_5),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    width: Dimens.SPACE_50,
                                    height: Dimens.SPACE_12,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                                Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: Dimens.SPACE_5),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    width: Dimens.SPACE_5,
                                    height: Dimens.SPACE_5,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                                Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: Dimens.SPACE_5),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    width: Dimens.SPACE_50,
                                    height: Dimens.SPACE_12,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
