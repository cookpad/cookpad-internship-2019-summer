//
// Copyright © Cookpad Inc. All rights reserved.
//

import Instantiate
import InstantiateStandard
import Kingfisher
import UIKit

final class RecipesCell: UITableViewCell, Reusable, NibType {
    @IBOutlet private weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.layer.masksToBounds = true
            recipeImageView.layer.cornerRadius = 8.0
            recipeImageView.backgroundColor = .gray
            recipeImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .boldSystemFont(ofSize: 14)
            nameLabel.textColor = .green
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .boldSystemFont(ofSize: 12)
            descriptionLabel.textColor = .black
        }
    }

    func inject(_ dependency: RecipesQuery.Data.Recipe) {
        nameLabel.text = dependency.name
        descriptionLabel.text = dependency.description
        recipeImageView.kf.setImage(with: dependency.media?.thumbnail.flatMap(URL.init(string:)))
    }
}
