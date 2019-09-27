//
//  NetworkClient.swift
//  TWNewsReader
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
import Alamofire

let limit:Int = 500
fileprivate let pipedriveAPIKey = Bundle.main.infoDictionary?["PipedriveAPIKey"] as! String

enum RequestType {
    case fetchListItems(startIndex: Int)

    var baseURL: String {
        switch self {
        case .fetchListItems(let startIndex):
            return "https://api.pipedrive.com/v1/persons?start=\(startIndex)&sort=name&limit=\(limit)&api_token="
        }
    }

    var parsingQueueLabel: String {
        switch self {
        case .fetchListItems:
            return "fetchListItems"
        }
    }

    func getURLString() -> String {
        switch self {
        case .fetchListItems:
            return baseURL + pipedriveAPIKey
        }
    }
}

protocol NetworkClientType {
    func request<T>(request: RequestType,
                           translator: @escaping (Data) -> (Result<T, Error>),
                           completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkClient: NetworkClientType {
    static let sharedInstance = NetworkClient()
    private init(){}

    func request<T>(request: RequestType,
                    translator: @escaping (Data) -> (Result<T, Error>),
                    completion: @escaping (Result<T, Error>) -> Void) {

        let queue = DispatchQueue(label: request.parsingQueueLabel,
                                  qos: .background,
                                  attributes: .concurrent)

        AF.request(request.getURLString())
            .response(queue: queue, completionHandler: { (dataResponse) in
                if let data = dataResponse.data {
                    precondition(Thread.isMainThread == false)
                    let translated = translator(data)
                    completion((translated))
                } else if let error = dataResponse.error {
                    completion(Result.failure(error))
                } else {
                    let unknownError = NSError.init(domain: "com.david.TWNewsReader", code: -1, userInfo: ["info": "unknown network error"])
                    completion(Result.failure(unknownError))
                }
            })
    }
}
