import 'package:flutter/material.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Debug widget to test ad loading
class AdDebugWidget extends StatelessWidget {
  const AdDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adService = injector<AdService>();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ad Debug Panel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Native Ad Status
            Row(
              children: [
                Icon(
                  adService.isNativeAdReady
                      ? Icons.check_circle
                      : Icons.error,
                  color: adService.isNativeAdReady
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Native Ad: ${adService.isNativeAdReady ? "Ready" : "Not Ready"}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Reload Buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => adService.reloadNativeAd(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload Native Ad'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => adService.reloadAppOpenAd(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload App Open Ad'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => adService.showAppOpenAdIfAvailable(),
              icon: const Icon(Icons.ad_units),
              label: const Text('Show App Open Ad'),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Check console logs for detailed ad loading status',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

