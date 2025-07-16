import SwiftUI

/// View for the OpenStreetMapp profile
struct NoExistingProfileView: View {
    // MARK: Properties
    
    /// The open url action of the environment
    @Environment(\.openURL) private var openUrl
    
    
    /// If the login form should be shown in the Safari view
    @State private var showLogin: Bool = false
    
    
    /// The publisher to know when to stop showing the Safari view for the login form
    private let stopShowingLoginPublisher = NotificationCenter.default.publisher(for: SafariView.dismissNotificationName)
    
    
    /// The actual view
    var body: some View {
        VStack(alignment: .leading) {
            List {
                VStack(alignment: .leading) {
                    Text("osm_profile_promt")
                        .font(.headline)
                    
                    HStack(alignment: .top) {
                        Image(.openStreetMapLogo)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: 50)
                            .padding(.top, 6)
                        
                        Text("osm_profile_explanation")
                            .tint(.alternativeAccent)
                    }
                }
                .padding(.bottom, 8)
            }
            
            Spacer(minLength: 0)
            
            VStack {
                VStack {
                    Button {
                        showLogin = true
                    } label: {
                        Text("osm_profile_login")
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .controlSize(.large)
                    .font(.headline)
                    .sheet(isPresented: $showLogin) {
                        SafariView(url: Profile.authorizationUrl, dismissButton: .cancel)
                    }
                }
                
                Divider()
                    .padding([.top, .bottom])
                
                VStack(alignment: .leading) {
                    Text("osm_profile_register_promt")
                    
                    Button {
                        openUrl(Profile.registrationUrl)
                    } label: {
                        Text("osm_profile_register")
                            .lineLimit(1)
                            .foregroundStyle(.alternativeAccent)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .controlSize(.large)
                    .font(.headline)
                }
            }
            .padding([.bottom, .leading, .trailing])
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .onReceive(stopShowingLoginPublisher) { _ in
            showLogin = false
        }
    }
}
