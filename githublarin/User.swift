import Foundation
import Gloss

struct User: Decodable {
    let id: Int
    let login: String
    let name: String?
    let email: String?
    let avatarUrl: String?
    let location: String?
    let createdAt: String // TODO: date
    let updatedAt: String // TODO: date
    let following: Int
    let followers: Int

    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let login: String = "login" <~~ json else { return nil }

        self.id = id
        self.login = login
        self.name = "name" <~~ json
        self.email = "email" <~~ json
        self.avatarUrl = "avatar_url" <~~ json
        self.location = "location" <~~ json
        self.createdAt = "created_at" <~~ json ?? ""
        self.updatedAt = "updated_at" <~~ json ?? ""
        self.following = "following" <~~ json ?? 0
        self.followers = "followers" <~~ json ?? 0
    }
}
