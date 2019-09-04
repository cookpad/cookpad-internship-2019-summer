//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}

struct AuthoCenterTokenRequest: Request {
    struct Response: Decodable {
        let idToken: String
        let tokenType: String
        let expiresIn: Int
    }

    let baseURL: URL = URL(string: "[enter_your_auth_center_endpoint]")!
    let method: HTTPMethod = .post
    let path: String = "token"
    let userID: Int
    init(userID: Int) {
        self.userID = userID
    }

    var bodyParameters: BodyParameters? {
        return FormURLEncodedBodyParameters(formObject: [
            "grant_type": "big_fake_password",
            "user_id": "\(userID)",
            "password": "kogaidan",
            "konmai": true // NOTE: 有効期限を伸ばすためのパラメータなので不要になったら外すこと
        ])
    }

    let dataParser: DataParser = DecodableDataParser()

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Response.self, from: data)
    }
}
