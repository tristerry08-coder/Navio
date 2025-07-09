import SafariServices
import SwiftUI

/// View for Safari via a Safari view controller
struct SafariView: UIViewControllerRepresentable {
    // MARK: Properties
    
    /// The notification name for dismissing this view
    static let dismissNotificationName: Notification.Name = Notification.Name(rawValue: "DismissSafariView")
    
    
    /// The url
    let url: URL
    
    
    /// The type of dismiss button
    var dismissButton: SFSafariViewController.DismissButtonStyle = .done
    
    
    
    // MARK: Methods
    
    /// Create a Safari view controller
    /// - Parameter context: The context
    /// - Returns: The Safari view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariViewControllerConfiguration = SFSafariViewController.Configuration()
        safariViewControllerConfiguration.activityButton = nil
        safariViewControllerConfiguration.barCollapsingEnabled = true
        
        let safariViewController = SFSafariViewController(url: url, configuration: safariViewControllerConfiguration)
        safariViewController.preferredBarTintColor = UIColor.accent
        safariViewController.preferredControlTintColor = UIColor.white
        safariViewController.dismissButtonStyle = dismissButton
        return safariViewController
    }
    
    
    /// Update the Safari view controller
    /// - Parameter context: The context
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // Do nothing
    }
}
