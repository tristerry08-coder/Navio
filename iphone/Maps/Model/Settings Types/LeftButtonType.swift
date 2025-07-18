extension Settings {
    /// The type of the left bottom bar button
    enum LeftButtonType: String, Codable, CaseIterable, Identifiable {
        case hidden = "Hidden"
        case addPlace = "AddPlace"
        case recordTrack = "RecordTrack"
        case settings = "Settings"
        case help = "Help"
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .hidden:
                    return String(localized: "disabled")
                case .addPlace:
                    return String(localized: "placepage_add_place_button")
                case .recordTrack:
                    return String(localized: "start_track_recording")
                case .settings:
                    return String(localized: "settings")
                case .help:
                    return String(localized: "help")
            }
        }
        
        
        /// The image
        var image: UIImage {
            let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
            switch self {
                case .addPlace:
                    return UIImage(systemName: "plus", withConfiguration: configuration)!
                case .recordTrack:
                    return UIImage.MainButtons.LeftButton.recordTrack.withConfiguration(configuration)
                case .settings:
                    return UIImage(systemName: "gearshape.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))!
                case .help:
                    return UIImage(systemName: "info.circle", withConfiguration: configuration)!
                default:
                    return UIImage()
            }
        }
    }
}
