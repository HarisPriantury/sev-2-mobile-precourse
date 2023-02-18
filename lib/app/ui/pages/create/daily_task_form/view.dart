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
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/controller.dart';

class DailyTaskForm extends View {
  final Object? arguments;

  DailyTaskForm({this.arguments});

  @override
  _DailyTaskFormState createState() => _DailyTaskFormState(
      AppComponent.getInjector().get<DailyTaskFormController>(), arguments);
}

class _DailyTaskFormState
    extends ViewState<DailyTaskForm, DailyTaskFormController> {
  final DailyTaskFormController _controller;

  _DailyTaskFormState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DailyTaskFormController>(
            builder: (context, controller) {
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
                  _getTitle(),
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                suffix: GestureDetector(
                  onTap: () {
                    _controller.validateOnTap();
                    if (_controller.isValidated) controller.onSubmitDailyTask();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(
                      S.of(context).label_submit,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: _controller.isValidated
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey606060),
                    ),
                  ),
                ),
              ),
            ),
            body: _getBodyContent(),
          );
        }),
      );

  Widget _getBodyContent() {
    if (_controller.data?.dailyTaskType == DailyTaskType.book) {
      return _submitSummaryBook();
    } else if (_controller.data?.dailyTaskType == DailyTaskType.feedback) {
      return _submitFeedback();
    } else {
      return _submitSharing();
    }
  }

  Widget _submitSummaryBook() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.SPACE_20),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DefaultFormField(
            label: S.of(context).label_title,
            textEditingController: _controller.titleController,
            onChanged: (val) => _controller.validate(),
            hintText: S.of(context).label_title,
            focusedBorderColor: ColorsItem.orangeFB9600,
            enabledBorderColor: _controller.isInputTitleEmpty &&
                    _controller.titleController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
          ),
          SizedBox(height: Dimens.SPACE_8),
          DefaultFormField(
            label: S.of(context).daily_start_page_label,
            textEditingController: _controller.startPageController,
            onChanged: (val) => _controller.validate(),
            hintText: S.of(context).daily_start_page_label,
            keyboardType: TextInputType.number,
            focusedBorderColor: ColorsItem.orangeFB9600,
            enabledBorderColor: _controller.isInputStartPageEmpty &&
                    _controller.startPageController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
          ),
          SizedBox(height: Dimens.SPACE_8),
          DefaultFormField(
            label: S.of(context).daily_end_page_label,
            textEditingController: _controller.endPageController,
            onChanged: (val) => _controller.validate(),
            hintText: S.of(context).daily_end_page_label,
            keyboardType: TextInputType.number,
            focusedBorderColor: ColorsItem.orangeFB9600,
            enabledBorderColor: _controller.isInputEndPageEmpty &&
                    _controller.endPageController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
          ),
          SizedBox(height: Dimens.SPACE_8),
          DefaultFormFieldWithLongText(
            focusedBorderColor: ColorsItem.orangeFB9600,
            hintText: S.of(context).label_daily_summary,
            label: S.of(context).label_daily_summary,
            maxLines: 5,
            onChanged: (val) => _controller.validate(),
            textEditingController: _controller.summaryBookController,
            enabledBorderColor: _controller.isInputSummaryBookValidated &&
                    _controller.summaryBookController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
          ),
          SizedBox(height: Dimens.SPACE_8),
        ]),
      ),
    );
  }

  Widget _submitFeedback() {
    return Padding(
      padding: EdgeInsets.all(Dimens.SPACE_20),
      child: DefaultFormFieldWithLongText(
        focusedBorderColor: ColorsItem.orangeFB9600,
        hintText: S.of(context).label_daily_feedback_pairing,
        label: S.of(context).label_daily_feedback_pairing,
        maxLines: 5,
        onChanged: (val) {
          _controller.validate();
          print(val);
        },
        textEditingController: _controller.feedbackForPairingController,
        enabledBorderColor: _controller.isInputFeedbackEmpty &&
                _controller.feedbackForPairingController.text.isEmpty
            ? ColorsItem.redDA1414
            : ColorsItem.grey666B73,
      ),
    );
  }

  Widget _submitSharing() {
    return Padding(
      padding: EdgeInsets.all(Dimens.SPACE_20),
      child: DefaultFormFieldWithLongText(
        focusedBorderColor: ColorsItem.orangeFB9600,
        hintText: S.of(context).label_daily_sharing_pairing,
        label: S.of(context).label_daily_sharing_pairing,
        maxLines: 5,
        onChanged: (val) {
          _controller.validate();
        },
        textEditingController: _controller.sharingFromPairingController,
        enabledBorderColor: _controller.isInputSharingEmpty &&
                _controller.sharingFromPairingController.text.isEmpty
            ? ColorsItem.redDA1414
            : ColorsItem.grey666B73,
      ),
    );
  }

  String _getTitle() {
    switch (_controller.data?.dailyTaskType) {
      case DailyTaskType.book:
        return S.of(context).label_daily_summary;
      case DailyTaskType.feedback:
        return S.of(context).label_daily_feedback_pairing;
      default:
        return S.of(context).label_daily_sharing_pairing;
    }
  }
}
