//
// Copyright © Cookpad Inc. All rights reserved.
//

import Instantiate
import InstantiateStandard
import UIKit

final class IngredientView: UIView, NibInstantiatable {
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .systemFont(ofSize: 12)
            nameLabel.textColor = .black
        }
    }
    @IBOutlet private weak var quantityLabel: UILabel! {
        didSet {
            quantityLabel.font = .systemFont(ofSize: 12)
            quantityLabel.textColor = .black
        }
    }

    func inject(_ dependency: RecipeQuery.Data.Recipe.Ingredient) {
        nameLabel.text = dependency.name
        quantityLabel.text = dependency.quantity
    }
}
