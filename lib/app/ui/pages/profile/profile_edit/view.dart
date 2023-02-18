import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_form_field.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/controller.dart';
import 'package:mobile_sev2/domain/file.dart';

class ProfileEditPage extends View {
  final Object? arguments;

  ProfileEditPage({this.arguments});

  @override
  _ProfileEditState createState() => _ProfileEditState(
      AppComponent.getInjector().get<ProfileEditController>(), arguments);
}

class _ProfileEditState
    extends ViewState<ProfileEditPage, ProfileEditController> {
  ProfileEditController _controller;

  _ProfileEditState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ProfileEditController>(
            builder: (context, controller) {
          return Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                elevation: 0,
                flexibleSpace: SimpleAppBar(
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  titleMargin: Dimens.SPACE_10,
                  title: Text(
                    S.of(context).profile_edit_label,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16, fontWeight: FontWeight.bold),
                  ),
                  suffix: InkWell(
                    onTap: () {
                      controller.validate();
                      if (_controller.isValidated) _controller.save();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: Dimens.SPACE_24),
                      child: Text(
                        S.of(context).label_submit,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_16,
                            color: _controller.isValidated
                                ? ColorsItem.orangeFB9600
                                : ColorsItem.grey8C8C8C,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              body: _controller.isUploading || _controller.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _controller.userData.avatar.isEmpty
                                  ? InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.SPACE_30),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(width: Dimens.SPACE_2),
                                        ),
                                        child: CircleAvatar(
                                          child:
                                              FaIcon(FontAwesomeIcons.camera),
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              9,
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            _controller.upload(FileType.image);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Dimens.SPACE_30),
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: Dimens.SPACE_2)),
                                            child: CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  9,
                                              backgroundImage: NetworkImage(
                                                  _controller.userData.avatar),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  9),
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_9),
                                          decoration: BoxDecoration(
                                              color: ColorsItem.redDA1414,
                                              shape: BoxShape.circle),
                                          child: FaIcon(
                                            FontAwesomeIcons.trashCan,
                                            color: ColorsItem.whiteFEFEFE,
                                            size: Dimens.SPACE_15,
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_profile_name_label,
                              hintText:
                                  S.of(context).profile_profile_name_label,
                              onChanged: (value) => controller.validate(),
                              textEditingController:
                                  controller.userNameController,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              isReadOnly: true,
                              label: S
                                  .of(context)
                                  .profile_profile_display_name_label,
                              hintText: S
                                  .of(context)
                                  .profile_profile_display_name_label,
                              onChanged: (value) {},
                              textEditingController:
                                  controller.displayNameController,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_birth_date,
                              hintText: S.of(context).profile_birth_date,
                              onTap: () {
                                _selectBirthDate();
                              },
                              onChanged: (val) => {},
                              textEditingController:
                                  controller.birthDateController,
                              prefixIcon: Icon(
                                FontAwesomeIcons.calendarDay,
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_birth_place,
                              hintText: S.of(context).profile_birth_place,
                              onChanged: (value) {},
                              textEditingController:
                                  controller.birthPlaceController,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_github_url,
                              hintText: S.of(context).profile_github_url,
                              onChanged: (val) => controller.validate(),
                              textEditingController:
                                  controller.githubUrlController,
                              focusedBorderColor: ColorsItem.orangeFB9600,
                              enabledBorderColor: controller.isValidated
                                  ? ColorsItem.grey666B73
                                  : ColorsItem.redDA1414,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_stackoverflow_url,
                              hintText: S.of(context).profile_stackoverflow_url,
                              onChanged: (val) => controller.validate(),
                              textEditingController:
                                  controller.stackoverflowUrlController,
                              focusedBorderColor: ColorsItem.orangeFB9600,
                              enabledBorderColor:
                                  controller.isStackoverflowValidated
                                      ? ColorsItem.grey666B73
                                      : ColorsItem.redDA1414,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_hackerrank_url,
                              hintText: S.of(context).profile_hackerrank_url,
                              onChanged: (val) => controller.validate(),
                              textEditingController:
                                  controller.hackerrankController,
                              focusedBorderColor: ColorsItem.orangeFB9600,
                              enabledBorderColor:
                                  controller.isHackerrankValidated
                                      ? ColorsItem.grey666B73
                                      : ColorsItem.redDA1414,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_duolingo_url,
                              hintText: S.of(context).profile_duolingo_url,
                              onChanged: (val) => controller.validate(),
                              textEditingController:
                                  controller.duolingoUrlController,
                              focusedBorderColor: ColorsItem.orangeFB9600,
                              enabledBorderColor: controller.isDuolingoValidated
                                  ? ColorsItem.grey666B73
                                  : ColorsItem.redDA1414,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            DefaultFormField(
                              label: S.of(context).profile_linkedin_url,
                              hintText: S.of(context).profile_linkedin_url,
                              onChanged: (val) => controller.validate(),
                              textEditingController:
                                  controller.linkedinUrlController,
                              focusedBorderColor: ColorsItem.orangeFB9600,
                              enabledBorderColor: controller.isLinkedinValidated
                                  ? ColorsItem.grey666B73
                                  : ColorsItem.redDA1414,
                            ),
                            SizedBox(height: Dimens.SPACE_30),
                          ],
                        ),
                      ),
                    ));
        }),
      );

  _selectBirthDate() async {
    DateTime selectedDate = _controller.dateUtil.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: _controller.dateUtil.from(_controller.dateUtil.now().year + 1),
    );
    if (picked != null) _controller.setCalendarBirthDate(picked);
  }
}
