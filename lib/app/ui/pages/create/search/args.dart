import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class ObjectSearchArgs implements BaseArgs {
  String objectType;
  String title;
  String placeholderText;
  SearchSelectionType type;
  List<PhObject>? selectedBefore;

  ObjectSearchArgs(this.objectType,
      {required this.title, required this.placeholderText, this.type = SearchSelectionType.multiple, this.selectedBefore});

  @override
  String toPrint() {
    return "DetailArgs data: $title, $placeholderText}";
  }
}

enum SearchSelectionType { single, multiple }
