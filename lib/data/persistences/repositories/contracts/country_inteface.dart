import 'package:mobile_sev2/domain/country.dart';

abstract class CountryRepository {
  Future<List<Country>> getCountries(Map<String, dynamic> params);
}
