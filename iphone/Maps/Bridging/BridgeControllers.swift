import SwiftUI
import UIKit

/// Class for accesing SwiftUI views from Objective-C code
@objc class BridgeControllers: NSObject {
    /// The `ProfileView` for presentation in an alert
    @objc static func profileAsAlert() -> UIViewController {
        let profileBridgeController = UIHostingController(rootView: ProfileView(isPresentedAsAlert: true))
        profileBridgeController.view.backgroundColor = .systemGroupedBackground
        return profileBridgeController
    }
}



/// Class for using the SwiftUI `SettingsView` in the interface builder
class SettingsBridgeController: UIHostingController<SettingsView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsView())
    }
}



/// Class for using the SwiftUI `ProfileView` in the interface builder
class ProfileBridgeController: UIHostingController<ProfileView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ProfileView())
        self.view.tintColor = .alternativeAccent
    }
}
