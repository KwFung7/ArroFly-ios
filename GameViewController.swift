//
//  GameViewController.swift
//  ArroFly
//
//  Created by Felix Kwan on 11/9/2016.
//  Copyright (c) 2016年 KwFung. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {

    /* Connect with view controller */
    @IBOutlet weak var bannerView: GADBannerView!
    
    /* Declare interstitial */
    var interstitialAd: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = NameScene(size: view.bounds.size)
        /* Configure the view */
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        /* Initialize Google Mobile Ads with app ID */
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4561364336152901~5978716479")
        
        /* Goodgle mobile ads banner setting */
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-4561364336152901/8792582074"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["b7d98a2c813a2a94777d7aad983c4a20"]

        /* Request interstitial */
        interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-4561364336152901/3686228072")
        interstitialAd.load(request)
        interstitialAd = reloadInterstitialAd()

        /* Set observer to pass function to GameScene */
        NotificationCenter.default.addObserver(self, selector: #selector(showInterstitialAd), name: NSNotification.Name(rawValue: "showAd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBanner), name: NSNotification.Name(rawValue: "showBanner"), object: nil)
    }
    
    func reloadInterstitialAd() -> GADInterstitial {
        
        /* Reload new interstitial */
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4561364336152901/3686228072")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        
        /* Preload new interstitial after previous one dismissed */
        self.interstitialAd = reloadInterstitialAd()
    }
    
    func showBanner() {
        
        bannerView.load(GADRequest())
    }
    
    func showInterstitialAd() {
        
        if interstitialAd.isReady {
            interstitialAd.present(fromRootViewController: self)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
