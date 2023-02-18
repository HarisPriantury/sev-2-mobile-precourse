import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/controller.dart';

class ColumnListPage extends View {
  final Object? arguments;

  ColumnListPage({this.arguments});

  @override
  _ColumnListState createState() => _ColumnListState(
        AppComponent.getInjector().get<ColumnListController>(),
        arguments,
      );
}

class _ColumnListState extends ViewState<ColumnListPage, ColumnListController> {
  ColumnListController _controller;

  _ColumnListState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<ColumnListController>(
          builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          backgroundColor: ColorsItem.black1F2329,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height / 10,
            flexibleSpace: SimpleAppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              prefix: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: ColorsItem.whiteE0E0E0,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "${S.of(context).label_reorder} ${S.of(context).label_column}",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_16,
                  fontWeight: FontWeight.w700,
                  color: ColorsItem.whiteEDEDED,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: ColorsItem.black191C21,
              suffix: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: InkWell(
                  onTap: _controller.isColumnMoved
                      ? () {
                          _controller.reorderColumn();
                        }
                      : () {},
                  child: Text(
                    S.of(context).label_submit,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                      fontWeight: FontWeight.w700,
                      color: ColorsItem.orangeFB9600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: _controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : Theme(
                  data: ThemeData(
                    canvasColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_20,
                      vertical: Dimens.SPACE_16,
                    ),
                    itemCount: _controller.projectColumn.length,
                    onReorder: (int oldIdx, int newIdx) {
                      _controller.moveColumn(oldIdx, newIdx);
                    },
                    itemBuilder: (context, index) {
                      String colname = _controller.projectColumn[index].name;
                      return _listItem(colname, Key('$index'));
                    },
                  ),
                ),
        );
      });

  Widget _listItem(String colname, Key keyItem) {
    return Container(
      key: keyItem,
      margin: EdgeInsets.only(
        bottom: Dimens.SPACE_8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.SPACE_17,
        vertical: Dimens.SPACE_17,
      ),
      decoration: BoxDecoration(
          color: ColorsItem.grey32373D,
          borderRadius: BorderRadius.circular(
            Dimens.SPACE_8,
          )),
      child: Row(
        children: [
          Container(
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: ColorsItem.whiteFEFEFE,
                  size: Dimens.SPACE_15,
                ),
                FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: ColorsItem.whiteFEFEFE,
                  size: Dimens.SPACE_15,
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dimens.SPACE_15,
          ),
          Text(
            colname,
            style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_14,
              fontWeight: FontWeight.w500,
              color: ColorsItem.whiteE0E0E0,
            ),
          ),
        ],
      ),
    );
  }
}
