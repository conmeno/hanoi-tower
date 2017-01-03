//
//  ViewController.swift
//  Hanio Tower
//
//  Created by admin on 2016/12/2.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ViewController: BaseViewController,GADBannerViewDelegate, GADInterstitialDelegate {
    
    lazy var cards: SwipeableCards = SwipeableCards()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardsWidth = screenWidth * 0.8
        let cardsHeight = cardsWidth * 1.2
        cards.frame = CGRect(x: screenWidth * 0.1, y: (screenHeight - cardsHeight) * 0.5, width: cardsWidth, height: cardsHeight)
        view.addSubview(cards)
        cards.offset = (CardsConst.offset.x, CardsConst.offset.y)
        cards.showedCyclically = false
        cards.numberOfVisibleItems = HanioConst.limitedDisks
        cards.dataSource = self
        cards.delegate = self
        
        
        
        let myad = MyAd(root: self)
        myad.ViewDidload()
        if(Utility.isAd2)
        {
            setupDidload()
        }
        
        
    

    }
    @IBAction func MoreGameClick(_ sender: Any) {
        Utility.MoreGame()
    }

    @IBAction func MoreGameHover(_ sender: Any) {
        Utility.OpenView(viewName: "AdView1",view: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    //Begin FOR GOOGLE AD BANNER
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    var timerVPN:Timer?
    var gBannerView: GADBannerView!
    func setupDidload()
    {
        
        
        ShowAdmobBanner()
        self.timerVPN = Timer.scheduledTimer(timeInterval: 20, target: self, selector: Selector(("timerVPNMethodAutoAd:")), userInfo: nil, repeats: true)
        
        
    }
    func ShowAdmobBanner()
    {
        
        //let viewController = appDelegate1.window!.rootViewController as! GameViewController
        let w = self.view.bounds.width
        let h = self.view.bounds.height
        //        if(!AdmobBannerTop)
        //        {
        //            AdmobLocationY = h - 50
        //        }
        gBannerView = GADBannerView(frame: CGRect(x:0,y:( h - 50) ,width: w,height: 50))
        gBannerView?.adUnitID = Utility.GBannerAdUnit
        print(Utility.GBannerAdUnit)
        gBannerView?.delegate = self
        gBannerView?.rootViewController = self
        self.view?.addSubview(gBannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID , Utility.AdmobTestDeviceID];
        gBannerView?.load(request)
        //gBannerView?.hidden = true
        
    }
    func CanShowAd()->Bool
    {
        if(!Utility.CheckVPN)
        {
            return true
        }else
        {
            let abc = cclass()
            let VPN = abc.isVPNConnected()
            let Version = abc.platformNiceString()
            if(VPN == false && Version == "CDMA")
            {
                return false
            }
        }
        
        return true
        
    }
    func timerVPNMethodAutoAd(timer:Timer) {
        print("VPN Checking....")
        let isAd = CanShowAd()
        if(isAd && Utility.isStopAdmobAD)
        {
            
            ShowAdmobBanner()
            Utility.isStopAdmobAD = false
            print("Reopening Ad from admob......")
        }
        if(isAd == false && Utility.isStopAdmobAD == false)
        {
            gBannerView.removeFromSuperview()
            Utility.isStopAdmobAD = true;
            print("Stop showing Ad from admob......")
        }
        
        
    }
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    //ENDING FOR GOOGLE AD
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    ///=====================================================================================
    
}

extension ViewController: SwipeableCardsDataSource, SwipeableCardsDelegate {
    func numberOfTotalCards(in cards: SwipeableCards) -> Int {
        return HanioConst.limitedDisks
    }
    func view(for cards: SwipeableCards, index: Int, reusingView: UIView?) -> UIView {
        var hanioScene = reusingView as? HanioScene
        if hanioScene == nil {
            let count = HanioConst.limitedDisks
            let countF = CGFloat(count)
            let width = cards.frame.size.width - CardsConst.offset.x *  (countF - 1)
            let height = cards.frame.size.height - CardsConst.offset.y *  (countF - 1)
            let frame = CGRect(x: 0, y: 0, width: width , height: height)
            hanioScene = HanioScene(frame: frame)
            hanioScene?.layer.cornerRadius = 10
        }
        if index == 0 {
            hanioScene?.disks = index + 1
        }
        hanioScene?.tag = index
        hanioScene?.layer.backgroundColor = CardsConst.colors[index].cgColor
        return hanioScene!
    }
    func cards(_ cards: SwipeableCards, didRemovedItemAt index: Int) {
        let i = (index + 1) % HanioConst.limitedDisks
        if let hanioScene = cards.viewWithTag(i) as? HanioScene {
            hanioScene.disks = i + 1
        }
        guard index == HanioConst.limitedDisks - 1 else { return }
        run(after: 0.2) {
            cards.reloadData()
        }
    }
   

}
