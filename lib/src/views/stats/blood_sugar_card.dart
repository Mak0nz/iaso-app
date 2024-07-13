import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/card.dart';

class ExpandableBloodSugarCard extends StatefulWidget {
  final List<double> bloodSugar;

  const ExpandableBloodSugarCard({super.key, required this.bloodSugar});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableBloodSugarCardState createState() => _ExpandableBloodSugarCardState();
}

class _ExpandableBloodSugarCardState extends State<ExpandableBloodSugarCard> {
  bool _isExpanded = false;

  double get _average => widget.bloodSugar.reduce((a, b) => a + b) / widget.bloodSugar.length;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.bold('${AppLocalizations.of(context)!.blood_sugar}:'),
                Row(
                  children: [
                    Text('${_average.toStringAsFixed(1)} mg/dL'),
                    const SizedBox(width: 8,),
                    Icon(_isExpanded ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 10),
            ...widget.bloodSugar.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${entry.key + 1}: ${entry.value.toStringAsFixed(1)} mg/dL'),
              );
            }),
          ],
        ],
      ),
    );
  }
}