//
//  DataStoreFetchControllerProtocol.swift
//  Tracker
//
//  Created by Kirill on 24.03.2025.
//

import Foundation

protocol DataStoreFetchedControllerProtocol {
    associatedtype DataStoreType
    var numberOfObjects: Int? { get }
    var numberOfSections: Int? { get }
    func numberOfRows(in section: Int) -> Int?
    func object(at indexPath: IndexPath) -> DataStoreType?
    func fetchData()
}
