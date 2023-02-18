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

class EmailPage extends View {
  final Object? arguments;

  EmailPage({this.arguments});

  @override
  _EmailState createState() => _EmailState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _EmailState extends ViewState<EmailPage, SettingController> {
  SettingController _controller;

  _EmailState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SettingController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              if (_controller.isEmailManageMode) {
                _controller.onEmailManageMode(false);
                _controller.onEmailDeleteMode(false);
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
                    "${_controller.isEmailManageMode ? S.of(context).label_manage : ""} E-mail",
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  suffix: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: _controller.isEmailManageMode
                        ? _controller.isEmailDeleteMode
                            ? GestureDetector(
                                onTap: () {
                                  _controller.onEmailDeleteMode(false);
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
                                  _controller.onEmailDeleteMode(true);
                                },
                                child: FaIcon(FontAwesomeIcons.solidTrashCan,
                                    size: Dimens.SPACE_18))
                        : PopupMenuButton(
                            onSelected: (value) {
                              if (value == 0)
                                _addEmail();
                              else if (value == 1)
                                _controller.onEmailManageMode(true);
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
                                          child: Text(
                                              S
                                                  .of(context)
                                                  .setting_email_add_label,
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
                                              S
                                                  .of(context)
                                                  .setting_email_manage_label,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14)))
                                    ],
                                  )),
                            ],
                          ),
                  ),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_35),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Text(
                        S.of(context).setting_email_primary_label.toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.w700)),
                  ),
                  OptionTile(
                      title: _controller.getPrimaryEmail().email,
                      subtitle: "Primary • Verified"),
                  //TODO: check if email is verified
                  SizedBox(height: Dimens.SPACE_20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Text(S.of(context).label_other.toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _controller.getNonPrimaryEmails().length,
                      itemBuilder: (context, index) {
                        return OptionTile(
                            title:
                                _controller.getNonPrimaryEmails()[index].email,
                            subtitle: S.of(context).label_verified,
                            endIcon: _controller.isEmailManageMode
                                ? _controller.isEmailDeleteMode
                                    ? InkWell(
                                        onTap: () {
                                          showCustomAlertDialog(
                                              context: context,
                                              title: S
                                                  .of(context)
                                                  .setting_email_delete_confirmation,
                                              subtitle: S
                                                  .of(context)
                                                  .setting_email_delete_description,
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
                                                _controller.onDeleteEmail(
                                                    _controller
                                                            .getNonPrimaryEmails()[
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
                                          _controller.savePrimaryEmail(
                                              _controller.getNonPrimaryEmails()[
                                                  index]);
                                        },
                                        child: Chip(
                                            label: Text(
                                              S
                                                  .of(context)
                                                  .setting_set_primary_label,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_12),
                                            ),
                                            backgroundColor:
                                                ColorsItem.orangeFB9600),
                                      )
                                : null); //TODO: check if emails are verified
                      })
                ],
              ),
            ),
          );
        }),
      );

  _addEmail() {
    _controller.newEmailController.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setter) {
            _controller.addStateSetter('email', setter);
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
                        S.of(context).setting_email_add_label,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                      ),
                      padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                      suffix: GestureDetector(
                        onTap: () {
                          showCustomAlertDialog(
                              context: context,
                              title:
                                  "${S.of(context).label_verify} ${S.of(context).setting_account_email}",
                              subtitle: S
                                  .of(context)
                                  .setting_email_verification_subtitle,
                              cancelButtonText:
                                  S.of(context).label_back.toUpperCase(),
                              confirmButtonText:
                                  S.of(context).label_verify.toUpperCase(),
                              onCancel: () => Navigator.pop(context),
                              onConfirm: () {
                                if (_controller.isEmailReady()) {
                                  _controller.saveEmail();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              });
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
                        Text(S.of(context).setting_email_address_label,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.greyB8BBBF,
                                fontSize: Dimens.SPACE_12)),
                        SizedBox(height: Dimens.SPACE_8),
                        TextField(
                          controller: _controller.newEmailController,
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          onChanged: (String str) =>
                              _controller.onValidateEmail(str),
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
                            hintText:
                                S.of(context).setting_email_address_input_label,
                            errorText: _controller.isEmailValidated
                                ? null
                                : S.of(context).error_invalid_email,
                          ),
                          keyboardType: TextInputType.emailAddress,
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
