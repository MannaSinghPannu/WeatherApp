//
//  VCWebView.swift
//  WeatherApp
//
//  Created by Manna Pannu on 2/2/21.
//

import UIKit


class VcHome: UIViewController {

//    private let url: URL
//    private let webView : WKWebView = {
//        let prefrences = WKWebpagePreferences()
//        prefrences.allowsContentJavaScript = true
//        let wkConfiguration = WKWebViewConfiguration()
//        wkConfiguration.defaultWebpagePreferences = prefrences
//        let webView = WKWebView(frame: .zero, configuration: wkConfiguration)
//        return webView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    private func configureNavigationUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didRefreshWebView))
    }

    @objc func didTapDone(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didRefreshWebView(){
       
    }
    
    
}
