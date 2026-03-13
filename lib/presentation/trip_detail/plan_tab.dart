import 'package:flutter/material.dart';

class PlanTab extends StatelessWidget {
  final String tripId;
  const PlanTab({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('План поездки скоро появится'),
    );
  }
}