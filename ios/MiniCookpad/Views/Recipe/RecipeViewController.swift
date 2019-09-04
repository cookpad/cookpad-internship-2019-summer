//
// Copyright © Cookpad Inc. All rights reserved.
//

import Instantiate
import InstantiateStandard
import UIKit

final class RecipeViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.alwaysBounceVertical = true
        }
    }
    @IBOutlet private weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .systemFont(ofSize: 12)
            descriptionLabel.textColor = .black
        }
    }
    @IBOutlet private weak var recipeIDLabel: UILabel! {
        didSet {
            recipeIDLabel.font = .systemFont(ofSize: 10)
            recipeIDLabel.textColor = .darkGray
        }
    }
    @IBOutlet private weak var ingredientsStackView: UIStackView!
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .green
        label.sizeToFit()
        return label
    }()

    private lazy var viewModel: RecipeViewModelType = uninitialized()
    private var recipe: RecipeQuery.Data.Recipe?
    private var recipeIsLiked: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem?.image = makeLikeImage(isLiked: recipeIsLiked)
        }
    }
    func inject(_ dependency: String) {
        viewModel = RecipeViewModel(recipeID: dependency)
    }

    override func loadView() {
        super.loadView()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(RecipeViewController.toggleLike))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputs.recipeFetched { [weak self] recipe in
            guard let self = self else { return }
            self.recipe = recipe
            self.recipeIsLiked = recipe.isLiked
            self.titleLabel.text = recipe.name
            self.titleLabel.sizeToFit()
            self.recipeImageView.kf.setImage(with: recipe.media?.original.flatMap(URL.init(string:)))
            self.descriptionLabel.text = recipe.description
            self.recipeIDLabel.text = "レシピID: \(recipe.id)"

            recipe.ingredients?.compactMap { $0 }.enumerated().forEach { index, ingredient in
                let ingredientView = IngredientView.instantiate(with: ingredient)
                ingredientView.backgroundColor = index % 2 == 0 ? .lightGray: .white
                self.ingredientsStackView.addArrangedSubview(ingredientView)
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }

        viewModel.outputs.recipeFetchFailed { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(title: "", message: "データの取得に失敗しました。", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        viewModel.outputs.isLikedChanged { [weak self] isLiked in
            self?.recipeIsLiked = isLiked
        }
        viewModel.inputs.fetchRecipe()
    }

    private func makeLikeImage(isLiked: Bool) -> UIImage? {
        return isLiked
        ? UIImage(named: "star_fill")?.withRenderingMode(.alwaysOriginal)
            : UIImage(named: "star_blank")?.withRenderingMode(.alwaysOriginal)
    }

    @objc private func toggleLike() {
        guard let recipe = recipe else { return }
        if !recipeIsLiked {
            viewModel.inputs.addLike(to: recipe.id)
        } else {
            viewModel.inputs.deleteLike(from: recipe.id)
        }
    }
}
