import Foundation
import Gloss

struct FeedResponse: Decodable {

    let currentUserUrl: String

    init?(json: JSON) {
        print(json)
        guard let currentUserUrl: String = "current_user_url" <~~ json else { return nil }

        self.currentUserUrl = currentUserUrl
    }
}
