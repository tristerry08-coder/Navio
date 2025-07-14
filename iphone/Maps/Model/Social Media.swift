import SwiftUI

enum SocialMedia: CaseIterable, Identifiable {
    case codeberg
    case mastodon
    case lemmy
    case matrix
    case telegram
    case bluesky
    case linkedin
    case instagram
    case facebook
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
            case .lemmy:
                return String(localized: "social_lemmy")
            case .matrix:
                return String(localized: "social_matrix")
            case .telegram:
                return String(localized: "social_telegram")
            case .bluesky:
                return String(localized: "social_bluesky")
            case .linkedin:
                return String(localized: "social_linkedin")
            case .instagram:
                return String(localized: "social_instagram")
            case .facebook:
                return String(localized: "social_facebook")
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
            case .lemmy:
                return URL(string: "https://sopuli.xyz/c/CoMaps")!
            case .matrix:
                return URL(string: "https://matrix.to/#/#comaps:matrix.org")!
            case .telegram:
                return URL(string: String(localized: "telegram_url"))!
            case .bluesky:
                return URL(string: "https://bsky.app/profile/comaps.app")!
            case .linkedin:
                return URL(string: "https://www.linkedin.com/company/comapsapp/")!
            case .instagram:
                return URL(string: String(localized: "instagram_url"))!
            case .facebook:
                return URL(string: "https://www.facebook.com/CoMapsApp/")!
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
            case .lemmy:
                return Image(.SocialMedia.lemmy)
            case .matrix:
                return Image(.SocialMedia.matrix)
            case .telegram:
                return Image(.SocialMedia.telegram)
            case .bluesky:
                return Image(.SocialMedia.bluesky)
            case .linkedin:
                return Image(.SocialMedia.linkedIn)
            case .instagram:
                return Image(.SocialMedia.instagram)
            case .facebook:
                return Image(.SocialMedia.facebook)
            case .email:
                return Image(systemName: "envelope.fill")
        }
    }
}
