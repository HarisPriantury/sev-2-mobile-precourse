import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/mood_widget.dart';
import 'package:mobile_sev2/app/ui/pages/daily_mood/controller.dart';

class PopupDailyMood extends View {
  final Object? arguments;

  PopupDailyMood({this.arguments});

  @override
  _MainState createState() => _MainState(AppComponent.getInjector().get<DailyMoodController>(), arguments);
}

class _MainState extends ViewState<PopupDailyMood, DailyMoodController> {
  DailyMoodController _controller;
  // String mode = "selectMood";
  String mood = "";

  _MainState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<DailyMoodController>(builder: (context, controller) {
        double widthDialog = MediaQuery.of(context).size.width * 0.90;

        return WillPopScope(
          onWillPop: () async {
            if (_controller.dialogMode == DialogMode.BlockerConfirm) {
              _controller.changeMode(DialogMode.SelectMood);
            } else if (_controller.dialogMode == DialogMode.BlockerNote) {
              _controller.changeMode(DialogMode.BlockerConfirm);
            }
            return false;
          },
          child: SimpleDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.all(0),
            backgroundColor: ColorsItem.black020202,
            elevation: 0,
            children: <Widget>[
              Container(
                  width: widthDialog,
                  padding: EdgeInsets.fromLTRB(
                    Dimens.SPACE_13,
                    31,
                    Dimens.SPACE_13,
                    25,
                  ),
                  child: _controller.dialogMode == DialogMode.SelectMood
                      ? moodSelect(context)
                      : _controller.dialogMode == DialogMode.BlockerConfirm
                          ? blockerConfirm()
                          : _controller.dialogMode == DialogMode.BlockerNote
                              ? blockerFill()
                              : _controller.dialogMode == DialogMode.Done
                                  ? moodDone()
                                  : _controller.dialogMode == DialogMode.ThanksGreet
                                      ? thanksGreet()
                                      : goodDay())
            ],
          ),
        );
      });

  Column moodSelect(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${S.of(context).label_hello} ${_controller.firstName}",
              style: GoogleFonts.montserrat(
                color: ColorsItem.whiteFEFEFE,
                fontWeight: FontWeight.w700,
                fontSize: Dimens.TEXT_SIZE_H5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 3,
            ),
            Image.asset(
              ImageItem.IC_HAND,
            ),
          ],
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          S.of(context).label_how_day,
          style: GoogleFonts.montserrat(
            color: ColorsItem.whiteFEFEFE,
            fontWeight: FontWeight.w700,
            fontSize: Dimens.SPACE_20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectMood(S.of(context).label_ic_happy);
                        _controller.changeMode(DialogMode.BlockerConfirm);
                      },
                      child: MoodWidget(
                        mood: _controller.selectedMood,
                        iconMood: ImageItem.IC_HAPPY,
                        label: S.of(context).label_ic_happy,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectMood(S.of(context).label_ic_enthusiastic);
                        _controller.changeMode(DialogMode.BlockerConfirm);
                      },
                      child: MoodWidget(
                        mood: _controller.selectedMood,
                        iconMood: ImageItem.IC_ENTHUSIASTIC,
                        label: S.of(context).label_ic_enthusiastic,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectMood(S.of(context).label_ic_sad);
                        _controller.changeMode(DialogMode.BlockerConfirm);
                      },
                      child: MoodWidget(
                        mood: _controller.selectedMood,
                        iconMood: ImageItem.IC_SAD,
                        label: S.of(context).label_ic_sad,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectMood(S.of(context).label_ic_bad);
                        _controller.changeMode(DialogMode.BlockerConfirm);
                      },
                      child: MoodWidget(
                        mood: _controller.selectedMood,
                        iconMood: ImageItem.IC_BAD,
                        label: S.of(context).label_ic_bad,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectMood(S.of(context).label_ic_tired);
                        _controller.changeMode(DialogMode.BlockerConfirm);
                      },
                      child: MoodWidget(
                        mood: _controller.selectedMood,
                        iconMood: ImageItem.IC_TIRED,
                        label: S.of(context).label_ic_tired,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Column blockerConfirm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${S.of(context).label_hello} ${_controller.firstName}",
              style: GoogleFonts.montserrat(
                color: ColorsItem.whiteFEFEFE,
                fontWeight: FontWeight.w700,
                fontSize: Dimens.TEXT_SIZE_H5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 3,
            ),
            Image.asset(
              ImageItem.IC_HAND,
            ),
          ],
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          S.of(context).label_any_blocker,
          style: GoogleFonts.montserrat(
            color: ColorsItem.whiteFEFEFE,
            fontWeight: FontWeight.w700,
            fontSize: Dimens.SPACE_20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 40,
        ),
        Column(
          children: [
            Container(
              width: 151,
              height: 38,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsItem.orangeFB9600),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: ColorsItem.orangeFB9600),
                      ))),
                  onPressed: () {
                    _controller.changeMode(DialogMode.BlockerNote);
                  },
                  child: Text(
                    S.of(context).label_YES,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.black020202,
                      fontSize: Dimens.TEXT_SIZE_H5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 151,
              height: 38,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ColorsItem.black020202),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: ColorsItem.orangeFB9600),
                    ))),
                onPressed: () {
                  _controller.sendMood();
                  if (_controller.selectedMood == S.of(context).label_ic_sad ||
                      _controller.selectedMood == S.of(context).label_ic_bad) {
                    _controller.changeMode(DialogMode.GoodDay);
                  } else {
                    _controller.changeMode(DialogMode.ThanksGreet);
                  }
                },
                child: Text(
                  S.of(context).label_NO,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.orangeFB9600,
                    fontSize: Dimens.TEXT_SIZE_H5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Column blockerFill() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${S.of(context).label_hello} ${_controller.firstName}",
              style: GoogleFonts.montserrat(
                color: ColorsItem.whiteFEFEFE,
                fontWeight: FontWeight.w700,
                fontSize: Dimens.TEXT_SIZE_H4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 3,
            ),
            Image.asset(
              ImageItem.IC_HAND,
            ),
          ],
        ),
        SizedBox(
          height: 9,
        ),
        Text(
          S.of(context).label_what_blocker,
          style: GoogleFonts.montserrat(
            color: ColorsItem.whiteFEFEFE,
            fontWeight: FontWeight.w700,
            fontSize: Dimens.SPACE_20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 40,
        ),
        Column(
          children: [
            Container(
              width: 303,
              height: 155,
              child: TextFormField(
                controller: _controller.textFormController,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 250,
                cursorColor: ColorsItem.whiteFEFEFE,
                style: GoogleFonts.montserrat(
                  color: ColorsItem.whiteFEFEFE,
                  fontSize: Dimens.TEXT_SIZE_H5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorsItem.black32373D,
                    hintText: S.of(context).label_write_something,
                    hintStyle: GoogleFonts.montserrat(
                      color: ColorsItem.grey666B73,
                      fontSize: Dimens.TEXT_SIZE_H5,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsItem.black020202))),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 151,
              height: 38,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: _controller.textFormController.text.length > 0
                        ? MaterialStateProperty.all(ColorsItem.orangeFB9600)
                        : MaterialStateProperty.all(ColorsItem.grey8D9299),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                          color: _controller.isFormNotEmpty ? ColorsItem.orangeFB9600 : ColorsItem.grey8D9299),
                    ))),
                onPressed: () {
                  _controller.sendMood();
                  _controller.changeMode(DialogMode.Done);
                },
                child: Text(
                  S.of(context).label_SEND,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.black020202,
                    fontSize: Dimens.TEXT_SIZE_H5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Column moodDone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "${S.of(context).label_glad_to_hear} ${_controller.firstName}, ${S.of(context).label_help_soon} 😄",
            style: GoogleFonts.montserrat(
              color: ColorsItem.whiteFEFEFE,
              fontWeight: FontWeight.w700,
              fontSize: Dimens.SPACE_20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 151,
          height: 38,
          child: _controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: ColorsItem.greyB8BBBF,
                ))
              : ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsItem.black020202),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: ColorsItem.grey858A93),
                ))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              S.of(context).label_DONE,
              style: GoogleFonts.montserrat(
                color: ColorsItem.grey858A93,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        )
      ],
    );
  }

  Column thanksGreet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "${S.of(context).label_thanks} ${_controller.firstName} ❤️ ",
            style: GoogleFonts.montserrat(
              color: ColorsItem.whiteFEFEFE,
              fontWeight: FontWeight.w700,
              fontSize: Dimens.SPACE_20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 151,
          height: 38,
          child: _controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: ColorsItem.greyB8BBBF,
                ))
              : ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsItem.black020202),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: ColorsItem.grey858A93),
                ),),),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              S.of(context).label_DONE,
              style: GoogleFonts.montserrat(
                color: Color(0XFF858A93),
                fontSize: Dimens.TEXT_SIZE_H5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        )
      ],
    );
  }

  Column goodDay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "${S.of(context).label_nice_day} ${_controller.firstName} 😊 ",
            style: GoogleFonts.montserrat(
              color: ColorsItem.whiteFEFEFE,
              fontWeight: FontWeight.w700,
              fontSize: Dimens.SPACE_20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 151,
          height: 38,
          child: _controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: ColorsItem.greyB8BBBF,
                ))
              : ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsItem.black020202),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: ColorsItem.grey858A93),
                      ))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).label_DONE,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.grey858A93,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
        )
      ],
    );
  }
}
