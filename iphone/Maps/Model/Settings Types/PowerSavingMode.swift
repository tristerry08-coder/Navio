extension Settings {
    /// The power saving mode
    @objc enum PowerSavingMode: Int, Codable, CaseIterable, Identifiable {
        case auto = 1
        case maximum = 2
        case never = 0
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .auto:
                    return String(localized: "power_managment_setting_auto")
                case .maximum:
                    return String(localized: "power_managment_setting_manual_max")
                case .never:
                    return String(localized: "power_managment_setting_never")
                default:
                    return String()
            }
        }
    }
}
