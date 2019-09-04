//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation

protocol RecipeViewModelInputs {
    func fetchRecipe()
    func addLike(to recipeID: String)
    func deleteLike(from recipeID: String)
}

protocol RecipeViewModelOutputs {
    func recipeFetched(_ block: @escaping (RecipeQuery.Data.Recipe) -> Void)
    func recipeFetchFailed(_ block: @escaping (Error) -> Void)
    func isLikedChanged(_ block: @escaping (Bool) -> Void)
    func isLikedChangeFailed(_ block: @escaping (Error) -> Void)
}

protocol RecipeViewModelType {
    init(recipeID: String)
    var inputs: RecipeViewModelInputs { get }
    var outputs: RecipeViewModelOutputs { get }
}

final class RecipeViewModel: RecipeViewModelType, RecipeViewModelInputs, RecipeViewModelOutputs {
    var inputs: RecipeViewModelInputs { return self }
    var outputs: RecipeViewModelOutputs { return self }
    private var _recipeFetched: ((RecipeQuery.Data.Recipe) -> Void)?
    private var _recipeFetchFailed: ((Error) -> Void)?
    private var _isLikedChanged: ((Bool) -> Void)?
    private var _isLikedChangeFailed: ((Error) -> Void)?
    private let recipeID: String

    init(recipeID: String) {
        self.recipeID = recipeID
    }

    func fetchRecipe() {
        APIClient.shared.getRecipe(recipeID: recipeID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(recipe):
                self._recipeFetched?(recipe)
            case let .failure(error):
                self._recipeFetchFailed?(error)
            }
        }
    }

    func addLike(to recipeID: String) {
        APIClient.shared.addLike(to: recipeID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(isLiked):
                self._isLikedChanged?(isLiked)
            case let .failure(error):
                self._isLikedChangeFailed?(error)
            }
        }
    }

    func deleteLike(from recipeID: String) {
        APIClient.shared.deleteLike(from: recipeID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(isLiked):
                print(isLiked)
                self._isLikedChanged?(isLiked)
            case let .failure(error):
                self._isLikedChangeFailed?(error)
            }
        }
    }

    func recipeFetched(_ block: @escaping (RecipeQuery.Data.Recipe) -> Void) {
        _recipeFetched = block
    }

    func recipeFetchFailed(_ block: @escaping (Error) -> Void) {
        _recipeFetchFailed  = block
    }

    func isLikedChanged(_ block: @escaping (Bool) -> Void) {
        _isLikedChanged = block
    }

    func isLikedChangeFailed(_ block: @escaping (Error) -> Void) {
        _isLikedChangeFailed = block
    }

}
