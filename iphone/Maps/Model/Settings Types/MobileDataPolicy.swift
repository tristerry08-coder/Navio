extension Settings {
    /// The mobile data policy
    @objc enum MobileDataPolicy: Int, Codable, CaseIterable, Identifiable {
        case always = 1
        case ask = 2
        case never = 0
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .always:
                    return String(localized: "mobile_data_option_always")
                case .ask:
                    return String(localized: "mobile_data_option_ask")
                case .never:
                    return String(localized: "mobile_data_option_never")
                default:
                    return String()
            }
        }
    }
}
