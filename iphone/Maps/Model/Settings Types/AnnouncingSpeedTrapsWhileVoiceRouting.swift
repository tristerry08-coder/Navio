extension Settings {
    /// The announcing of speed traps for voice guidance during routing
    @objc enum AnnouncingSpeedTrapsWhileVoiceRouting: Int, Codable, CaseIterable, Identifiable {
        case always = 1
        case onlyWhenTooFast = 2
        case never = 0
        
        
        
        // MARK: Properties
        
        /// The id
        var id: Self { self }
        
        
        /// The description text
        var description: String {
            switch self {
                case .always:
                    return String(localized: "pref_tts_speedcams_always")
                case .onlyWhenTooFast:
                    return String(localized: "pref_tts_speedcams_auto")
                case .never:
                    return String(localized: "pref_tts_speedcams_never")
                default:
                    return String()
            }
        }
    }
}
