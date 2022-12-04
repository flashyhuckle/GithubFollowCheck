import Foundation

struct User: Decodable {
    let name: String
    let avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarURL = "avatar_url"
    }
}
