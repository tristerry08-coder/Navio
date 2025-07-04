import SwiftUI


/// View for the OpenStreetMap profile
struct ProfileView: View {
    // MARK: - Properties
    
    /// The dismiss action of the environment
    @Environment(\.dismiss) private var dismiss
    
    
    /// The open url action of the environment
    @Environment(\.openURL) private var openUrl
    
    
    /// The date the profile information was last updated (this is necessary for automatically refreshing the view)
    @State private var lastUpdated: Date = Date.now
    
    
    /// If the profile is being presented as an alert
    var isPresentedAsAlert: Bool = false
    
    
    /// The actual view
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isPresentedAsAlert {
                    Button {
                        dismiss()
                    } label: {
                        Label {
                            Text("close")
                        } icon: {
                            Image(systemName: "xmark.circle.fill")
                            .font(.title)
                        }
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.primary)
                    .padding([.top, .leading, .trailing])
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                if Profile.isExisting {
                    ExistingProfileView(lastUpdated: $lastUpdated, isPresentedAsAlert: isPresentedAsAlert)
                } else {
                    NoExistingProfileView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle(Profile.name ?? String(localized: "osm_profile"))
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                if !isPresentedAsAlert, Profile.isExisting, !Profile.needsReauthorization {
                    Button {
                        Profile.logout()
                        lastUpdated = Date.now
                    } label: {
                        Label("osm_profile_logout", systemImage: "rectangle.portrait.and.arrow.forward")
                    }
                }
            }
        }
        .task {
            await Profile.reload()
            withAnimation {
                lastUpdated = Date.now
            }
        }
        .tag(lastUpdated)
    }
}
