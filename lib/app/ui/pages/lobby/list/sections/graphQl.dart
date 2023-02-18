import 'package:flutter/material.dart';
import 'package:mobile_sev2/domain/country.dart';

class GraphQlCountries extends StatelessWidget {
  final List<Country> countries;
  const GraphQlCountries(this.countries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(countries[index].name),
                Text(
                  countries[index].flagEmoji,
                ),
              ],
            );
          }),
    );
  }
}
