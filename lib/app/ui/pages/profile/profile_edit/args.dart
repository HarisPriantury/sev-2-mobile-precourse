import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/user.dart';

class ProfileEditArgs implements BaseArgs {
  User user;

  ProfileEditArgs({required this.user});

  @override
  String toPrint() {
    return "ProfileEditArgs data:${jsonEncode(user)}";
  }
}
