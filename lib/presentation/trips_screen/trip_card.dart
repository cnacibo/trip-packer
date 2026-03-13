import 'package:flutter/material.dart';
import 'package:trip_packer/presentation/trip_detail/trip_detail_screen.dart';
import 'package:trip_packer/domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final dynamic trip; 

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final startDay = trip.startDate.day.toString().padLeft(2, '0');
    final startMonth = _getMonthName(trip.startDate.month);
    final endDay = trip.endDate.day.toString().padLeft(2, '0');
    final endMonth = _getMonthName(trip.endDate.month);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripDetailScreen(tripId: trip.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TripDetailScreen(tripId: trip.id),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getColorForType(trip.tripType).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getIconForType(trip.tripType),
                        size: 32,
                        color: _getColorForType(trip.tripType),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  trip.destination,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: colorScheme.primary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$startDay $startMonth — $endDay $endMonth',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return months[month - 1];
  }

  Color _getColorForType(TripType type) {
    switch (type) {
      case TripType.beach:
        return const Color(0xFF4FC3F7); 
      case TripType.mountains:
        return const Color(0xFF66BB6A);
      case TripType.city:
        return const Color(0xFFFFA726); 
      case TripType.business:
        return const Color(0xFF7E57C2);
      case TripType.other:
        return const Color(0xFFEC407A); 
    }
  }

  IconData _getIconForType(TripType type) {
    switch (type) {
      case TripType.beach:
        return Icons.beach_access;
      case TripType.mountains:
        return Icons.terrain;
      case TripType.city:
        return Icons.location_city;
      case TripType.business:
        return Icons.business_center;
      case TripType.other:
        return Icons.place;
    }
  }
}