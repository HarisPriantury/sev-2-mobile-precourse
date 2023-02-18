import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/data/infrastructures/encrypter_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockEncrypter extends Mock implements EncrypterInterface {
  @override
  String encrypt(String str) {
    return str;
  }

  @override
  String decrypt(String str) {
    return str;
  }
}

class MockUserData extends UserData {
  final String workspace;

  MockUserData(
    EncrypterInterface encrypter,
    this.workspace,
  ) : super(encrypter) {
    SharedPreferences.setMockInitialValues({
      AppConstants.USER_DATA_WORKSPACE: workspace,
    });
  }
}
