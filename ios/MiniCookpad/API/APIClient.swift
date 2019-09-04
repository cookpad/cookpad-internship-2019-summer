//
// Copyright © Cookpad Inc. All rights reserved.
//

import Apollo
import Foundation
import APIKit

final class APIClient {
    enum APIError: Error {
        case invalidResult
    }
    private static func makeApolloClient(idToken: String) -> ApolloClient {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(idToken)"
        ]
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return ApolloClient(networkTransport: HTTPNetworkTransport(
            url: URL(string: "[enter_your_endpoint]")!,
            configuration: configuration
        ))
    }

    static let shared: APIClient = .init()
    private var idToken: String?
    let userID: Int
    private init() {
        userID = 12345 // NOTE: 任意のIDを指定してください
    }

    private func getIDToken(session: Session = .shared, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        if let idToken = idToken {
            completion(.success(idToken))
            return
        }
        session.send(AuthoCenterTokenRequest(userID: userID)) { [unowned self] result in
            self.idToken = (try? result.get())?.idToken
            completion(result.map { $0.idToken }.mapError { $0 })
        }
    }

    func getRecipes(page: Int = 1, perPage: Int = 20, completion: @escaping (Swift.Result<[RecipesQuery.Data.Recipe], Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken)
                    .fetch(query: RecipesQuery(page: page, perPage: perPage)) { result in
                        completion(result.map { $0.data?.recipes.compactMap { $0 } ?? [] })
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getRecipe(recipeID: String, completion: @escaping (Swift.Result<RecipeQuery.Data.Recipe, Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken)
                    .fetch(query: RecipeQuery(id: recipeID)) { result in
                        completion(result.flatMap { $0.data?.recipe.flatMap { .success($0) } ?? .failure(APIError.invalidResult) })
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getLikedRecipes(after recipeID: String?, completion: @escaping (Swift.Result<LikesQuery.Data.Like, Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken)
                    .fetch(query: LikesQuery(after: recipeID)) { result in
                        completion(result.flatMap { $0.data?.likes.flatMap { .success($0) } ?? .failure(APIError.invalidResult) })
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func addLike(to recipeID: String, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken).perform(mutation: AddLikeMutation(id: recipeID)) { result in
                        completion(result.map { _ in true })
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func deleteLike(from recipeID: String, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken).perform(mutation: DeleteLikeMutation(id: recipeID)) { result in
                        completion(result.map { _ in false })
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
