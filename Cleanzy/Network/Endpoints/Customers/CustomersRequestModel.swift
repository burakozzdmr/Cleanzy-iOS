//
//  CustomersRequestModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - GetCustomerListRequestModel

struct GetCustomerListRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.customersPath + "/" }
    var method: HTTPMethod { .GET }
}

// MARK: - GetCustomerByIDRequestModel

struct GetCustomerByIDRequestModel: BaseRequest {
    var path: String { NetworkConstants.Endpoints.customersPath + "/\(customerID)" }
    var method: HTTPMethod { .GET }

    let customerID: Int
}
