import SwiftUI

/// View for the routing options
struct RoutingOptionsView: View {
    // MARK: Properties
    
    /// The dismiss action of the environment
    @Environment(\.dismiss) private var dismiss
    
    
    /// If toll roads should be avoided during routing
    @State var shouldAvoidTollRoadsWhileRouting: Bool = false
    
    
    /// If unpaved roads should be avoided during routing
    @State var shouldAvoidUnpavedRoadsWhileRouting: Bool = false
    
    
    /// If ferries should be avoided during routing
    @State var shouldAvoidFerriesWhileRouting: Bool = false
    
    
    /// If motorways should be avoided during routing
    @State var shouldAvoidMotorwaysWhileRouting: Bool = false
    
    
    /// The actual view
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("avoid_tolls", isOn: $shouldAvoidTollRoadsWhileRouting)
                        .tint(.accent)
                    
                    Toggle("avoid_unpaved", isOn: $shouldAvoidUnpavedRoadsWhileRouting)
                        .tint(.accent)
                    
                    Toggle("avoid_ferry", isOn: $shouldAvoidFerriesWhileRouting)
                        .tint(.accent)
                    
                    Toggle("avoid_motorways", isOn: $shouldAvoidMotorwaysWhileRouting)
                        .tint(.accent)
                }
            }
            .navigationTitle(String(localized: "driving_options_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("close")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            shouldAvoidTollRoadsWhileRouting = Settings.shouldAvoidTollRoadsWhileRouting
            shouldAvoidUnpavedRoadsWhileRouting = Settings.shouldAvoidUnpavedRoadsWhileRouting
            shouldAvoidFerriesWhileRouting = Settings.shouldAvoidFerriesWhileRouting
            shouldAvoidMotorwaysWhileRouting = Settings.shouldAvoidMotorwaysWhileRouting
        }
        .onChange(of: shouldAvoidTollRoadsWhileRouting) { changedShouldAvoidTollRoadsWhileRouting in
            Settings.shouldAvoidTollRoadsWhileRouting = changedShouldAvoidTollRoadsWhileRouting
        }
        .onChange(of: shouldAvoidUnpavedRoadsWhileRouting) { changedShouldAvoidUnpavedRoadsWhileRouting in
            Settings.shouldAvoidUnpavedRoadsWhileRouting = changedShouldAvoidUnpavedRoadsWhileRouting
        }
        .onChange(of: shouldAvoidUnpavedRoadsWhileRouting) { changedShouldAvoidUnpavedRoadsWhileRouting in
            Settings.shouldAvoidUnpavedRoadsWhileRouting = changedShouldAvoidUnpavedRoadsWhileRouting
        }
        .onChange(of: shouldAvoidFerriesWhileRouting) { changedShouldAvoidFerriesWhileRouting in
            Settings.shouldAvoidFerriesWhileRouting = changedShouldAvoidFerriesWhileRouting
        }
        .onChange(of: shouldAvoidMotorwaysWhileRouting) { changedShouldAvoidMotorwaysWhileRouting in
            Settings.shouldAvoidMotorwaysWhileRouting = changedShouldAvoidMotorwaysWhileRouting
        }
        .accentColor(.toolbarAccent)
    }
}
