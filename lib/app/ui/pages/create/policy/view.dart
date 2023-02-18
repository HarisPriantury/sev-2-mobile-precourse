import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/controller.dart';

class PolicyPage extends View {
  final Object? arguments;

  PolicyPage({this.arguments});

  @override
  _PolicyState createState() => _PolicyState(
      AppComponent.getInjector().get<PolicyController>(), arguments);
}

class _PolicyState extends ViewState<PolicyPage, PolicyController> {
  PolicyController _controller;

  _PolicyState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<PolicyController>(builder: (context, controller) {
        return Scaffold(
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
                _controller.policyData?.type == PolicyType.visible
                    ? S.of(context).label_visible_to
                    : S.of(context).label_editable_to,
                style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
              ),
              padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
              suffix: GestureDetector(
                onTap: () {
                  Navigator.pop(context, _controller.policyData);
                },
                child: Container(
                  padding: EdgeInsets.only(right: Dimens.SPACE_24),
                  child: Text(
                    S.of(context).label_add,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimens.SPACE_14,
                        color: _controller.isSelected()
                            ? ColorsItem.orangeFB9600
                            : ColorsItem.grey606060),
                  ),
                ),
              ),
            ),
          ),
          body: controller.isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _controller.policyData?.type == PolicyType.visible &&
                              _controller.spaces.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: Dimens.SPACE_16,
                                  left: Dimens.SPACE_16,
                                  right: Dimens.SPACE_16,
                                  bottom: Dimens.SPACE_12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Space".toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.SPACE_8),
                                  FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimens.SPACE_16),
                                            labelStyle: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.montserrat()
                                                        .fontFamily),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorsItem
                                                        .grey666B73))),
                                        isEmpty:
                                            _controller.policyData?.space?.id ==
                                                '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _controller
                                                .policyData?.space?.id,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              _controller
                                                  .onSelectedSpace(newValue);
                                            },
                                            items:
                                                _controller.spaces.map((space) {
                                              return DropdownMenuItem<String>(
                                                value: space.id,
                                                child: Text(
                                                  space.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: GoogleFonts
                                                              .montserrat()
                                                          .fontFamily),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: Dimens.SPACE_20),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        child: Text("Basic Policies".toUpperCase(),
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700)),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _controller.basicPolicies.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          ColorsItem.greyd8d8d8),
                                  child: RadioListTile<String>(
                                    value:
                                        _controller.basicPolicies[index].value,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    groupValue:
                                        _controller.policyData?.policy?.value,
                                    title: Text(
                                        _controller.basicPolicies[index].title,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14)),
                                    activeColor: ColorsItem.orangeFB9600,
                                    onChanged: (val) {
                                      _controller.onSelectedPolicy(val);
                                    },
                                    selected: _controller
                                            .policyData?.policy?.value ==
                                        _controller.basicPolicies[index].value,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimens.SPACE_16),
                                  child: Divider(
                                      color: ColorsItem.grey858A93,
                                      height: Dimens.SPACE_2),
                                )
                              ],
                            );
                          }),
                      SizedBox(height: Dimens.SPACE_30),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        child: Text("Object Policies".toUpperCase(),
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700)),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _controller.objectPolicies.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          ColorsItem.greyd8d8d8),
                                  child: RadioListTile<String>(
                                    value:
                                        _controller.objectPolicies[index].value,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    groupValue:
                                        _controller.policyData?.policy?.value,
                                    title: Text(
                                        _controller.objectPolicies[index].title,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14)),
                                    activeColor: ColorsItem.orangeFB9600,
                                    onChanged: (val) {
                                      _controller.onSelectedPolicy(val);
                                    },
                                    selected: _controller
                                            .policyData?.policy?.value ==
                                        _controller.objectPolicies[index].value,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimens.SPACE_16),
                                  child: Divider(
                                      color: ColorsItem.grey858A93,
                                      height: Dimens.SPACE_2),
                                )
                              ],
                            );
                          }),
                      SizedBox(height: Dimens.SPACE_30),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        child: Text("User Policies".toUpperCase(),
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700)),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _controller.userPolicies.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          ColorsItem.greyd8d8d8),
                                  child: RadioListTile<String>(
                                    value:
                                        _controller.userPolicies[index].value,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    groupValue:
                                        _controller.policyData?.policy?.value,
                                    title: Text(
                                        _controller.userPolicies[index].title,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14)),
                                    activeColor: ColorsItem.orangeFB9600,
                                    onChanged: (val) {
                                      _controller.onSelectedPolicy(val);
                                    },
                                    selected: _controller
                                            .policyData?.policy?.value ==
                                        _controller.userPolicies[index].value,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimens.SPACE_16),
                                  child: Divider(
                                      color: ColorsItem.grey858A93,
                                      height: Dimens.SPACE_2),
                                )
                              ],
                            );
                          }),
                    ],
                  ),
                ),
          // bottomNavigationBar: Padding(
          //   padding: EdgeInsets.only(
          //       left: Dimens.SPACE_20, right: Dimens.SPACE_20, bottom: Dimens.SPACE_30, top: Dimens.SPACE_12),
          //   child: ButtonDefault(
          //       buttonText: S.of(context).label_custom_policy.toUpperCase(),
          //       buttonTextColor: ColorsItem.orangeFB9600,
          //       paddingVertical: Dimens.SPACE_16,
          //       buttonColor: Colors.transparent,
          //       buttonLineColor: ColorsItem.grey858A93,
          //       radius: Dimens.SPACE_8,
          //       letterSpacing: 1.5,
          //       onTap: () {
          //         _controller.goToCustomPolicy();
          //       }),
          // ),
        );
      });
}
