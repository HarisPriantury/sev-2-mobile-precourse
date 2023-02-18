import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class MediaArgs implements BaseArgs {
  MediaType type;
  String url;
  String title;

  MediaArgs({
    required this.type,
    required this.url,
    required this.title,
  });

  @override
  String toPrint() {
    return "MediaArgs data: $type $url $title";
  }
}

enum MediaType { image, video }
