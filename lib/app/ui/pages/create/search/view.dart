import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ObjectSearchPage extends View {
  final Object? arguments;

  ObjectSearchPage({this.arguments});

  @override
  _ObjectSearchState createState() => _ObjectSearchState(
      AppComponent.getInjector().get<ObjectSearchController>(), arguments);
}

class _ObjectSearchState
    extends ViewState<ObjectSearchPage, ObjectSearchController> {
  ObjectSearchController _controller;

  _ObjectSearchState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ObjectSearchController>(
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
                  _controller.title == null
                      ? "Tambah Member"
                      : _controller.title!,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                suffix: GestureDetector(
                  onTap: () {
                    if (_controller.searchSelectionType ==
                            SearchSelectionType.single &&
                        (_controller.singleSelectedObject != null ||
                            _controller.isUpdate)) {
                      Navigator.of(context)
                          .pop(_controller.singleSelectedObject);
                    } else if (_controller.searchSelectionType ==
                            SearchSelectionType.multiple &&
                        (_controller.selectedObjects.length > 0 ||
                            _controller.isUpdate)) {
                      Navigator.of(context).pop(_controller.selectedObjects);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: Dimens.SPACE_16),
                    child: Text(
                      _controller.isUpdate
                          ? S.of(context).label_update
                          : S.of(context).label_add,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: _controller.selectedObjects.length > 0 ||
                                  _controller.singleSelectedObject != null ||
                                  _controller.isUpdate
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey606060),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _controller.selectedObjects.length > 0
                    ? _memberJoinedContent()
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          _controller.placeholderText == null
                              ? "Assigned to"
                              : _controller.placeholderText!,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.greyB8BBBF,
                              fontSize: Dimens.SPACE_12,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: Dimens.SPACE_12),
                      TextField(
                        onChanged: (txt) {
                          controller.streamController.add(txt);
                        },
                        controller: _controller.searchController,
                        focusNode: _controller.focusNode,
                        style: GoogleFonts.montserrat(),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_8),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73)),
                            hintStyle: GoogleFonts.montserrat(
                                color: ColorsItem.grey666B73),
                            suffixIcon: Container(
                                color: ColorsItem.grey666B73,
                                child: Icon(Icons.search,
                                    color: ColorsItem.whiteFEFEFE))),
                      ),
                      SizedBox(height: Dimens.SPACE_20),
                      _controller.searchController.text.isNotEmpty
                          ? RichText(
                              text: new TextSpan(
                                text: S.of(context).search_found_placeholder,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey8D9299),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text:
                                          '"${_controller.searchController.text}"',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: _controller.searchedObjects.isEmpty &&
                          !_controller.isLoading
                      ? EmptyList(
                          title: S.of(context).search_data_not_found_title,
                          descripton:
                              S.of(context).search_data_not_found_description)
                      : ListView.builder(
                          itemCount: _controller.searchedObjects.length,
                          itemBuilder: (context, index) {
                            var pho = _controller.searchedObjects[index];
                            return MemberItem(
                                avatar: pho.avatar!,
                                name: pho.name!,
                                fullName: pho.getFullName()!,
                                status: '',
                                icon: _controller.searchSelectionType ==
                                        SearchSelectionType.multiple
                                    ? Theme(
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: ColorsItem.orangeFB9600,
                                          onChanged: (bool? value) {
                                            _controller.onSelectObject(
                                                index, value);
                                          },
                                          value: _controller
                                              .isObjectSelected(index),
                                        ),
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors.grey,
                                        ),
                                      )
                                    : Theme(
                                        data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                ColorsItem.greyd8d8d8),
                                        child: Radio<PhObject>(
                                            value: pho,
                                            groupValue: _controller
                                                .singleSelectedObject,
                                            onChanged: (newPho) {
                                              _controller
                                                  .onSingleSelectObject(newPho);
                                            },
                                            activeColor:
                                                ColorsItem.orangeFB9600),
                                      ),
                                statusColor: ColorsItem.green219653);
                          }),
                )
              ],
            ),
          );
        }),
      );

  Widget _memberJoinedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Dimens.SPACE_20, Dimens.SPACE_20, Dimens.SPACE_20, 0.0),
          child: Text(
            _controller.title == S.of(context).create_form_participants_label ||
                    _controller.title ==
                        S.of(context).create_form_search_user_label
                ? S.of(context).label_list_participants
                : _controller.title == S.of(context).label_subscriber
                    ? S.of(context).label_list_subscribers
                    : S.of(context).label_list_tags,
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF,
                fontSize: Dimens.SPACE_12,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: Dimens.SPACE_12),
        SizedBox(
          height: MediaQuery.of(context).size.height / 14,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(
                  Dimens.SPACE_16, 0.0, Dimens.SPACE_16, 0.0),
              itemCount: _controller.selectedObjects.length,
              itemBuilder: (context, index) {
                var pho = _controller.selectedObjects[index];
                return Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_1),
                  child: CircleAvatar(
                    radius: Dimens.SPACE_25,
                    backgroundColor: ColorsItem.whiteColor,
                    child: CircleAvatar(
                      radius: Dimens.SPACE_20,
                      backgroundImage: CachedNetworkImageProvider(
                        pho.avatar!,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
