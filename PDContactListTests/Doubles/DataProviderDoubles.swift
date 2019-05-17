//
//  DataProviderDoubles.swift
//  PDContactListTests
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

@testable import PDContactList

class DataProviderStub: DataProviderType {

    private var dataSource: DataSource!
    private var payload = [Person]()
    
    func reset() {
        dataSource = nil
        payload = []
    }
    
    func setupForGoodNetwork() {
        payload = stubPayload
        dataSource = .network
    }
    
    func setupForGoodNetworkWithNoData() {
        payload = [Person]()
        dataSource = .network
    }
    
    func setupForBadNeworkWithNoLocalData() {
        payload = [Person]()
        dataSource = .local
    }
    
    func fetchContactLists(completion: @escaping(([Person], DataSource) -> Void)) {
        completion(payload, dataSource)
    }
    
}
