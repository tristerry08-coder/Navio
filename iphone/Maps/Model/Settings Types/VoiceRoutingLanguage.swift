extension Settings {
    /// A language used for voice guidance during routing
    struct VoiceRoutingLanguage: Codable, Identifiable {
        // MARK: Properties
        
        /// The id
        var id: String
        
        
        /// The localized name
        var localizedName: String
    }
}



// MARK: - Comparable
extension Settings.VoiceRoutingLanguage: Equatable {
    static func == (lhs: Settings.VoiceRoutingLanguage, rhs: Settings.VoiceRoutingLanguage) -> Bool {
        return lhs.id == rhs.id
    }
}



// MARK: - Comparable
extension Settings.VoiceRoutingLanguage: Comparable {
    static func < (lhs: Settings.VoiceRoutingLanguage, rhs: Settings.VoiceRoutingLanguage) -> Bool {
        return lhs.localizedName.localizedCaseInsensitiveCompare(rhs.localizedName) == .orderedAscending
    }
}
