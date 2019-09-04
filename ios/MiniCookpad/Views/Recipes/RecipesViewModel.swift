//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation

protocol RecipesViewModelInputs {
    func fetchRecipes(page: Int)
}

protocol RecipesViewModelOutputs {
    func recipesFetched(_ block: @escaping ([RecipesQuery.Data.Recipe], Int) -> Void)
    func recipesFetchFailed(_ block: @escaping (Error) -> Void)
}

protocol RecipesViewModelType {
    var inputs: RecipesViewModelInputs { get }
    var outputs: RecipesViewModelOutputs { get }
}

final class RecipesViewModel: RecipesViewModelType, RecipesViewModelInputs, RecipesViewModelOutputs {
    var inputs: RecipesViewModelInputs { return self }
    var outputs: RecipesViewModelOutputs { return self }
    private var _recipesFetched: (([RecipesQuery.Data.Recipe], Int) -> Void)?
    private var _recipesFetchFailed: ((Error) -> Void)?
    private var isRequesting: Bool = false

    func fetchRecipes(page: Int) {
        if isRequesting { return }
        isRequesting = true

        APIClient.shared.getRecipes(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case let .success(recipes):
                self._recipesFetched?(recipes, page)
            case let .failure(error):
                self._recipesFetchFailed?(error)
            }
        }
    }

    func recipesFetched(_ block: @escaping ([RecipesQuery.Data.Recipe], Int) -> Void) {
        _recipesFetched = block
    }

    func recipesFetchFailed(_ block: @escaping (Error) -> Void) {
        _recipesFetchFailed = block
    }

}
