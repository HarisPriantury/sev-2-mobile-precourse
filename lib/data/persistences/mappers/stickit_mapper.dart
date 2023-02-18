import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/user.dart';

class StickitMapper{
  DateUtilInterface _dateUtil;

  StickitMapper(this._dateUtil);
  List<Stickit> convertGetStickitsApiResponse(Map<String, dynamic> response) {
    var stickits = List<Stickit>.empty(growable: true);

    var data = response['result']['data'];
    for (var st in data) {
      var stickit = Stickit(
        st['phid'],
        User(
          st['fields']['owner']['phid'],
          name: st['fields']['owner']['username'],
          fullName: st['fields']['owner']['fullname'],
          avatar: st['fields']['owner']['profileImageURI'],
        ),
        st['fields']['noteType'],
        st['fields']['content'],
        st['fields']['htmlContent'],
        st['fields']['seenCount'],
        _dateUtil.fromSeconds(st['fields']['dateCreated']),
        name: st['fields']['title'],
      );

      var spectators = List<User>.empty(growable: true);
      st['fields']['seenProfile'].forEach((p) {
        spectators.add(User(p['phid'],
            name: p['username'],
            fullName: p['fullname'],
            avatar: p['profileImageURI']));
      });

      stickit.spectators = spectators;
      stickits.add(stickit);
    }
    return stickits;
  }
}
