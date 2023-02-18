import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/option_tile.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/controller.dart';

class PhonePage extends View {
  final Object? arguments;

  PhonePage({this.arguments});

  @override
  _PhoneState createState() => _PhoneState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _PhoneState extends ViewState<PhonePage, SettingController> {
  SettingController _controller;

  _PhoneState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SettingController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              if (_controller.isPhoneManageMode) {
                _controller.onPhoneManageMode(false);
                _controller.onPhoneDeleteMode(false);
                return false;
              } else {
                Navigator.pop(context);
                return true;
              }
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    "${_controller.isPhoneManageMode ? "Manage" : ""} ${S.of(context).setting_account_phone}",
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  suffix: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: _controller.isPhoneManageMode
                        ? _controller.isPhoneDeleteMode
                            ? GestureDetector(
                                onTap: () {
                                  _controller.onPhoneDeleteMode(false);
                                },
                                child: Text(
                                  S.of(context).label_done,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Dimens.SPACE_14,
                                      color: ColorsItem.orangeFB9600),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  _controller.onPhoneDeleteMode(true);
                                },
                                child: FaIcon(FontAwesomeIcons.solidTrashCan,
                                    size: Dimens.SPACE_18))
                        : PopupMenuButton(
                            onSelected: (value) {
                              if (value == 0)
                                _addNumber();
                              else if (value == 1)
                                _controller.onPhoneManageMode(true);
                            },
                            child: FaIcon(FontAwesomeIcons.ellipsisVertical,
                                size: Dimens.SPACE_18),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.plus,
                                          size: Dimens.SPACE_18),
                                      SizedBox(width: Dimens.SPACE_8),
                                      Expanded(
                                          child: Text(S.of(context).label_add,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14)))
                                    ],
                                  )),
                              PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.gear,
                                          size: Dimens.SPACE_18),
                                      SizedBox(width: Dimens.SPACE_8),
                                      Expanded(
                                          child: Text(
                                              S.of(context).label_manage,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14)))
                                    ],
                                  )),
                            ],
                          ),
                  ),
                ),
              ),
              body: _controller.phoneList.isEmpty
                  ? _emptyState()
                  : Column(
                      children: [
                        SizedBox(height: Dimens.SPACE_20),
                        OptionTile(
                            title: _controller.getPrimaryPhone().phone,
                            subtitle: S.of(context).label_enable,
                            endIcon: _controller.isPhoneDeleteMode
                                ? InkWell(
                                    onTap: () {
                                      showCustomAlertDialog(
                                          context: context,
                                          title: S
                                              .of(context)
                                              .setting_phone_delete_confirmation,
                                          subtitle: S
                                              .of(context)
                                              .setting_phone_delete_description,
                                          cancelButtonText: S
                                              .of(context)
                                              .label_cancel
                                              .toUpperCase(),
                                          confirmButtonText: S
                                              .of(context)
                                              .label_delete
                                              .toUpperCase(),
                                          onCancel: () =>
                                              Navigator.pop(context),
                                          onConfirm: () {
                                            Navigator.pop(context);
                                          });
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.solidTrashCan,
                                      color: ColorsItem.redDA1414,
                                      size: Dimens.SPACE_20,
                                    ),
                                  )
                                : null),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _controller.getNonPrimaryPhones().length,
                            itemBuilder: (context, index) {
                              return OptionTile(
                                title: _controller
                                    .getNonPrimaryPhones()[index]
                                    .phone,
                                subtitle: S.of(context).label_enable,
                                endIcon: _controller.isPhoneManageMode
                                    ? _controller.isPhoneDeleteMode
                                        ? InkWell(
                                            onTap: () {
                                              showCustomAlertDialog(
                                                  context: context,
                                                  title: S
                                                      .of(context)
                                                      .setting_phone_delete_confirmation,
                                                  subtitle: S
                                                      .of(context)
                                                      .setting_phone_delete_description,
                                                  cancelButtonText: S
                                                      .of(context)
                                                      .label_cancel
                                                      .toUpperCase(),
                                                  confirmButtonText: S
                                                      .of(context)
                                                      .label_delete
                                                      .toUpperCase(),
                                                  onCancel: () =>
                                                      Navigator.pop(context),
                                                  onConfirm: () {
                                                    _controller.onDeletePhone(
                                                        _controller
                                                                .getNonPrimaryPhones()[
                                                            index]);
                                                    Navigator.pop(context);
                                                  });
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.solidTrashCan,
                                              color: ColorsItem.redDA1414,
                                              size: Dimens.SPACE_20,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              _controller.savePrimaryPhone(
                                                  _controller
                                                          .getNonPrimaryPhones()[
                                                      index]);
                                              Navigator.pop(context);
                                            },
                                            child: Chip(
                                                label: Text(
                                                  S
                                                      .of(context)
                                                      .setting_set_primary_label,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize:
                                                          Dimens.SPACE_12),
                                                ),
                                                backgroundColor:
                                                    ColorsItem.orangeFB9600),
                                          )
                                    : null,
                              );
                            })
                      ],
                    ),
            ),
          );
        }),
      );

  Widget _emptyState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).setting_data_empty,
              style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_18, fontWeight: FontWeight.w700)),
          SizedBox(height: Dimens.SPACE_8),
          Text(S.of(context).setting_phone_add_description,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: ColorsItem.grey666B73, fontSize: Dimens.SPACE_14)),
          //this empty space is to bump the content up to center because appbar is taking space first
          SizedBox(height: MediaQuery.of(context).size.height / 12)
        ],
      ),
    );
  }

  _addNumber() {
    _controller.newNumberController.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setter) {
            _controller.addStateSetter('phone', setter);
            return Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: MediaQuery.of(context).size.height / 10,
                    flexibleSpace: SimpleAppBar(
                      toolbarHeight: MediaQuery.of(context).size.height / 10,
                      prefix: IconButton(
                        icon: FaIcon(FontAwesomeIcons.chevronLeft),
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Text(
                        S.of(context).setting_phone_add_title,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      suffix: GestureDetector(
                        onTap: () {
                          if (_controller.isPhoneReady()) {
                            _controller.savePhone();
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 24.0),
                          child: Text(
                            S.of(context).label_add,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.SPACE_14,
                                color: ColorsItem.orangeFB9600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimens.SPACE_20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).label_phonenumber,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12)),
                        SizedBox(height: Dimens.SPACE_8),
                        TextField(
                          controller: _controller.newNumberController,
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          onChanged: (String str) =>
                              _controller.onValidatePhone(str),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            hintStyle: GoogleFonts.montserrat(
                                color: ColorsItem.grey666B73),
                            errorText: _controller.isPhoneValidated
                                ? null
                                : S.of(context).error_invalid_phone,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
