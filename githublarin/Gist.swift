import Foundation
import Gloss

struct Gist: Decodable {

    let id: String
    let description: String
    let owner: User
    let isPublic: Bool?
    // let files: [GistFile]()
    let comments : Int?
    let htmlUrl: String?
    let createdAt: String?
    let updatedAt: String?

    init?(json: JSON) {
        guard let id: String = "id" <~~ json,
            let description: String = "description" <~~ json,
            let owner: User = "owner" <~~ json else { return nil }

        self.id = id
        self.description = description
        self.owner = owner
        self.isPublic = "public" <~~ json
        self.comments = "comments" <~~ json
        self.htmlUrl = "html_url" <~~ json
        self.createdAt = "created_at" <~~ json
        self.updatedAt = "updated_at" <~~ json
    }
}
