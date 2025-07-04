import SwiftUI


/// View for the OpenStreetMapp profile
struct ExistingProfileView: View {
    // MARK: - Properties
    
    /// The open url action of the environment
    @Environment(\.openURL) private var openUrl
    
    
    /// The date the profile information was last updated (this is necessary for automatically refreshing the view)
    @Binding var lastUpdated: Date
    
    
    /// If the login form should be shown in the Safari view
    @State private var showLogin: Bool = false
    
    
    /// If the edit history should be shown in the Safari view
    @State private var showEditHistory: Bool = false
    
    
    /// If the map notes should be shown in the Safari view
    @State private var showNotes: Bool = false
    
    
    /// If the profile is being presented as an alert
    var isPresentedAsAlert: Bool = false
    
    
    /// The actual view
    var body: some View {
        VStack(alignment: .leading) {
            if Profile.needsReauthorization {
                ScrollView {
                    Text("osm_profile_reauthorize_promt")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            } else if !isPresentedAsAlert {
                ScrollView {
                    VStack {
                        VStack {
                            Text(Profile.numberOfEdits ?? 0, format: .number)
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity)
                            
                            Text("osm_profile_verfied_changes")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        }
                        
                        if let editHistoryUrl = Profile.editHistoryUrl {
                            Button {
                                showEditHistory = true
                            } label: {
                                Text("osm_profile_view_edit_history")
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            .controlSize(.large)
                            .font(.headline)
                            .sheet(isPresented: $showEditHistory) {
                                SafariView(url: editHistoryUrl, dismissButton: .close)
                            }
                        }
                        
                        if let notesUrl = Profile.notesUrl {
                            Button {
                                showNotes = true
                            } label: {
                                Text("osm_profile_view_notes")
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            .controlSize(.large)
                            .font(.headline)
                            .padding(.top)
                            .sheet(isPresented: $showNotes) {
                                SafariView(url: notesUrl, dismissButton: .close)
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await Profile.reload()
                    withAnimation {
                        lastUpdated = Date.now
                    }
                }
            }
            
            Spacer(minLength: 0)
            
            VStack {
                if Profile.needsReauthorization {
                    Button {
                        showLogin = true
                    } label: {
                        Text("osm_profile_reauthorize")
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .controlSize(.large)
                    .font(.headline)
                    .sheet(isPresented: $showLogin) {
                        SafariView(url: Profile.authorizationUrl, dismissButton: .cancel)
                    }
                    
                    Divider()
                    .padding([.top, .bottom])
                    
                    VStack(alignment: .leading) {
                        Text("osm_profile_remove_promt")
                        
                        Button {
                            Profile.logout()
                            lastUpdated = Date.now
                        } label: {
                            Text("osm_profile_remove")
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .controlSize(.large)
                        .font(.headline)
                    }
                } else if !isPresentedAsAlert {
                    Button {
                        if let wikiUrl = URL(string: String(localized: "osm_more_about_url")) {
                            openUrl(wikiUrl)
                        }
                    } label: {
                        Text("osm_more_about")
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .controlSize(.large)
                    .font(.headline)
                }
            }
            .padding([.bottom, .leading, .trailing])
        }
    }
}
