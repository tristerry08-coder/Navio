import SwiftUI

enum SocialMedia: CaseIterable, Identifiable {
    case codeberg
    case mastodon
    case matrix
    case lemmy
    case bluesky
    case pixelfed
    case email
    
    
    
    // MARK: Properties
    
    /// The e-mail address
    static let emailAddress: String = "ios@comaps.app"
    
    
    //// The id
    var id: Self { self }
    
    
    /// The description text
    var description: String {
        switch self {
            case .codeberg:
                return String(localized: "social_codeberg")
            case .mastodon:
                return String(localized: "social_mastodon")
            case .matrix:
                return String(localized: "social_matrix")
            case .lemmy:
                return String(localized: "social_lemmy")
            case .bluesky:
                return String(localized: "social_bluesky")
            case .pixelfed:
                return String(localized: "social_pixelfed")
            case .email:
                return String(localized: "social_email")
        }
    }
    
    
    /// The url
    var url: URL {
        switch self {
            case .codeberg:
                return URL(string: "https://codeberg.org/comaps/")!
            case .mastodon:
                return URL(string: "https://floss.social/@CoMaps")!
            case .matrix:
                return URL(string: "https://matrix.to/#/#comaps:matrix.org")!
            case .lemmy:
                return URL(string: "https://sopuli.xyz/c/CoMaps")!
            case .bluesky:
                return URL(string: "https://bsky.app/profile/comaps.app")!
            case .pixelfed:
                return URL(string: "https://pixelfed.social/CoMaps")!
            case .email:
                return URL(string: "mailto:\(SocialMedia.emailAddress)")!
        }
    }
    
    
    /// The image text
    var image: Image {
        switch self {
            case .codeberg:
                return Image(.SocialMedia.codeberg)
            case .mastodon:
                return Image(.SocialMedia.mastodon)
            case .matrix:
                return Image(.SocialMedia.matrix)
            case .lemmy:
                return Image(.SocialMedia.lemmy)
            case .bluesky:
                return Image(.SocialMedia.bluesky)
            case .pixelfed:
                return Image(.SocialMedia.pixelfed)
            case .email:
                return Image(systemName: "envelope.fill")
        }
    }
}
