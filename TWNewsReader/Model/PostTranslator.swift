//
//  PostTranslator.swift
//  TWNewsReader
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

struct PostTranslator {
    static func translateFromNetworkResponse(data: Data) -> Result<[Post], Error> {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode([Post].self, from: data)
            return Result.success(response)

        } catch {
            return Result.failure(error)
        }
    }
}