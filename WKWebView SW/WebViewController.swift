//
//  WebViewController.swift
//  WKWebView SW
//
//  Created by Marentilo on 02.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var operUrl : String
    var isSite = false
    
    init(url : String, isSite : Bool) {
        operUrl = url
        self.isSite = isSite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.operUrl = "nil"
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private let indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = UIColor.blue
        view.hidesWhenStopped = true
        return view
    } ()
    
    private let webView : WKWebView = {
        let view = WKWebView()
        return view
    } ()
    
    lazy var backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(backButtonPressed(sender:)))
        return button
    } ()
    
    lazy var forwardButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(forwardButtonPressed(sender:)))
        return button
    } ()
    
    lazy var refreshButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed(sender:)))
        return button
    } ()
    
    private let toolbar : UIToolbar = {
        let bar = UIToolbar()
        return bar
    }()
    
    func setupView () {
        webView.navigationDelegate = self
        reshreshButtons()
        navigationItem.title = operUrl
        toolbar.setItems([backButton, forwardButton, refreshButton], animated: true)
        
        let url = isSite ? getSiteURL(withCite: operUrl) : Bundle.main.url(forResource: operUrl, withExtension: "pdf")
        
        if let handleUrl = url {
            webView.load(URLRequest(url: handleUrl))
        }
            
        [
            webView,
            indicator,
            toolbar
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupConstrains()
    }
    
    func setupConstrains() {
        let constrains = [
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    func reshreshButtons () {
        forwardButton.isEnabled = webView.canGoForward
        backButton.isEnabled = webView.canGoBack
    }
    
    // MARK: - Actions
    
    @objc func refreshButtonPressed(sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @objc func forwardButtonPressed(sender: UIBarButtonItem) {
            webView.goForward()
    }
    
    @objc func backButtonPressed(sender: UIBarButtonItem) {
            webView.goBack()
    }
    
}



//MARK: URL

extension WebViewController  {
    struct Constants {
        static let scheme = "https"
        static let host = "www."
        static let domainZone = ".com"
    }
    
    func getSiteURL(withCite cite: String) -> URL? {
        let components = NSURLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host + cite + Constants.domainZone
        return components.url
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        reshreshButtons()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        reshreshButtons()
    }
    
}
