import Foundation
import google_mobile_ads
import GoogleMobileAds

class ListTileNativeAdFactory: FLTNativeAdFactory {
    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [AnyHashable: Any]? = nil
    ) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)?.first
        let adView = nibView as! GADNativeAdView
        
        // Assign the ad
        adView.nativeAd = nativeAd
        
        // Set UI elements
        (adView.headlineView as? UILabel)?.text = nativeAd.headline
        (adView.bodyView as? UILabel)?.text = nativeAd.body
        (adView.callToActionView as? UIButton)?.setTitle(
            nativeAd.callToAction,
            for: .normal
        )
        (adView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        
        // Handle media content
        if let mediaView = adView.mediaView {
            mediaView.mediaContent = nativeAd.mediaContent
        }
        
        // Style the call to action button
        if let ctaButton = adView.callToActionView as? UIButton {
            ctaButton.backgroundColor = UIColor(red: 0.26, green: 0.52, blue: 0.96, alpha: 1.0)
            ctaButton.setTitleColor(.white, for: .normal)
            ctaButton.layer.cornerRadius = 8
            ctaButton.clipsToBounds = true
        }
        
        return adView
    }
}

