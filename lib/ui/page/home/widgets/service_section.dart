import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/constants.dart';
import 'package:toeic_desktop/ui/page/home/widgets/service_card.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Our TOEIC Preparation Services",
            style: Theme.of(context).textTheme.titleLarge!.apply(
                  fontWeightDelta: 2,
                ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Constants.services.map((service) {
            return ServiceCard(item: service);
          }).toList(),
        )
      ],
    );
  }
}
