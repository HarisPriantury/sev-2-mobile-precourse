import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/domain/mood.dart';

abstract class MoodRepository {
  Future<List<Mood>> findAll(GetMoodsRequestInterface params);
  Future<bool> sendMood(SendMoodRequestInterface request);
}
