import SwiftUI

/// View for the OpenStreetMapp profile
struct ExistingProfileView: View {
    // MARK: Properties
    
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
    
    
    /// The publisher to know when to stop showing the Safari view for the login form
    private let stopShowingLoginPublisher = NotificationCenter.default.publisher(for: SafariView.dismissNotificationName)
    
    
    /// If the profile is being presented as an alert
    var isPresentedAsAlert: Bool = false
    
    
    /// The actual view
    var body: some View {
        VStack(alignment: .leading) {
            if Profile.needsReauthorization {
                List {
                    Text("osm_profile_reauthorize_promt")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if !isPresentedAsAlert {
                List {
                    Section {
                        VStack {
                            Text(Profile.numberOfEdits ?? 0, format: .number)
                                .font(.largeTitle)
                                .bold()
                                .frame(maxWidth: .infinity)
                            
                            Text("osm_profile_verfied_changes")
                        }
                        .padding([.top, .bottom])
                        .frame(maxWidth: .infinity)
                    } footer: {
                        if let editHistoryUrl = Profile.editHistoryUrl {
                            Button {
                                showEditHistory = true
                            } label: {
                                Text("osm_profile_view_edit_history")
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            .controlSize(.large)
                            .font(.headline)
                            .sheet(isPresented: $showEditHistory) {
                                SafariView(url: editHistoryUrl, dismissButton: .close)
                            }
                            .padding([.top, .bottom])
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    
                    if let notesUrl = Profile.notesUrl {
                        Section {
                            Button {
                                showNotes = true
                            } label: {
                                Text("osm_profile_view_notes")
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            .buttonBorderShape(.roundedRectangle(radius: 0))
                            .controlSize(.large)
                            .font(.headline)
                            .sheet(isPresented: $showNotes) {
                                SafariView(url: notesUrl, dismissButton: .close)
                            }
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
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
                            .lineLimit(1)
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
                                .lineLimit(1)
                                .foregroundStyle(.alternativeAccent)
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
