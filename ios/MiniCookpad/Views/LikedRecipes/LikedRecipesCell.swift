 //
// Copyright © Cookpad Inc. All rights reserved.
//

import UIKit

 import Instantiate
 import InstantiateStandard
 import Kingfisher
 import UIKit

 final class LikedRecipesCell: UITableViewCell, Reusable, NibType {
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
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .systemFont(ofSize: 12)
        }
    }

    func inject(_ dependency: LikesQuery.Data.Like.Node) {
        nameLabel.text = dependency.name
        descriptionLabel.text = dependency.description
        recipeImageView.kf.setImage(with: dependency.media?.thumbnail.flatMap(URL.init(string:)))
    }
 }

