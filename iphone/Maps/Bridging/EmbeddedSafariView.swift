import SwiftUI

/// View for Safari via a WebKit view
struct EmbeddedSafariView: View {
    // MARK: Properties
    
    /// If the content is loading
    @State private var isLoading: Bool = true
    
    
    /// The view height
    @State private var height: CGFloat = .zero
    
    
    /// The url
    let url: URL
    
    
    /// If the view should resize itself to the height of the website content
    var hasDynamicHeight: Bool = true
    
    
    /// The actual view
    var body: some View {
        ZStack {
            if hasDynamicHeight {
                EmbeddedSafariViewContent(isLoading: $isLoading, height: $height, hasDynamicHeight: hasDynamicHeight, url: url)
                    .frame(height: .infinity)
                    .edgesIgnoringSafeArea(.all)
            } else {
                EmbeddedSafariViewContent(isLoading: $isLoading, height: $height, hasDynamicHeight: hasDynamicHeight, url: url)
                    .edgesIgnoringSafeArea(.all)
            }
            
            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .frame(minHeight: 100)
            }
        }
    }
}
