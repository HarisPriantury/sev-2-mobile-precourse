import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/wiki_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/controller.dart';
import 'package:mobile_sev2/domain/wiki.dart';
import 'package:shimmer/shimmer.dart';

class WikiListPage extends View {
  @override
  _WikiListState createState() =>
      _WikiListState(AppComponent.getInjector().get<WikiListController>());
}

class _WikiListState extends ViewState<WikiListPage, WikiListController> {
  _WikiListState(this._controller) : super(_controller);

  WikiListController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<WikiListController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  S.of(context).label_wiki,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Dimens.SPACE_20, fontWeight: FontWeight.bold),
                ),
                suffix: Container(
                  width: Dimens.SPACE_50,
                ),
              ),
            ),
            body: DefaultRefreshIndicator(
              onRefresh: () => _controller.reload(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_16),
                  Expanded(
                    child: controller.isLoading
                        ? _shimmer()
                        : _controller.wikis.isEmpty
                            ? EmptyList(
                                title: S.of(context).empty_wiki_title,
                                descripton:
                                    S.of(context).empty_wiki_description)
                            : SingleChildScrollView(
                                controller: _controller.listScrollController,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: _controller.wikis.length,
                                      itemBuilder: (context, index) {
                                        Wiki wiki = controller.wikis[index];
                                        return WikiItem(
                                          wikiName: wiki.title ?? "",
                                          fileCreated: _controller.dateUtil
                                              .displayDateTimeFormat(
                                                  wiki.createdAt!),
                                          onTap: () =>
                                              controller.gotoDetailWiki(wiki),
                                        );
                                      }),
                                ),
                              ),
                  )
                ],
              ),
            ),
          );
        }),
      );

  Shimmer _shimmer() {
    return Shimmer.fromColors(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        period: Duration(seconds: 1),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: Dimens.SPACE_20, right: Dimens.SPACE_10),
                          decoration: BoxDecoration(
                            color: ColorsItem.black32373D,
                            borderRadius: new BorderRadius.all(
                              const Radius.circular(
                                Dimens.SPACE_12,
                              ),
                            ),
                          ),
                          width: Dimens.SPACE_18,
                          height: Dimens.SPACE_18,
                        ),
                        baseColor: ColorsItem.grey979797,
                        highlightColor: ColorsItem.grey606060,
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          period: Duration(seconds: 1),
                          child: Container(
                            margin: EdgeInsets.only(right: Dimens.SPACE_5),
                            decoration: BoxDecoration(
                              color: ColorsItem.black32373D,
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(Dimens.SPACE_12)),
                            ),
                            height: Dimens.SPACE_18,
                          ),
                          baseColor: ColorsItem.grey979797,
                          highlightColor: ColorsItem.grey606060,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.SPACE_6),
                  Shimmer.fromColors(
                    period: Duration(seconds: 1),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimens.SPACE_20, right: Dimens.SPACE_10),
                      decoration: BoxDecoration(
                        color: ColorsItem.black32373D,
                        borderRadius: new BorderRadius.all(
                            const Radius.circular(Dimens.SPACE_12)),
                      ),
                      width: Dimens.SPACE_170,
                      height: Dimens.SPACE_12,
                    ),
                    baseColor: ColorsItem.grey979797,
                    highlightColor: ColorsItem.grey606060,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimens.SPACE_20,
                      top: Dimens.SPACE_10,
                    ),
                    child: Shimmer.fromColors(
                      period: Duration(seconds: 1),
                      child: Container(
                        margin: EdgeInsets.only(right: Dimens.SPACE_5),
                        decoration: BoxDecoration(
                          color: ColorsItem.black32373D,
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(Dimens.SPACE_12)),
                        ),
                        height: Dimens.SPACE_1,
                      ),
                      baseColor: ColorsItem.grey979797,
                      highlightColor: ColorsItem.grey606060,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
