//
//  KlinkWebViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 04/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class KlinkWebViewController: UIViewController, UIWebViewDelegate {
    
    var barTitle:String?
    var url:String?
    
    init(title:String, url:String) {
        super.init(nibName: "KlinkWebViewController", bundle: nil)
        self.barTitle = title
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let webView = UIWebView()
        
        view.addSubview(webView)
        
        webView.autoPinEdgesToSuperviewEdges()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        webView.delegate = self
        self.navigationItem.setKlinkTitleView(barTitle!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIWebView Delegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
