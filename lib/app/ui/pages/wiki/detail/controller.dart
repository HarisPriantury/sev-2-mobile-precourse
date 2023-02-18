import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/presenter.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class DetailWikiController extends BaseController {
  DetailWikiController(this._presenter);

  WikiDetailArgs? _data;
  bool _isExpandDescription = false;
  DetailWikiPresenter _presenter;
  Wiki? _wiki;
  User? _wikiAuthor;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as WikiDetailArgs;
      _wiki = _data!.wiki;
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users, PersistenceType type) {
      _wikiAuthor = users.first;
      print("detailWiki: success getUsers $type ${users.length}");
    };
    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detailWiki: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      loading(false);
      print("detailWiki: error getUsers: $e $type");
    };
  }

  @override
  void load() {
    loading(true);
    _presenter
        .onGetUsers(GetUsersApiRequest(ids: ["${_data?.wiki.author?.id}"]));
  }

  User? get wikiAuthor => _wikiAuthor;

  Wiki? get wiki => _wiki;

  WikiDetailArgs? get data => _data;

  bool get isExpandDescription => _isExpandDescription;

  void onExpandDescription() {
    _isExpandDescription = !_isExpandDescription;
    refreshUI();
  }
}
