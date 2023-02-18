import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class CommentController extends SheetController {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNodeMsg = FocusNode();
  final List<Reaction> _embraceReactions = [];

  FocusNode get focusNodeMsg => _focusNodeMsg;

  TextEditingController get textEditingController => _textEditingController;

  List<Reaction> get embraceReactions => _embraceReactions;

  CommentController() : super();

  @override
  void load() {}

  @override
  void getArgs() {}

  @override
  void initListeners() {
    loading(false);
  }

  @override
  void disposing() {
    //
  }

  @override
  Future<void> reload({String? type}) {
    throw UnimplementedError();
  }
}
