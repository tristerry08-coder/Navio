import UIKit
import SwiftUI


/// Class for accesing SwiftUI views from Objective-C code
@objc class BridgeControllers: NSObject {
    /// The `ProfileView`
    @objc static func profile() -> UIViewController {
        return UIHostingController(rootView: ProfileView())
    }
    
    /// The `ProfileView` for presentation in an alert
    @objc static func profileAsAlert() -> UIViewController {
        return UIHostingController(rootView: ProfileView(isPresentedAsAlert: true))
    }
}


/// Class for using the SwiftUI `ProfileView` in the interface builder
class ProfileBridgeController: UIHostingController<ProfileView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ProfileView())
    }
}
