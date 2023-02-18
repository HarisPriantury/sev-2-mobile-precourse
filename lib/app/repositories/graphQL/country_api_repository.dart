import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_sev2/app/infrastructures/graphQl/graphql_api_client.dart';
import 'package:mobile_sev2/app/infrastructures/graphQl/queries.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/country_inteface.dart';
import 'package:mobile_sev2/domain/country.dart';

class CountryApiRepository implements CountryRepository {
  final GraphQLApiClient _client;
  CountryApiRepository(this._client);
  @override
  Future<List<Country>> getCountries(Map<String, dynamic> params) async {
    final QueryResult result = await _client.query(
      gql(QueriesConstants.countriesQuery),
      params,
    );
    if (result.data != null) return _mapCountry(result.data!);
    return [];
  }

  List<Country> _mapCountry(Map<String, dynamic> response) {
    var countries = List<Country>.empty(growable: true);
    var data = response["countries"];
    for (var country in data) {
      var countryData = Country(
        country["emoji"],
        country["name"],
      );
      countries.add(countryData);
    }
    return countries;
  }
}
