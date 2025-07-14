import WebKit

/// Coordinator of the view for Safari via a WebKit view
class EmbeddedSafariViewCoordinator: NSObject {
    // MARK: Properties
    
    /// The content
    var content: EmbeddedSafariViewContent
    
    
    // MARK: Initialization
    
    /// Initalize the coordinator with the matching content
    /// - Parameter content: The content
    init(_ content: EmbeddedSafariViewContent) {
        self.content = content
    }
}



// MARK: - `WKNavigationDelegate`
extension EmbeddedSafariViewCoordinator: WKNavigationDelegate {
    // MARK: Methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.isLoading == false {
            self.content.isLoading = false
            
            if content.hasDynamicHeight {
                webView.evaluateJavaScript(
                    "document.body.scrollHeight",
                    completionHandler: { (result, error) in
                        if let height = result as? CGFloat {
                            self.content.height = height
                        }
                    })
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString.starts(with: "file:///") {
                decisionHandler(.allow)
                return
            } else if navigationAction.navigationType == .linkActivated {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}
