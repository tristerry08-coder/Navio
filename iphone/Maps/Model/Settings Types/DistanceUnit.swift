extension Settings {
    /// The unit system used for distances
    @objc enum DistanceUnit: Int, Codable, CaseIterable, Identifiable {
        case metric = 0
        case imperial = 1
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .metric:
                    return String(localized: "kilometres")
                case .imperial:
                    return String(localized: "miles")
                default:
                    return String()
            }
        }
    }
}
