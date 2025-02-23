import 'package:flutter/material.dart';
import 'package:vitec_assessment/core/utils/helpers.dart';

class CountryFlag extends StatelessWidget {
  final String countryCode;

  const CountryFlag({
    super.key,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      getFlagEmoji(countryCode),
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

 
}