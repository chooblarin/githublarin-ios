//
//  Repository.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/31.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import Foundation
import Gloss

struct Repository: Decodable {

    let id: Int
    let name: String
    let fullName: String
    let description: String?

    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let name: String = "name" <~~ json,
            let fullName: String = "fullName" <~~ json
            else { return nil }

        self.id = id
        self.name = name
        self.fullName = fullName

        self.description = "description" <~~ json
    }
}
