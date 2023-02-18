import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/country_inteface.dart';
import 'package:mobile_sev2/domain/country.dart';

class GetCountriesUseCase extends UseCase<List<Country>, Map<String, dynamic>> {
  CountryRepository _repository;
  GetCountriesUseCase(this._repository);
  @override
  Future<Stream<List<Country>?>> buildUseCaseStream(
      Map<String, dynamic>? params) async {
    final StreamController<List<Country>> _controller = StreamController();
    try {
      List<Country> countries = await _repository.getCountries(params!);
      _controller.add(countries);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
