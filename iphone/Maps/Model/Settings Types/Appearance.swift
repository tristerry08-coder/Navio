extension Settings {
    /// The visual appeareance
    @objc enum Appearance: Int, Codable, CaseIterable, Identifiable {
        case auto = 1
        case light = 2
        case dark = 3
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .auto:
                    return String(localized: "auto")
                case .light:
                    return String(localized: "pref_appearance_light")
                case .dark:
                    return String(localized: "pref_appearance_dark")
                default:
                    return String()
            }
        }
    }
}
