//
//  RepositoryTableViewCell.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/31.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starredCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!

    // MARK: Properties

    var viewModel: Repository? {
        didSet {
            guard let viewModel = viewModel else { return }
            fullNameLabel.text = viewModel.fullName
            descriptionLabel.text = viewModel.description
        }
    }
}
