extension Settings {
    /// The type of the left bottom bar button
    enum LeftButtonType: String, Codable, CaseIterable, Identifiable {
        case hidden = "Hidden"
        case help = "Help"
        case addPlace = "AddPlace"
        case settings = "Settings"
        case recordTrack = "RecordTrack"
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .hidden:
                    return String(localized: "disabled")
                case .help:
                    return String(localized: "help")
                case .addPlace:
                    return String(localized: "placepage_add_place_button")
                case .settings:
                    return String(localized: "settings")
                case .recordTrack:
                    return String(localized: "start_track_recording")
            }
        }
        
        
        /// The image
        var image: UIImage {
            let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
            switch self {
                case .help:
                    return UIImage(systemName: "questionmark", withConfiguration: configuration)!
                case .addPlace:
                    return UIImage(systemName: "plus", withConfiguration: configuration)!
                case .settings:
                    return UIImage(systemName: "gearshape.fill", withConfiguration: configuration)!
                case .recordTrack:
                    return UIImage.MainButtons.LeftButton.recordTrack.withConfiguration(configuration)
                default:
                    return UIImage()
            }
        }
    }
}
