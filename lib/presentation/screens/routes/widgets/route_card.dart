// lib/presentation/screens/routes/widgets/route_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitec_assessment/presentation/screens/routes/widgets/country_flag.dart';
import '../../../../data/models/route_model.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;

  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ),
              child: CachedNetworkImage(
                imageUrl: route.coverImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.directions_bike_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              route.origin,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CountryFlag(countryCode: route.countryCode),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              height: 16,
                              width: 0.5,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  route.averageRating.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              route.duration < 1
                                  ? '${(route.duration * 60).toStringAsFixed(0)}m'
                                  : '${route.duration.toStringAsFixed(2)}h',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          height: 16,
                          width: 0.5,
                          color: Colors.black,
                        ),
                        // // Rating
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.money_dollar,
                              size: 16,
                            ),
                            Text(
                              route.price.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          height: 16,
                          width: 0.5,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.sync_alt_rounded, size: 16),
                            const SizedBox(width: 4,),
                            Text(
                              '${route.distance.toStringAsFixed(2)}km',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
