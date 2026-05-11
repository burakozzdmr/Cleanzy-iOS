//
//  FavoritesRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - AddFavoriteRequestModel

struct AddFavoriteRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.favoritesPath }
    var method: HTTPMethod { .POST }

    let userId: Int
    let favoritedUserId: Int

    var body: Data? {
        try? JSONEncoder().encode(FavoriteBody(userId: userId, favoritedUserId: favoritedUserId))
    }

    private struct FavoriteBody: Encodable {
        let userId: Int
        let favoritedUserId: Int
    }
}

// MARK: - RemoveFavoriteRequestModel

struct RemoveFavoriteRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.favoritesPath }
    var method: HTTPMethod { .DELETE }

    let userId: Int
    let favoritedUserId: Int

    var body: Data? {
        try? JSONEncoder().encode(FavoriteBody(userId: userId, favoritedUserId: favoritedUserId))
    }

    private struct FavoriteBody: Encodable {
        let userId: Int
        let favoritedUserId: Int
    }
}

// MARK: - GetFavoritesByUserIDRequestModel

struct GetFavoritesByUserIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.favoritesPath + "/\(userId)" }
    var method: HTTPMethod { .GET }

    let userId: Int
}
