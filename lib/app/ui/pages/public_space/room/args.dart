import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class PublicSpaceRoomArgs implements BaseArgs {
  Workspace workspace;
  String? from;

  PublicSpaceRoomArgs(this.workspace, {this.from});

  @override
  String toPrint() {
    return "PublicSpaceRoomArgs data: public space ${jsonEncode(workspace.publicSpace)}";
  }
}
