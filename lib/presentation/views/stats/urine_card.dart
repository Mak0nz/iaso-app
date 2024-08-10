import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/card.dart';

class ExpandableUrineCard extends StatefulWidget {
  final List<double> urine;

  const ExpandableUrineCard({super.key, required this.urine});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableUrineCardState createState() => _ExpandableUrineCardState();
}

class _ExpandableUrineCardState extends State<ExpandableUrineCard> {
  bool _isExpanded = false;

  double get _average =>
      widget.urine.reduce((a, b) => a + b) / widget.urine.length;

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
                AppText.bold('${AppLocalizations.of(context)!.urine}:'),
                Row(
                  children: [
                    Text('${_average.toStringAsFixed(1)} mL'),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(_isExpanded
                        ? FontAwesomeIcons.angleUp
                        : FontAwesomeIcons.angleDown),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 10),
            ...widget.urine.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                    '${entry.key + 1}: ${entry.value.toStringAsFixed(1)} °C'),
              );
            }),
          ],
        ],
      ),
    );
  }
}
