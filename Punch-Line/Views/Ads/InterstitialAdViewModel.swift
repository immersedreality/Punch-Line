//
//  InterstitialAdViewModel.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/19/25.
//

//import GoogleMobileAds
//
//class InterstitialAdViewModel: NSObject, FullScreenContentDelegate {
//
//    private var interstitialAd: InterstitialAd?
//
//    override init() {
//        super.init()
//        Task {
//            await loadAd()
//        }
//    }
//
//    func loadAd() async {
//        let adID = APIManager.networkEnvironment == .prod ? AppConstants.adUnitID : AppConstants.testAdUnitID
//
//        do {
//            interstitialAd = try await InterstitialAd.load(with: adID, request: Request())
//            interstitialAd?.fullScreenContentDelegate = self
//        } catch {
//            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//        }
//    }
//
//    func showAd() {
//      guard let interstitialAd = interstitialAd else {
//        return print("Ad wasn't ready.")
//      }
//      interstitialAd.present(from: nil)
//    }
//
//    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
//        interstitialAd = nil
//        AppSessionManager.shouldShowAd = false
//        AppSessionManager.setAdTimer()
//        Task {
//            await loadAd()
//        }
//    }
//
//}
