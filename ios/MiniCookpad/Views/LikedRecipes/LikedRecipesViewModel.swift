//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation

protocol LikedRecipesViewModelInputs {
    func fetchLikedRecipes(after: String?)
}

protocol LikedRecipesViewModelOutputs {
    func likedRecipesFetched(_ block: @escaping (LikesQuery.Data.Like) -> Void)
    func likedRecipesFetchFailed(_ block: @escaping (Error) -> Void)
}

protocol LikedRecipesViewModelType {
    var inputs: LikedRecipesViewModelInputs { get }
    var outputs: LikedRecipesViewModelOutputs { get }
}

final class LikedRecipesViewModel: LikedRecipesViewModelType, LikedRecipesViewModelInputs, LikedRecipesViewModelOutputs {
    var inputs: LikedRecipesViewModelInputs { return self }
    var outputs: LikedRecipesViewModelOutputs { return self }
    private var _likedRecipesFetched: ((LikesQuery.Data.Like) -> Void)?
    private var _likedRecipesFetchFailed: ((Error) -> Void)?
    private var isRequesting: Bool = false

    func fetchLikedRecipes(after: String?) {
        if isRequesting { return }
        isRequesting = true

        APIClient.shared.getLikedRecipes(after: after) { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case let .success(response):
                self._likedRecipesFetched?(response)
            case let .failure(error):
                self._likedRecipesFetchFailed?(error)
            }
        }
    }

    func likedRecipesFetched(_ block: @escaping (LikesQuery.Data.Like) -> Void) {
        _likedRecipesFetched = block
    }

    func likedRecipesFetchFailed(_ block: @escaping (Error) -> Void) {
        _likedRecipesFetchFailed = block
    }
}
