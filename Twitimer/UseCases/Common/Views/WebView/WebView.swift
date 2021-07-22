//
//  WebView.swift
//  Twitimer
//
//  Created by Brais Moure on 19/4/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    // MARK: View
    
    let url: URL
    let selected: (URL) -> Void
    let loading: (Bool) -> Void
    
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        
        // Disable zoom
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd,
                                                forMainFrameOnly: true)
        let contentController = WKUserContentController()
        contentController.addUserScript(script)
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpShouldHandleCookies = false // Disable cookies
        webView.scrollView.delegate = context.coordinator
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Do nothing
    }
    
    // MARK: Coordinator
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selected: selected, loading: loading)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
        
        let selected: (URL) -> ()
        let loading: (Bool) -> ()
        
        init(selected: @escaping (URL) -> (), loading: @escaping (Bool) -> Void) {
            self.selected = selected
            self.loading = loading
        }
        
        // MARK: WKNavigationDelegate
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = webView.url {
                selected(url)
                if url.absoluteString.contains("code=") {
                    webView.isHidden = true
                } else {
                    webView.isHidden = false
                }
            }
            
            decisionHandler(.allow)
        }
        
        // MARK: WKUIDelegate
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loading(true)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !webView.isLoading {
                loading(false)
            }
        }
        
        // MARK: UIScrollViewDelegate
        
        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return nil
        }
        
    }
}

